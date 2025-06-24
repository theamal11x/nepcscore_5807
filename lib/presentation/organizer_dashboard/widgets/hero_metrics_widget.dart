import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> organizerData;
  final bool isNepali;

  const HeroMetricsWidget({
    super.key,
    required this.organizerData,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isNepali ? "मुख्य मेट्रिक्स" : "Key Metrics",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: isNepali ? "आगामी खेलहरू" : "Upcoming Matches",
                  value: "${organizerData["upcomingMatches"]}",
                  icon: 'sports_cricket',
                  color: AppTheme.lightTheme.primaryColor,
                  progress: 0.75,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  title: isNepali ? "सक्रिय टोलीहरू" : "Active Teams",
                  value: "${organizerData["activeTeams"]}",
                  icon: 'groups',
                  color: AppTheme.successLight,
                  progress: 0.85,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: isNepali ? "पेन्डिङ आवेदनहरू" : "Pending Applications",
                  value: "${organizerData["pendingApplications"]}",
                  icon: 'pending_actions',
                  color: AppTheme.warningLight,
                  progress: 0.6,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  title: isNepali ? "पूर्ण खेलहरू" : "Completed Matches",
                  value: "${organizerData["recentMatchCompletions"]}",
                  icon: 'check_circle',
                  color: AppTheme.successLight,
                  progress: 0.9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
