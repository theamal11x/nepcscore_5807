import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatsWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;

  const StatsWidget({
    super.key,
    required this.matchData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Summary
          _buildSectionHeader("Match Summary"),
          SizedBox(height: 1.h),
          _buildMatchSummary(),

          SizedBox(height: 3.h),

          // Run Rate Comparison
          _buildSectionHeader("Run Rate Comparison"),
          SizedBox(height: 1.h),
          _buildRunRateChart(),

          SizedBox(height: 3.h),

          // Partnership Analysis
          _buildSectionHeader("Current Partnership"),
          SizedBox(height: 1.h),
          _buildPartnershipStats(),

          SizedBox(height: 3.h),

          // Bowling Analysis
          _buildSectionHeader("Bowling Analysis"),
          SizedBox(height: 1.h),
          _buildBowlingAnalysis(),

          SizedBox(height: 3.h),

          // Key Stats
          _buildSectionHeader("Key Statistics"),
          SizedBox(height: 1.h),
          _buildKeyStats(),
        ],
      ),
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

  Widget _buildMatchSummary() {
    final team1 = matchData["team1"];
    final team2 = matchData["team2"];

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
          _buildSummaryRow("Team", team1["shortName"], team2["shortName"]),
          SizedBox(height: 1.h),
          _buildSummaryRow("Score", "${team1["score"]}/${team1["wickets"]}",
              "${team2["score"]}/${team2["wickets"]}"),
          SizedBox(height: 1.h),
          _buildSummaryRow("Overs", "${team1["overs"]}", "${team2["overs"]}"),
          SizedBox(height: 1.h),
          _buildSummaryRow(
              "Run Rate",
              "${(team1["score"] / team1["overs"]).toStringAsFixed(2)}",
              "${(team2["score"] / team2["overs"]).toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value1, String value2) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value1,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            value2,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildRunRateChart() {
    return Container(
      height: 30.h,
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
          Text(
            "Run Rate Over Time",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.dividerLight,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}',
                            style: AppTheme.lightTheme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}',
                            style: AppTheme.lightTheme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppTheme.dividerLight),
                ),
                minX: 0,
                maxX: 20,
                minY: 0,
                maxY: 12,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateRunRateSpots(matchData["team1"]),
                    isCurved: true,
                    color: AppTheme.lightTheme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: _generateRunRateSpots(matchData["team2"]),
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(matchData["team1"]["shortName"],
                  AppTheme.lightTheme.primaryColor),
              SizedBox(width: 4.w),
              _buildLegendItem(matchData["team2"]["shortName"], Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall,
        ),
      ],
    );
  }

  List<FlSpot> _generateRunRateSpots(Map<String, dynamic> team) {
    // Mock data for run rate progression
    final List<FlSpot> spots = [];
    final double currentOvers = team["overs"];
    final int currentScore = team["score"];

    for (int i = 0; i <= currentOvers.floor(); i++) {
      final double runRate =
          (currentScore * i / currentOvers) / (i == 0 ? 1 : i);
      spots.add(FlSpot(i.toDouble(), runRate.clamp(0, 12)));
    }

    return spots;
  }

  Widget _buildPartnershipStats() {
    final batsmen = matchData["currentBatsmen"] as List;
    final partnership = batsmen[0]["runs"] + batsmen[1]["runs"];
    final balls = batsmen[0]["balls"] + batsmen[1]["balls"];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("Partnership", "$partnership runs"),
              _buildStatItem("Balls", "$balls balls"),
              _buildStatItem("Run Rate",
                  "${(partnership * 6 / balls).toStringAsFixed(2)}"),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildBatsmanPartnership(batsmen[0]),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildBatsmanPartnership(batsmen[1]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatsmanPartnership(Map<String, dynamic> batsman) {
    return Column(
      children: [
        Text(
          batsman["name"],
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          "${batsman["runs"]}* (${batsman["balls"]})",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "SR: ${batsman["strikeRate"]}",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBowlingAnalysis() {
    final bowler = matchData["currentBowler"];

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
          Text(
            bowler["name"],
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("Overs", "${bowler["overs"]}"),
              _buildStatItem("Runs", "${bowler["runs"]}"),
              _buildStatItem("Wickets", "${bowler["wickets"]}"),
              _buildStatItem("Economy", "${bowler["economy"]}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyStats() {
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
          _buildKeyStatRow("Boundaries", "24", "18"),
          SizedBox(height: 1.h),
          _buildKeyStatRow("Sixes", "8", "5"),
          SizedBox(height: 1.h),
          _buildKeyStatRow("Dot Balls", "45", "38"),
          SizedBox(height: 1.h),
          _buildKeyStatRow("Extras", "13", "9"),
        ],
      ),
    );
  }

  Widget _buildKeyStatRow(String label, String value1, String value2) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value1,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            value2,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }
}
