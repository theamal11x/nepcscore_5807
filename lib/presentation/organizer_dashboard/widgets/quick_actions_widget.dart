import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final bool isNepali;
  final VoidCallback onCreateMatch;
  final VoidCallback onManageTeams;
  final VoidCallback onLiveScoring;
  final VoidCallback onViewReports;

  const QuickActionsWidget({
    super.key,
    required this.isNepali,
    required this.onCreateMatch,
    required this.onManageTeams,
    required this.onLiveScoring,
    required this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isNepali ? "द्रुत कार्यहरू" : "Quick Actions",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  title: isNepali ? "खेल सिर्जना" : "Create Match",
                  icon: 'add_circle',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: onCreateMatch,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionCard(
                  title: isNepali ? "टोली व्यवस्थापन" : "Manage Teams",
                  icon: 'groups',
                  color: AppTheme.successLight,
                  onTap: onManageTeams,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  title: isNepali ? "लाइभ स्कोरिङ" : "Live Scoring",
                  icon: 'sports_score',
                  color: AppTheme.warningLight,
                  onTap: onLiveScoring,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionCard(
                  title: isNepali ? "रिपोर्टहरू" : "View Reports",
                  icon: 'assessment',
                  color: Color(0xFF3F51B5),
                  onTap: onViewReports,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(height: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
