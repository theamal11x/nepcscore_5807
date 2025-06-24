import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LiveScoreWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;
  final bool isRefreshing;

  const LiveScoreWidget({
    super.key,
    required this.matchData,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Score Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Current Score",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCurrentTeamScore(matchData["team1"]),
                    Container(
                      width: 1,
                      height: 8.h,
                      color: AppTheme.dividerLight,
                    ),
                    _buildCurrentTeamScore(matchData["team2"]),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Current Batsmen
          _buildSectionHeader("Current Batsmen"),
          SizedBox(height: 1.h),
          ...(matchData["currentBatsmen"] as List).map(
              (batsman) => _buildBatsmanCard(batsman as Map<String, dynamic>)),

          SizedBox(height: 3.h),

          // Current Bowler
          _buildSectionHeader("Current Bowler"),
          SizedBox(height: 1.h),
          _buildBowlerCard(matchData["currentBowler"]),

          SizedBox(height: 3.h),

          // Last 6 Balls
          _buildSectionHeader("Last 6 Balls"),
          SizedBox(height: 1.h),
          _buildLastBalls(matchData["lastBalls"]),

          SizedBox(height: 3.h),

          // Match Progress
          _buildSectionHeader("Match Progress"),
          SizedBox(height: 1.h),
          _buildMatchProgress(),
        ],
      ),
    );
  }

  Widget _buildCurrentTeamScore(Map<String, dynamic> team) {
    return Column(
      children: [
        Text(
          team["shortName"],
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "${team["score"]}",
          style: AppTheme.lightTheme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          "${team["wickets"]} wickets",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
        Text(
          "${team["overs"]} overs",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBatsmanCard(Map<String, dynamic> batsman) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              batsman["name"],
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${batsman["runs"]}*",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${batsman["balls"]}b",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${batsman["fours"]}×4",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${batsman["sixes"]}×6",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${batsman["strikeRate"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerCard(Map<String, dynamic> bowler) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              bowler["name"],
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${bowler["overs"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${bowler["maidens"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${bowler["runs"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${bowler["wickets"]}",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${bowler["economy"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastBalls(List<dynamic> balls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: balls.map((ball) => _buildBallWidget(ball.toString())).toList(),
    );
  }

  Widget _buildBallWidget(String ball) {
    Color ballColor = AppTheme.lightTheme.colorScheme.surface;
    Color textColor = AppTheme.textHighEmphasisLight;

    if (ball == "4") {
      ballColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (ball == "6") {
      ballColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if (ball == "W") {
      ballColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    } else if (ball == ".") {
      ball = "•";
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ballColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          ball,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchProgress() {
    final team1 = matchData["team1"];
    final team2 = matchData["team2"];
    final maxOvers = 20.0;
    final team1Progress = (team1["overs"] as double) / maxOvers;
    final team2Progress = (team2["overs"] as double) / maxOvers;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProgressRow(team1["shortName"], team1Progress, team1["overs"]),
          SizedBox(height: 2.h),
          _buildProgressRow(team2["shortName"], team2Progress, team2["overs"]),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String teamName, double progress, double overs) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: Text(
            teamName,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
            minHeight: 8,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          "$overs/20.0",
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
