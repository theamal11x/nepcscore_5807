import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodaysMatchesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> matches;
  final bool isNepali;
  final Function(Map<String, dynamic>) onMatchTap;
  final Function(Map<String, dynamic>) onLongPress;

  const TodaysMatchesWidget({
    super.key,
    required this.matches,
    required this.isNepali,
    required this.onMatchTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNepali ? "आजका खेलहरू" : "Today's Matches",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  isNepali ? "सबै हेर्नुहोस्" : "View All",
                  style: TextStyle(color: AppTheme.lightTheme.primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (matches.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return _buildMatchCard(match);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    final bool isLive = match["status"] == "live";
    final bool requiresAttention = match["requiresAttention"] ?? false;

    return GestureDetector(
      onTap: () => onMatchTap(match),
      onLongPress: () => onLongPress(match),
      child: Container(
        margin: EdgeInsets.only(bottom: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: requiresAttention
              ? Border.all(color: AppTheme.warningLight, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isLive)
                            Container(
                              margin: EdgeInsets.only(right: 2.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 1.w,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.errorLight,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    isNepali ? "प्रत्यक्ष" : "LIVE",
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (requiresAttention && !isLive)
                            Container(
                              margin: EdgeInsets.only(right: 2.w),
                              child: CustomIconWidget(
                                iconName: 'warning',
                                color: AppTheme.warningLight,
                                size: 16,
                              ),
                            ),
                          Text(
                            match["time"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.w),
                      Text(
                        "${match["homeTeam"]} vs ${match["awayTeam"]}",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isLive && match["currentScore"].isNotEmpty)
                        Text(
                          match["currentScore"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 1.w),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              match["venue"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isLive)
                  ElevatedButton(
                    onPressed: () => onMatchTap(match),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.w,
                      ),
                    ),
                    child: Text(
                      isNepali ? "स्कोर" : "Score",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  )
                else
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    size: 24,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(8.w),
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
        children: [
          CustomIconWidget(
            iconName: 'sports_cricket',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.3),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            isNepali ? "आज कुनै खेल छैन" : "No matches scheduled for today",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            isNepali
                ? "नयाँ खेल सिर्जना गर्न बटन दबाउनुहोस्"
                : "Tap the button to create a new match",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
