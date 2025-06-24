import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class HeroStatsCardWidget extends StatelessWidget {
  final Map<String, dynamic> playerData;
  final bool isNepali;

  const HeroStatsCardWidget({
    super.key,
    required this.playerData,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'sports_cricket',
                color: AppTheme.lightTheme.primaryColor,
                size: 28,
              ),
              SizedBox(width: 2.w),
              Text(
                isNepali ? "प्रदर्शन सांख्यिकी" : "Performance Stats",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  isNepali ? "सक्रिय" : "Active",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: 'sports_baseball',
                  label: isNepali ? "ब्याटिङ औसत" : "Batting Avg",
                  value: "${playerData["battingAverage"]}",
                  progress: (playerData["battingAverage"] as double) / 100,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  icon: 'sports_tennis',
                  label: isNepali ? "बलिङ फिगर" : "Bowling Fig",
                  value: playerData["bowlingFigures"] as String,
                  progress: 0.75,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: 'trending_up',
                  label: isNepali ? "हालको रन" : "Recent Runs",
                  value: "${playerData["recentMatchRuns"]}",
                  progress: (playerData["recentMatchRuns"] as int) / 100,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  icon: 'emoji_events',
                  label: isNepali ? "खेल संख्या" : "Matches",
                  value: "${playerData["matchesPlayed"]}",
                  progress: 0.9,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'update',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  "${isNepali ? "अन्तिम अपडेट:" : "Last updated:"} ${playerData["lastUpdated"]}",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
          minHeight: 0.5.h,
        ),
      ],
    );
  }
}
