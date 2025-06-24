import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TournamentOverviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tournaments;
  final bool isNepali;

  const TournamentOverviewWidget({
    super.key,
    required this.tournaments,
    required this.isNepali,
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
                isNepali ? "प्रतियोगिता सिंहावलोकन" : "Tournament Overview",
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
          SizedBox(height: 2.h),
          if (tournaments.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tournaments.length > 2 ? 2 : tournaments.length,
              itemBuilder: (context, index) {
                final tournament = tournaments[index];
                return _buildTournamentCard(tournament);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(Map<String, dynamic> tournament) {
    final int matchesPlayed = tournament["matchesPlayed"];
    final int totalMatches = tournament["totalMatches"];
    final double progress = matchesPlayed / totalMatches;

    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
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
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: 'emoji_events',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament["name"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      "${tournament["teamsCount"]} ${isNepali ? "टोलीहरू" : "Teams"}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: tournament["status"] == "ongoing"
                      ? AppTheme.successLight.withValues(alpha: 0.2)
                      : AppTheme.warningLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  tournament["status"] == "ongoing"
                      ? (isNepali ? "चलिरहेको" : "Ongoing")
                      : (isNepali ? "आगामी" : "Upcoming"),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: tournament["status"] == "ongoing"
                        ? AppTheme.successLight
                        : AppTheme.warningLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isNepali ? "प्रगति" : "Progress",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 1.w),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                      minHeight: 1.w,
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      "$matchesPlayed/$totalMatches ${isNepali ? "खेलहरू" : "matches"}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Column(
                children: [
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                  Text(
                    isNepali ? "पूर्ण" : "Complete",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
            iconName: 'emoji_events',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.3),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            isNepali ? "कुनै सक्रिय प्रतियोगिता छैन" : "No active tournaments",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            isNepali
                ? "नयाँ प्रतियोगिता सुरु गर्न टोली व्यवस्थापन प्रयोग गर्नुहोस्"
                : "Use team management to start new tournaments",
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
