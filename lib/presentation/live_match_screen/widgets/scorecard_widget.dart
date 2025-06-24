import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ScorecardWidget extends StatefulWidget {
  final Map<String, dynamic> matchData;

  const ScorecardWidget({
    super.key,
    required this.matchData,
  });

  @override
  State<ScorecardWidget> createState() => _ScorecardWidgetState();
}

class _ScorecardWidgetState extends State<ScorecardWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock detailed scorecard data
  final Map<String, dynamic> _scorecardData = {
    "team1": {
      "name": "Kathmandu Kings",
      "batting": [
        {
          "name": "Rohit Paudel",
          "runs": 45,
          "balls": 32,
          "fours": 6,
          "sixes": 1,
          "strikeRate": 140.6,
          "status": "not out"
        },
        {
          "name": "Kushal Bhurtel",
          "runs": 23,
          "balls": 18,
          "fours": 3,
          "sixes": 0,
          "strikeRate": 127.8,
          "status": "not out"
        },
        {
          "name": "Aasif Sheikh",
          "runs": 34,
          "balls": 28,
          "fours": 4,
          "sixes": 1,
          "strikeRate": 121.4,
          "status": "c Lamichhane b Khadka"
        },
        {
          "name": "Dipendra Singh",
          "runs": 12,
          "balls": 15,
          "fours": 1,
          "sixes": 0,
          "strikeRate": 80.0,
          "status": "b Lamichhane"
        },
        {
          "name": "Aarif Sheikh",
          "runs": 8,
          "balls": 6,
          "fours": 1,
          "sixes": 0,
          "strikeRate": 133.3,
          "status": "run out"
        }
      ],
      "bowling": [
        {
          "name": "Sandeep Lamichhane",
          "overs": 3.4,
          "maidens": 0,
          "runs": 28,
          "wickets": 2,
          "economy": 7.6
        },
        {
          "name": "Sompal Kami",
          "overs": 4.0,
          "maidens": 0,
          "runs": 32,
          "wickets": 1,
          "economy": 8.0
        },
        {
          "name": "Karan KC",
          "overs": 3.0,
          "maidens": 0,
          "runs": 24,
          "wickets": 0,
          "economy": 8.0
        }
      ],
      "extras": {
        "byes": 4,
        "legByes": 2,
        "wides": 6,
        "noBalls": 1,
        "total": 13
      },
      "fallOfWickets": [
        {"wicket": 1, "runs": 45, "over": 6.2, "batsman": "Dipendra Singh"},
        {"wicket": 2, "runs": 78, "over": 11.4, "batsman": "Aarif Sheikh"},
        {"wicket": 3, "runs": 134, "over": 16.3, "batsman": "Aasif Sheikh"}
      ]
    },
    "team2": {
      "name": "Pokhara Warriors",
      "batting": [
        {
          "name": "Kushal Malla",
          "runs": 28,
          "balls": 24,
          "fours": 3,
          "sixes": 1,
          "strikeRate": 116.7,
          "status": "not out"
        },
        {
          "name": "Binod Bhandari",
          "runs": 15,
          "balls": 12,
          "fours": 2,
          "sixes": 0,
          "strikeRate": 125.0,
          "status": "not out"
        },
        {
          "name": "Sharad Vesawkar",
          "runs": 22,
          "balls": 18,
          "fours": 2,
          "sixes": 1,
          "strikeRate": 122.2,
          "status": "c Paudel b Kami"
        },
        {
          "name": "Sunil Dhamala",
          "runs": 8,
          "balls": 10,
          "fours": 1,
          "sixes": 0,
          "strikeRate": 80.0,
          "status": "lbw b KC"
        }
      ],
      "bowling": [
        {
          "name": "Lalit Rajbanshi",
          "overs": 4.0,
          "maidens": 0,
          "runs": 35,
          "wickets": 1,
          "economy": 8.75
        },
        {
          "name": "Bikram Sob",
          "overs": 3.2,
          "maidens": 0,
          "runs": 28,
          "wickets": 2,
          "economy": 8.4
        }
      ],
      "extras": {"byes": 2, "legByes": 3, "wides": 4, "noBalls": 0, "total": 9},
      "fallOfWickets": [
        {"wicket": 1, "runs": 32, "over": 5.1, "batsman": "Sunil Dhamala"},
        {"wicket": 2, "runs": 67, "over": 9.3, "batsman": "Sharad Vesawkar"}
      ]
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: _scorecardData["team1"]["name"]),
              Tab(text: _scorecardData["team2"]["name"]),
            ],
            labelColor: AppTheme.lightTheme.primaryColor,
            unselectedLabelColor: AppTheme.textMediumEmphasisLight,
            indicatorColor: AppTheme.lightTheme.primaryColor,
            labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTeamScorecard(_scorecardData["team1"]),
              _buildTeamScorecard(_scorecardData["team2"]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamScorecard(Map<String, dynamic> teamData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Batting Section
          _buildSectionHeader("Batting"),
          SizedBox(height: 1.h),
          _buildBattingTable(teamData["batting"]),

          SizedBox(height: 3.h),

          // Extras
          _buildExtrasSection(teamData["extras"]),

          SizedBox(height: 3.h),

          // Fall of Wickets
          _buildSectionHeader("Fall of Wickets"),
          SizedBox(height: 1.h),
          _buildFallOfWickets(teamData["fallOfWickets"]),

          SizedBox(height: 3.h),

          // Bowling Section
          _buildSectionHeader("Bowling"),
          SizedBox(height: 1.h),
          _buildBowlingTable(teamData["bowling"]),
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

  Widget _buildBattingTable(List<dynamic> batting) {
    return Container(
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
          // Header
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Batsman",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "R",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "B",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "4s",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "6s",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "SR",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Batting rows
          ...batting.map(
              (batsman) => _buildBattingRow(batsman as Map<String, dynamic>)),
        ],
      ),
    );
  }

  Widget _buildBattingRow(Map<String, dynamic> batsman) {
    final isNotOut = batsman["status"] == "not out";

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batsman["name"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            isNotOut ? AppTheme.lightTheme.primaryColor : null,
                      ),
                    ),
                    if (!isNotOut)
                      Text(
                        batsman["status"],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${batsman["runs"]}${isNotOut ? '*' : ''}",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isNotOut ? AppTheme.lightTheme.primaryColor : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "${batsman["balls"]}",
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "${batsman["fours"]}",
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "${batsman["sixes"]}",
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
        ],
      ),
    );
  }

  Widget _buildExtrasSection(Map<String, dynamic> extras) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Extras",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Byes: ${extras["byes"]}, Leg-byes: ${extras["legByes"]}, Wides: ${extras["wides"]}, No-balls: ${extras["noBalls"]}",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Total: ${extras["total"]}",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallOfWickets(List<dynamic> wickets) {
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
        children: wickets
            .map((wicket) => _buildWicketRow(wicket as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  Widget _buildWicketRow(Map<String, dynamic> wicket) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            "${wicket["wicket"]}-${wicket["runs"]}",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            "(${wicket["batsman"]}, ${wicket["over"]} ov)",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingTable(List<dynamic> bowling) {
    return Container(
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
          // Header
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Bowler",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "O",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "M",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "R",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "W",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Econ",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Bowling rows
          ...bowling.map(
              (bowler) => _buildBowlingRow(bowler as Map<String, dynamic>)),
        ],
      ),
    );
  }

  Widget _buildBowlingRow(Map<String, dynamic> bowler) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              bowler["name"],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: bowler["wickets"] > 0
                    ? AppTheme.lightTheme.primaryColor
                    : null,
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
}
