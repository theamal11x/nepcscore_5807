import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/hero_metrics_widget.dart';
import './widgets/pending_approvals_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/todays_matches_widget.dart';
import './widgets/tournament_overview_widget.dart';

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  State<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isNepali = false;
  bool _isRefreshing = false;

  // Mock organizer data
  final Map<String, dynamic> organizerData = {
    "name": "Sunil Gavaskar",
    "organization": "Mumbai Cricket Association",
    "activeTournaments": 3,
    "upcomingMatches": 12,
    "activeTeams": 24,
    "pendingApplications": 8,
    "recentMatchCompletions": 15,
    "profileImage":
        "https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg",
    "lastUpdated": "1 minute ago"
  };

  final List<Map<String, dynamic>> todaysMatches = [
    {
      "id": 1,
      "homeTeam": "Mumbai Indians",
      "awayTeam": "Chennai Super Kings",
      "time": "14:00",
      "venue": "Wankhede Stadium",
      "status": "live",
      "requiresAttention": true,
      "currentScore": "MI 145/4 (18.2)"
    },
    {
      "id": 2,
      "homeTeam": "Royal Challengers",
      "awayTeam": "Delhi Capitals",
      "time": "19:30",
      "venue": "M. Chinnaswamy Stadium",
      "status": "upcoming",
      "requiresAttention": false,
      "currentScore": ""
    }
  ];

  final List<Map<String, dynamic>> pendingApprovals = [
    {
      "id": 1,
      "type": "team_application",
      "teamName": "Kolkata Knights",
      "playerName": "Virat Kohli",
      "position": "Captain",
      "appliedDate": "2024-01-12"
    },
    {
      "id": 2,
      "type": "match_request",
      "requestingTeam": "Punjab Kings",
      "opponentTeam": "Rajasthan Royals",
      "requestedDate": "2024-01-20",
      "venue": "PCA Stadium"
    }
  ];

  final List<Map<String, dynamic>> tournaments = [
    {
      "id": 1,
      "name": "IPL 2024",
      "teamsCount": 8,
      "matchesPlayed": 45,
      "totalMatches": 74,
      "status": "ongoing"
    },
    {
      "id": 2,
      "name": "Mumbai Premier League",
      "teamsCount": 12,
      "matchesPlayed": 28,
      "totalMatches": 66,
      "status": "ongoing"
    }
  ];

  final List<Map<String, dynamic>> recentActivity = [
    {
      "id": 1,
      "type": "match_completed",
      "title": "Match Result Updated",
      "description": "Mumbai Indians won by 6 wickets",
      "timestamp": "2 hours ago",
      "icon": "sports_cricket"
    },
    {
      "id": 2,
      "type": "team_joined",
      "title": "New Team Registration",
      "description": "Gujarat Titans joined IPL 2024",
      "timestamp": "4 hours ago",
      "icon": "groups"
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
                    HeroMetricsWidget(
                      organizerData: organizerData,
                      isNepali: _isNepali,
                    ),
                    SizedBox(height: 3.h),
                    QuickActionsWidget(
                      isNepali: _isNepali,
                      onCreateMatch: _handleCreateMatch,
                      onManageTeams: _handleManageTeams,
                      onLiveScoring: _handleLiveScoring,
                      onViewReports: _handleViewReports,
                    ),
                    SizedBox(height: 3.h),
                    TodaysMatchesWidget(
                      matches: todaysMatches,
                      isNepali: _isNepali,
                      onMatchTap: _handleMatchTap,
                      onLongPress: _handleMatchLongPress,
                    ),
                    SizedBox(height: 3.h),
                    PendingApprovalsWidget(
                      approvals: pendingApprovals,
                      isNepali: _isNepali,
                      onApprove: _handleApprove,
                      onDecline: _handleDecline,
                    ),
                    SizedBox(height: 3.h),
                    TournamentOverviewWidget(
                      tournaments: tournaments,
                      isNepali: _isNepali,
                    ),
                    SizedBox(height: 3.h),
                    RecentActivityWidget(
                      activities: recentActivity,
                      isNepali: _isNepali,
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
        onPressed: _handleQuickMatchCreation,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'add',
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
                      imageUrl: organizerData["profileImage"] as String,
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
                          _isNepali
                              ? "आयोजक ड्यासबोर्ड"
                              : "Organizer Dashboard",
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          organizerData["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          organizerData["organization"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 24,
                      ),
                      if (organizerData["pendingApplications"] > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(0.5.w),
                            decoration: BoxDecoration(
                              color: AppTheme.errorLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 4.w,
                              minHeight: 4.w,
                            ),
                            child: Text(
                              "${organizerData["pendingApplications"]}",
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 8.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 4.w),
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

    // Simulate API call with haptic feedback
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleCreateMatch() {
    Navigator.pushNamed(context, '/match-creation-screen');
  }

  void _handleManageTeams() {
    Navigator.pushNamed(context, '/team-management-screen');
  }

  void _handleLiveScoring() {
    Navigator.pushNamed(context, '/live-match-screen');
  }

  void _handleViewReports() {
    // Navigate to reports screen when available
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNepali
              ? "रिपोर्ट सुविधा छिट्टै उपलब्ध"
              : "Reports feature coming soon",
        ),
      ),
    );
  }

  void _handleMatchTap(Map<String, dynamic> match) {
    if (match["status"] == "live") {
      Navigator.pushNamed(context, '/live-match-screen');
    } else {
      _showMatchDetailsModal(match);
    }
  }

  void _handleMatchLongPress(Map<String, dynamic> match) {
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
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label:
                        Text(_isNepali ? "सम्पादन गर्नुहोस्" : "Edit Details"),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'cancel',
                      color: AppTheme.errorLight,
                      size: 20,
                    ),
                    label: Text(_isNepali ? "रद्द गर्नुहोस्" : "Cancel Match"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: Text(
                  _isNepali ? "जानकारी साझा गर्नुहोस्" : "Share Information"),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showMatchDetailsModal(Map<String, dynamic> match) {
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
              "${match["time"]} at ${match["venue"]}",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(_isNepali ? "विवरण हेर्नुहोस्" : "View Details"),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleApprove(Map<String, dynamic> approval) {
    setState(() {
      approval["status"] = "approved";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNepali ? "अनुमोदन गरियो" : "Approved successfully",
        ),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleDecline(Map<String, dynamic> approval) {
    setState(() {
      approval["status"] = "declined";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNepali ? "अस्वीकार गरियो" : "Declined successfully",
        ),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }

  void _handleQuickMatchCreation() {
    Navigator.pushNamed(context, '/match-creation-screen');
  }
}
