import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/subscription_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/subscription_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import 'controller/upgrade_premium_controller.dart';

class InAppPurchaseSubscriptionScreen extends StatefulWidget {
  const InAppPurchaseSubscriptionScreen({super.key});

  @override
  State<InAppPurchaseSubscriptionScreen> createState() =>
      _InAppPurchaseSubscriptionScreenState();
}

class _InAppPurchaseSubscriptionScreenState
    extends State<InAppPurchaseSubscriptionScreen> {
  late final UpgradePremiumController _ctrl;
  late final SubscriptionController _sub;

  // Track which plan is currently being purchased for per-card loading state
  String? _purchasingPlanKey;
  Worker? _errorWorker;
  Worker? _successWorker;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(UpgradePremiumController());
    _sub = _ctrl.sub;

    // Listen to purchase results and show feedback
    _errorWorker = ever(_sub.purchaseError, (String msg) {
      if (msg.isNotEmpty && mounted) {
        setState(() => _purchasingPlanKey = null);
        _showSnack(msg, isError: true);
        _sub.purchaseError.value = '';
      }
    });

    _successWorker = ever(_sub.purchaseSuccess, (String msg) {
      if (msg.isNotEmpty && mounted) {
        setState(() => _purchasingPlanKey = null);
        _showSuccessDialog(msg);
        _sub.purchaseSuccess.value = '';
      }
    });
  }

  @override
  void dispose() {
    _errorWorker?.dispose();
    _successWorker?.dispose();
    super.dispose();
  }


  Future<void> _subscribe(SubscriptionPlanModel plan) async {
    if (_sub.purchasing.value) return;
    setState(() => _purchasingPlanKey = plan.key);
    await _sub.buyPlan(plan);
    if (mounted) setState(() => _purchasingPlanKey = null);
  }

  Future<void> _restore() async {
    try {
      await _sub.restorePurchases();
    } catch (e) {
      _showSnack('Restore failed: $e', isError: true);
    }
  }



  void _showSnack(String msg, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.red.shade700 : AppColors.primaryColorC79235,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.backgColor20272E,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColorC79235.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryColorC79235,
                  size: 40.r,
                ),
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: 'Subscription Activated!',
                fontsize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: message,
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorBDC2C6,
                maxline: 3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              CustomButton(
                title: 'Continue',
                height: 50.h,
                onpress: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // close bottom sheet
                  _sub.getMySubscription(); // refresh subscription status
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: Container(
        color: AppColors.bgColor,
        child: Column(
          children: [
            // Drag handle
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderColor4D3814,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 8.h),
            // Header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textColorFFFFFF,
                      size: 22.r,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      text: 'Choose Your Plan',
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColorFFFFFF,
                    ),
                  ),
                  TextButton(
                    onPressed: _restore,
                    child: CustomText(
                      text: 'Restore',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColorC79235,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.borderColor4D3814, height: 1),
            // Body
            Expanded(child: Obx(() => _buildBody())),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_sub.plansLoading.value && _sub.plans.isEmpty) {
      return Center(
        child: SpinKitFadingCircle(
          color: AppColors.primaryColorC79235,
          size: 48.r,
        ),
      );
    }

    if (_sub.plans.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.textColor8C8C8C,
                size: 56.r,
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'No subscription plans available',
                fontsize: 14.sp,
                color: AppColors.textColorBDC2C6,
                maxline: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                title: 'Retry',
                onpress: _sub.loadAll,
                width: 140.w,
                height: 48.h,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildHeader(),
            SizedBox(height: 24.h),
            ..._sub.plans.map(_buildPlanCard),
            SizedBox(height: 12.h),
            _buildFooter(),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }



  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColorC79235,
            AppColors.secondary836531,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 32.r,
            ),
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: 'Upgrade to Premium',
            fontsize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: 'Unlock all stories with a subscription',
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.80),
          ),
        ],
      ),
    );
  }

  // ── Plan Card ──────────────────────────────────────────────────────────────

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    final currentKey = _sub.mySubscription.value?.active == true
        ? _sub.mySubscription.value?.planKey
        : null;
    final isCurrent = plan.key == currentKey;
    final isMonthly = plan.key?.toLowerCase() == 'monthly' ||
        (plan.durationDays != null &&
            plan.durationDays! >= 28 &&
            plan.durationDays! < 365);
    final isThisPurchasing = _purchasingPlanKey == plan.key;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.backgColor20272E,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrent
              ? AppColors.primaryColorC79235
              : AppColors.borderColor4D3814,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Most Popular" badge on monthly plan
          if (isMonthly)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColorC79235,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                ),
              ),
              child: CustomText(
                text: 'MOST POPULAR',
                fontsize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          textAlign: TextAlign.start,
                          text: plan.name ?? plan.key ?? 'Plan',
                          fontsize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColorFFFFFF,
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColorC79235
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            text: _periodLabel(plan),
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColorC79235,
                          ),
                        ),
                      ],
                    ),
                    // Radio indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primaryColorC79235
                              : AppColors.borderColor4D3814,
                          width: 2,
                        ),
                      ),
                      child: isCurrent
                          ? Center(
                              child: Container(
                                width: 11.r,
                                height: 11.r,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColorC79235,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      // Prefer the store's localized price so the amount the
                      // user is charged matches what the paywall advertises.
                      text: _sub.storePriceFor(plan) ?? plan.priceLabel,
                      fontsize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColorC79235,
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: '/ ${_periodLabel(plan).toLowerCase()}',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor8C8C8C,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),
                Divider(color: AppColors.borderColor4D3814, height: 1),
                SizedBox(height: 14.h),

                // Features
                if (plan.features.isNotEmpty)
                  ...plan.features.map(
                    (f) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryColorC79235,
                            size: 17.r,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              textAlign: TextAlign.start,
                              text: f,
                              fontsize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColorBDC2C6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 18.h),

                // Subscribe button
                CustomButton(
                  title: isCurrent
                      ? 'Current Plan'
                      : isThisPurchasing
                          ? 'Processing...'
                          : 'Subscribe Now',
                  loading: isThisPurchasing,
                  color: isCurrent
                      ? AppColors.textColor323539
                      : AppColors.buttonColorE8A533,
                  height: 50.h,
                  onpress: () {
                    if (isCurrent) return;
                    _subscribe(plan);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Column(
      children: [
        GestureDetector(
          onTap: _restore,
          child: CustomText(
            text: 'Restore Purchases',
            fontsize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorC79235,
          ),
        ),
        SizedBox(height: 10.h),
        CustomText(
          text: 'Payment is charged to your store account at confirmation of '
              'purchase. The subscription renews automatically for the same '
              'period and price unless it is cancelled at least 24 hours '
              'before the end of the current period. Manage or cancel it any '
              'time in your device account settings.',
          fontsize: 11.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor8C8C8C,
          maxline: 8,
          textOverflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        // Apple guideline 3.1.2(c): the purchase flow itself must link to the
        // Terms of Use (EULA) and the privacy policy.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legalLink('Terms of Use (EULA)', AppRoutes.termsServicesScreen),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomText(
                text: '•',
                fontsize: 12.sp,
                color: AppColors.textColor8C8C8C,
              ),
            ),
            _legalLink('Privacy Policy', AppRoutes.privacyPolicyScreen),
          ],
        ),
      ],
    );
  }

  Widget _legalLink(String label, String routeName) {
    return GestureDetector(
      onTap: () => context.pushNamed(routeName),
      child: CustomText(
        text: label,
        fontsize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColorC79235,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _periodLabel(SubscriptionPlanModel plan) {
    final key = plan.key?.toLowerCase() ?? '';
    if (key == 'yearly' || (plan.durationDays != null && plan.durationDays! >= 365)) {
      return 'Yearly';
    }
    if (key == 'monthly' || (plan.durationDays != null && plan.durationDays! >= 28)) {
      return 'Monthly';
    }
    if (key == 'weekly' || (plan.durationDays != null && plan.durationDays! >= 7)) {
      return 'Weekly';
    }
    return 'Monthly';
  }
}
