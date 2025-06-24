import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TeamPlayerCardWidget extends StatelessWidget {
  final Map<String, dynamic> player;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TeamPlayerCardWidget({
    super.key,
    required this.player,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Player Photo
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getStatusColor(player['status']),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: player['photo'] ?? '',
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    // Player Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  player['name'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (player['role']?.contains('Captain') == true)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(1.w),
                                  ),
                                  child: Text(
                                    'C',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            player['role'] ?? '',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(player['status'])
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: Text(
                                  player['status'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getStatusColor(player['status']),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPerformanceColor(
                                          player['performance'])
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: Text(
                                  player['performance'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getPerformanceColor(
                                        player['performance']),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Button
                    IconButton(
                      onPressed: onTap,
                      icon: CustomIconWidget(
                        iconName: 'more_vert',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Performance Stats
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Matches',
                          '${player['matches'] ?? 0}',
                          'sports_cricket',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 4.h,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Runs',
                          '${player['runs'] ?? 0}',
                          'trending_up',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 4.h,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Wickets',
                          '${player['wickets'] ?? 0}',
                          'sports_baseball',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 4.h,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Average',
                          '${player['average'] ?? 0.0}',
                          'analytics',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                // Last Match Info
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last match: ${player['lastMatch'] ?? 'N/A'}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'injured':
        return AppTheme.lightTheme.colorScheme.error;
      case 'unavailable':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getPerformanceColor(String? performance) {
    switch (performance?.toLowerCase()) {
      case 'excellent':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'good':
        return Colors.orange;
      case 'average':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      case 'poor':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
