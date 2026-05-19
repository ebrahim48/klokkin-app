import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/subscription_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

/// Drives the subscription screen.
///
/// Payment model: the actual money movement is handled by the platform
/// store via the `in_app_purchase` plugin. The backend only *records* the
/// resulting store receipt (`/subscription/purchase`) and grants access —
/// it is idempotent on `transactionId`, so replaying never double-grants.
///
/// In debug builds (no configured store products) a "simulate purchase"
/// path posts a generated transactionId so the whole flow is testable
/// without App Store / Play Console setup.
class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  final RxBool plansLoading = false.obs;
  final RxBool statusLoading = false.obs;
  final RxBool transactionsLoading = false.obs;
  final RxBool purchasing = false.obs;
  final RxString purchaseError = ''.obs;
  final RxString purchaseSuccess = ''.obs;

  final RxList<SubscriptionPlanModel> plans = <SubscriptionPlanModel>[].obs;
  final Rxn<MySubscriptionModel> mySubscription = Rxn<MySubscriptionModel>();
  final RxList<SubscriptionTransactionModel> transactions =
      <SubscriptionTransactionModel>[].obs;

  // The plan being purchased (so the store-stream callback knows which
  // plan to record once the platform confirms the purchase).
  SubscriptionPlanModel? _pendingPlan;

  @override
  void onInit() {
    super.onInit();
    _purchaseSub = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (e) {
        purchasing.value = false;
        purchaseError.value = 'Purchase error: $e';
        debugPrint('====> [IAP] Stream error: $e');
      },
    );
  }

  @override
  void onClose() {
    _purchaseSub?.cancel();
    super.onClose();
  }

  Future<void> loadAll() async {
    await Future.wait([
      getPlans(),
      getMySubscription(),
      getTransactions(),
    ]);
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  // -------------------------------------------------------------- reads

  Future<void> getPlans() async {
    plansLoading(true);
    final response =
        await ApiClient.getData(ApiConstants.subscriptionPlansEndPoint);
    if (response.statusCode == 200) {
      final list = response.body["data"]["attributes"] as List? ?? [];
      plans.value = list
          .map((x) =>
              SubscriptionPlanModel.fromJson(Map<String, dynamic>.from(x)))
          .toList();
    }
    plansLoading(false);
  }

  Future<void> getMySubscription() async {
    statusLoading(true);
    final response =
        await ApiClient.getData(ApiConstants.mySubscriptionEndPoint);
    if (response.statusCode == 200) {
      mySubscription.value = MySubscriptionModel.fromJson(
          Map<String, dynamic>.from(response.body["data"]["attributes"]));
    }
    statusLoading(false);
  }

  Future<void> getTransactions() async {
    transactionsLoading(true);
    final response = await ApiClient.getData(
        ApiConstants.subscriptionTransactionsEndPoint());
    if (response.statusCode == 200) {
      final attr = response.body["data"]["attributes"];
      final list = (attr is Map ? attr["data"] : attr) as List? ?? [];
      transactions.value = list
          .map((x) => SubscriptionTransactionModel.fromJson(
              Map<String, dynamic>.from(x)))
          .toList();
    }
    transactionsLoading(false);
  }

  // ---------------------------------------------------------- purchase

  bool get _isIOS => Platform.isIOS;
  String get _platform => _isIOS ? 'ios' : 'android';
  String get _store => _isIOS ? 'app_store' : 'play_store';

  String? _storeProductId(SubscriptionPlanModel plan) {
    final ids = _isIOS ? plan.appleProductIds : plan.googleProductIds;
    if (ids.isNotEmpty) return ids.first;
    // Fallback to hardcoded Play Store product IDs by plan key
    switch (plan.key?.toLowerCase()) {
      case 'weekly': return 'klokkin_weekly';
      case 'monthly': return 'klokkin_monthly';
      case 'yearly': return 'klokkin_yearly';
      default: return null;
    }
  }

  Future<void> buyPlan(SubscriptionPlanModel plan) async {
    if (purchasing.value) return;
    purchasing(true);
    _pendingPlan = plan;

    try {
      await _buyViaStore(plan);
      // result comes back via _onPurchaseUpdated
    } catch (e) {
      purchasing(false);
      _pendingPlan = null;
      purchaseError.value = 'Could not start purchase: $e';
      debugPrint('====> [IAP] Buy error: $e');
    }
  }

  Future<void> _buyViaStore(SubscriptionPlanModel plan) async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw 'Store is not available on this device';
    }

    final productId = _storeProductId(plan);
    if (productId == null) {
      throw 'No store product configured for "${plan.key}" on $_platform';
    }

    final ProductDetailsResponse resp =
        await _iap.queryProductDetails({productId});
    debugPrint('====> [IAP] Query "$productId" — found: ${resp.productDetails.length}, errors: ${resp.error?.message}');
    if (resp.productDetails.isEmpty) {
      throw 'Product "$productId" not found in Play Store. Check Play Console setup.';
    }

    final param = PurchaseParam(productDetails: resp.productDetails.first);
    // Subscriptions are non-consumable from the plugin's perspective.
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          purchasing(true);
          break;
        case PurchaseStatus.canceled:
          purchasing(false);
          _pendingPlan = null;
          break;
        case PurchaseStatus.error:
          purchasing(false);
          _pendingPlan = null;
          purchaseError.value = p.error?.message ?? 'Purchase failed';
          debugPrint('====> [IAP] Purchase error: ${p.error?.message}');
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final plan = _pendingPlan;
          if (plan != null) {
            await _recordPurchase(
              plan: plan,
              productId: p.productID,
              transactionId: p.purchaseID ??
                  '${p.productID}_${DateTime.now().millisecondsSinceEpoch}',
              purchaseToken: p.verificationData.serverVerificationData,
            );
          }
          if (p.pendingCompletePurchase) {
            await _iap.completePurchase(p);
          }
          purchasing(false);
          _pendingPlan = null;
          break;
      }
    }
  }

  /// Reports the store receipt to the backend to activate the subscription.
  Future<void> _recordPurchase({
    required SubscriptionPlanModel plan,
    required String productId,
    required String transactionId,
    String? purchaseToken,
  }) async {
    final body = {
      "planKey": plan.key,
      "platform": _platform,
      "productId": productId,
      "transactionId": transactionId,
      if (purchaseToken != null && purchaseToken.isNotEmpty)
        "purchaseToken": purchaseToken,
      "store": _store,
      if (plan.price != null) "amount": plan.price,
      if (plan.currency != null) "currency": plan.currency,
    };

    final response = await ApiClient.postData(
      ApiConstants.subscriptionPurchaseEndPoint,
      jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = MySubscriptionModel.fromJson(
          Map<String, dynamic>.from(response.body["data"]["attributes"]));
      mySubscription.value = result;
      purchaseSuccess.value = result.alreadyProcessed
          ? 'This purchase was already applied'
          : '${plan.name ?? plan.key} activated successfully';
      debugPrint('====> [IAP] Backend confirmed: ${purchaseSuccess.value}');
      await getTransactions();
    } else {
      purchaseError.value = response.body is Map
          ? (response.body["message"]?.toString() ?? 'Purchase failed')
          : 'Purchase failed';
      debugPrint('====> [IAP] Backend error: ${purchaseError.value}');
    }
  }
}
