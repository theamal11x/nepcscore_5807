import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ball_input_modal.dart';
import './widgets/commentary_widget.dart';
import './widgets/fan_engagement_widget.dart';
import './widgets/live_score_widget.dart';
import './widgets/scorecard_widget.dart';
import './widgets/stats_widget.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final bool _isConnected = true;
  bool _isRefreshing = false;

  // Mock match data
  final Map<String, dynamic> _matchData = {
    "matchId": "M001",
    "title": "Kathmandu Kings vs Pokhara Warriors",
    "status": "Live",
    "currentInning": 1,
    "team1": {
      "name": "Kathmandu Kings",
      "shortName": "KTM",
      "score": 156,
      "wickets": 4,
      "overs": 18.3,
      "logo":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=100&h=100&fit=crop"
    },
    "team2": {
      "name": "Pokhara Warriors",
      "shortName": "PKR",
      "score": 89,
      "wickets": 2,
      "overs": 12.4,
      "logo":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop"
    },
    "currentBatsmen": [
      {
        "name": "Rohit Paudel",
        "runs": 45,
        "balls": 32,
        "fours": 6,
        "sixes": 1,
        "strikeRate": 140.6
      },
      {
        "name": "Kushal Bhurtel",
        "runs": 23,
        "balls": 18,
        "fours": 3,
        "sixes": 0,
        "strikeRate": 127.8
      }
    ],
    "currentBowler": {
      "name": "Sandeep Lamichhane",
      "overs": 3.4,
      "maidens": 0,
      "runs": 28,
      "wickets": 1,
      "economy": 7.6
    },
    "lastBalls": ["4", "1", "W", ".", "6", "2"],
    "commentary": [
      {
        "id": 1,
        "over": "18.3",
        "text":
            "FOUR! Rohit Paudel finds the gap through covers. Brilliant shot!",
        "timestamp": "2 min ago",
        "type": "boundary"
      },
      {
        "id": 2,
        "over": "18.2",
        "text":
            "Single taken to deep mid-wicket. Good running between the wickets.",
        "timestamp": "3 min ago",
        "type": "run"
      },
      {
        "id": 3,
        "over": "18.1",
        "text":
            "WICKET! Aasif Sheikh caught behind! What a delivery from Lamichhane!",
        "timestamp": "4 min ago",
        "type": "wicket"
      }
    ],
    "polls": [
      {
        "id": 1,
        "question": "Who will win this match?",
        "options": [
          {"text": "Kathmandu Kings", "votes": 156, "percentage": 62},
          {"text": "Pokhara Warriors", "votes": 95, "percentage": 38}
        ],
        "totalVotes": 251,
        "userVoted": false
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _simulateRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateRealTimeUpdates() {
    // Simulate real-time updates every 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          // Update scores randomly
          _matchData["team1"]["score"] += 1;
          if (_matchData["team1"]["score"] % 4 == 0) {
            HapticFeedback.mediumImpact();
          }
        });
        _simulateRealTimeUpdates();
      }
    });
  }

  Future<void> _refreshMatch() async {
    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showBallInputModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BallInputModal(
        onBallSubmitted: (ballData) {
          setState(() {
            // Update match data with new ball
            _matchData["lastBalls"].insert(0, ballData["runs"].toString());
            if (_matchData["lastBalls"].length > 6) {
              _matchData["lastBalls"].removeLast();
            }
          });
          HapticFeedback.mediumImpact();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Match Title and Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _matchData["title"],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              _matchData["status"],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      // Connection Status
                      CustomIconWidget(
                        iconName: _isConnected ? 'wifi' : 'wifi_off',
                        color:
                            _isConnected ? Colors.white : Colors.red.shade300,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  // Teams Score
                  Row(
                    children: [
                      Expanded(
                        child: _buildTeamScore(_matchData["team1"], true),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text(
                          "VS",
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildTeamScore(_matchData["team2"], false),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Live Score"),
                  Tab(text: "Commentary"),
                  Tab(text: "Scorecard"),
                  Tab(text: "Stats"),
                ],
                labelColor: AppTheme.lightTheme.primaryColor,
                unselectedLabelColor: AppTheme.textMediumEmphasisLight,
                indicatorColor: AppTheme.lightTheme.primaryColor,
                labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshMatch,
                color: AppTheme.lightTheme.primaryColor,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LiveScoreWidget(
                      matchData: _matchData,
                      isRefreshing: _isRefreshing,
                    ),
                    CommentaryWidget(
                      commentary: (_matchData["commentary"] as List)
                          .cast<Map<String, dynamic>>(),
                      isRefreshing: _isRefreshing,
                    ),
                    ScorecardWidget(
                      matchData: _matchData,
                    ),
                    StatsWidget(
                      matchData: _matchData,
                    ),
                  ],
                ),
              ),
            ),

            // Fan Engagement Section
            FanEngagementWidget(
              polls: (_matchData["polls"] as List).cast<Map<String, dynamic>>(),
              onVote: (pollId, optionIndex) {
                setState(() {
                  final poll = (_matchData["polls"] as List)
                      .firstWhere((p) => p["id"] == pollId);
                  poll["userVoted"] = true;
                  poll["options"][optionIndex]["votes"]++;
                  poll["totalVotes"]++;
                });
                HapticFeedback.selectionClick();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBallInputModal,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'sports_cricket',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTeamScore(Map<String, dynamic> team, bool isLeft) {
    return Row(
      mainAxisAlignment:
          isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (!isLeft) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  team["name"],
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${team["score"]}/${team["wickets"]} (${team["overs"]})",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CustomImageWidget(
            imageUrl: team["logo"],
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        if (isLeft) ...[
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team["name"],
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${team["score"]}/${team["wickets"]} (${team["overs"]})",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
