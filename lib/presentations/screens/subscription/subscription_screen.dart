import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/subscription_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/subscription_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.loadAll());
  }

  String _fmtDate(DateTime? d) =>
      d == null ? '—' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColorC79235),
        title: CustomText(
          text: 'Subscription',
          color: AppColors.textColorFFFFFF,
          fontsize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentStatusCard(),
              SizedBox(height: 24.h),
              CustomText(
                text: 'Choose a plan',
                color: AppColors.textColorFFFFFF,
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              _plansList(),
              SizedBox(height: 24.h),
              CustomText(
                text: 'Purchase history',
                color: AppColors.textColorFFFFFF,
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              _transactionsList(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------- current status

  Widget _currentStatusCard() {
    return Obx(() {
      if (controller.statusLoading.value &&
          controller.mySubscription.value == null) {
        return _skeletonBox(height: 120.h);
      }
      final sub = controller.mySubscription.value;
      final active = sub?.active ?? false;
      final usage = sub?.usage;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: active
                ? [AppColors.primaryColorC79235, AppColors.secondary836531]
                : [AppColors.backgColor20272E, AppColors.textColor323539],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.borderColor4D3814),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: active
                      ? (sub?.plan?.name ?? sub?.planKey ?? 'Active plan')
                      : 'No active subscription',
                  color: AppColors.textColorFFFFFF,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.green.withValues(alpha: 0.85)
                        : AppColors.textColor8C8C8C,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: active ? 'ACTIVE' : 'INACTIVE',
                    color: AppColors.textColorFFFFFF,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (active) ...[
              SizedBox(height: 10.h),
              CustomText(
                textAlign: TextAlign.start,
                text: 'Renews / ends: ${_fmtDate(sub?.endDate)}',
                color: AppColors.textColorF5F9FE,
                fontsize: 13.sp,
              ),
              SizedBox(height: 6.h),
              CustomText(
                textAlign: TextAlign.start,
                text: usage == null
                    ? ''
                    : usage.unlimited
                        ? 'Stories: unlimited'
                        : 'Stories: ${usage.used} used · ${usage.remaining ?? 0} left',
                color: AppColors.textColorF5F9FE,
                fontsize: 13.sp,
              ),
            ],
          ],
        ),
      );
    });
  }

  // ------------------------------------------------------------- plans

  Widget _plansList() {
    return Obx(() {
      if (controller.plansLoading.value && controller.plans.isEmpty) {
        return Column(
          children: List.generate(
              3,
              (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _skeletonBox(height: 150.h),
                  )),
        );
      }
      if (controller.plans.isEmpty) {
        return _emptyHint('No plans available right now');
      }
      final currentKey = controller.mySubscription.value?.active == true
          ? controller.mySubscription.value?.planKey
          : null;

      return Column(
        children: controller.plans
            .map((p) => _planCard(p, isCurrent: p.key == currentKey))
            .toList(),
      );
    });
  }

  Widget _planCard(SubscriptionPlanModel plan, {required bool isCurrent}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgColor20272E,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCurrent
              ? AppColors.primaryColorC79235
              : AppColors.borderColor4D3814,
          width: isCurrent ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: plan.name ?? plan.key ?? 'Plan',
                color: AppColors.textColorFFFFFF,
                fontsize: 17.sp,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text:
                    '${plan.priceLabel} / ${plan.durationDays ?? 30}d',
                color: AppColors.primaryColorC79235,
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            CustomText(
              textAlign: TextAlign.start,
              text: plan.description!,
              color: AppColors.textColorC2C2C2,
              fontsize: 12.sp,
            ),
          ],
          SizedBox(height: 10.h),
          ...plan.features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle,
                      size: 15.sp, color: AppColors.primaryColorC79235),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: f,
                      color: AppColors.textColorBDC2C6,
                      fontsize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          CustomText(
            textAlign: TextAlign.start,
            text: plan.unlimited
                ? 'Unlimited stories / period'
                : '${plan.monthlyStoryLimit ?? 0} stories / period',
            color: AppColors.textColor8C8C8C,
            fontsize: 12.sp,
          ),
          SizedBox(height: 12.h),
          Obx(() => CustomButton(
                title: isCurrent ? 'Current plan' : 'Subscribe',
                loading: controller.purchasing.value,
                color: isCurrent
                    ? AppColors.textColor323539
                    : AppColors.buttonColorE8A533,
                onpress: () {
                  if (isCurrent) return;
                  controller.buyPlan(plan);
                },
              )),
        ],
      ),
    );
  }

  // ------------------------------------------------------ transactions

  Widget _transactionsList() {
    return Obx(() {
      if (controller.transactionsLoading.value &&
          controller.transactions.isEmpty) {
        return _skeletonBox(height: 80.h);
      }
      if (controller.transactions.isEmpty) {
        return _emptyHint('No purchases yet');
      }
      return Column(
        children: controller.transactions.map((t) {
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.backgColor20272E,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderColor4D3814),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: '${t.planKey ?? '-'} · ${t.type ?? 'purchase'}',
                      color: AppColors.textColorFFFFFF,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: _fmtDate(t.createdAt),
                      color: AppColors.textColor8C8C8C,
                      fontsize: 11.sp,
                    ),
                  ],
                ),
                CustomText(
                  text:
                      '${(t.currency ?? 'USD').toUpperCase() == 'USD' ? '\$' : '${t.currency} '}${t.amount ?? 0}',
                  color: AppColors.primaryColorC79235,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // ----------------------------------------------------------- helpers

  Widget _skeletonBox({required double height}) => Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgColor20272E,
          borderRadius: BorderRadius.circular(12.r),
        ),
      );

  Widget _emptyHint(String text) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          color: AppColors.textColorC2C2C2,
          fontsize: 13.sp,
        ),
      );
}
