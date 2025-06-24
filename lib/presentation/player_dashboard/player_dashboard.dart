import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/hero_stats_card_widget.dart';
import './widgets/match_invitations_widget.dart';
import './widgets/recent_performance_widget.dart';
import './widgets/team_applications_widget.dart';
import './widgets/upcoming_matches_widget.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isNepali = false;
  bool _isRefreshing = false;

  // Mock player data
  final Map<String, dynamic> playerData = {
    "name": "Rohit Sharma",
    "team": "Mumbai Indians",
    "battingAverage": 45.2,
    "bowlingFigures": "3/25",
    "recentMatchRuns": 78,
    "matchesPlayed": 156,
    "totalRuns": 7056,
    "wicketsTaken": 23,
    "profileImage":
        "https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg",
    "lastUpdated": "2 minutes ago"
  };

  final List<Map<String, dynamic>> upcomingMatches = [
    {
      "id": 1,
      "homeTeam": "Mumbai Indians",
      "awayTeam": "Chennai Super Kings",
      "date": "2024-01-15",
      "time": "19:30",
      "venue": "Wankhede Stadium",
      "matchType": "T20",
      "status": "upcoming"
    },
    {
      "id": 2,
      "homeTeam": "Royal Challengers",
      "awayTeam": "Mumbai Indians",
      "date": "2024-01-18",
      "time": "15:30",
      "venue": "M. Chinnaswamy Stadium",
      "matchType": "ODI",
      "status": "upcoming"
    }
  ];

  final List<Map<String, dynamic>> teamApplications = [
    {
      "id": 1,
      "teamName": "Delhi Capitals",
      "position": "All-rounder",
      "status": "pending",
      "appliedDate": "2024-01-10",
      "teamLogo":
          "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"
    },
    {
      "id": 2,
      "teamName": "Kolkata Knight Riders",
      "position": "Batsman",
      "status": "accepted",
      "appliedDate": "2024-01-08",
      "teamLogo":
          "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"
    }
  ];

  final List<Map<String, dynamic>> matchInvitations = [
    {
      "id": 1,
      "fromTeam": "Rajasthan Royals",
      "matchDate": "2024-01-20",
      "venue": "Sawai Mansingh Stadium",
      "role": "Opening Batsman",
      "status": "pending"
    },
    {
      "id": 2,
      "fromTeam": "Punjab Kings",
      "matchDate": "2024-01-22",
      "venue": "PCA Stadium",
      "role": "All-rounder",
      "status": "pending"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              _buildStickyHeader(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    HeroStatsCardWidget(
                      playerData: playerData,
                      isNepali: _isNepali,
                    ),
                    SizedBox(height: 3.h),
                    UpcomingMatchesWidget(
                      matches: upcomingMatches,
                      isNepali: _isNepali,
                      onMatchTap: _handleMatchTap,
                    ),
                    SizedBox(height: 3.h),
                    RecentPerformanceWidget(
                      playerData: playerData,
                      isNepali: _isNepali,
                    ),
                    SizedBox(height: 3.h),
                    TeamApplicationsWidget(
                      applications: teamApplications,
                      isNepali: _isNepali,
                    ),
                    SizedBox(height: 3.h),
                    MatchInvitationsWidget(
                      invitations: matchInvitations,
                      isNepali: _isNepali,
                      onAccept: _handleInvitationAccept,
                      onDecline: _handleInvitationDecline,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleQuickScoreEntry,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'sports_cricket',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverAppBar(
      expandedHeight: 12.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 3.h,
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    child: CustomImageWidget(
                      imageUrl: playerData["profileImage"] as String,
                      width: 6.h,
                      height: 6.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isNepali ? "खेलाडी ड्यासबोर्ड" : "Player Dashboard",
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          playerData["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          playerData["team"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isNepali,
                    onChanged: (value) {
                      setState(() {
                        _isNepali = value;
                      });
                    },
                    activeColor: AppTheme.lightTheme.colorScheme.surface,
                    inactiveThumbColor: AppTheme.lightTheme.colorScheme.surface,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _isNepali ? "नेपाली" : "EN",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor:
          AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _selectedIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: _isNepali ? "ड्यासबोर्ड" : "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'sports_cricket',
            color: _selectedIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: _isNepali ? "खेलहरू" : "Matches",
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'groups',
            color: _selectedIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: _isNepali ? "टोलीहरू" : "Teams",
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: _isNepali ? "प्रोफाइल" : "Profile",
        ),
      ],
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/live-match-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/team-management-screen');
        break;
      case 3:
        // Navigate to profile screen when available
        break;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleMatchTap(Map<String, dynamic> match) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "${match["homeTeam"]} vs ${match["awayTeam"]}",
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 1.h),
            Text(
              "${match["date"]} at ${match["time"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label:
                        Text(_isNepali ? "विवरण हेर्नुहोस्" : "View Details"),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: Text(_isNepali ? "साझा गर्नुहोस्" : "Share"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleQuickScoreEntry() {
    Navigator.pushNamed(context, '/match-creation-screen');
  }

  void _handleInvitationAccept(Map<String, dynamic> invitation) {
    setState(() {
      invitation["status"] = "accepted";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNepali ? "निमन्त्रणा स्वीकार गरियो" : "Invitation accepted",
        ),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleInvitationDecline(Map<String, dynamic> invitation) {
    setState(() {
      invitation["status"] = "declined";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNepali ? "निमन्त्रणा अस्वीकार गरियो" : "Invitation declined",
        ),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }
}
