import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/match_history_card_widget.dart';
import './widgets/team_application_card_widget.dart';
import './widgets/team_player_card_widget.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  // Mock data for team players
  final List<Map<String, dynamic>> _teamPlayers = [
    {
      "id": 1,
      "name": "Rohit Sharma",
      "role": "Captain/Batsman",
      "photo":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
      "matches": 45,
      "runs": 2340,
      "wickets": 2,
      "average": 52.0,
      "status": "Available",
      "lastMatch": "2024-01-15",
      "performance": "Excellent"
    },
    {
      "id": 2,
      "name": "Virat Kohli",
      "role": "Batsman",
      "photo":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg",
      "matches": 42,
      "runs": 2180,
      "wickets": 0,
      "average": 51.9,
      "status": "Available",
      "lastMatch": "2024-01-15",
      "performance": "Excellent"
    },
    {
      "id": 3,
      "name": "Jasprit Bumrah",
      "role": "Bowler",
      "photo":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg",
      "matches": 38,
      "runs": 120,
      "wickets": 65,
      "average": 18.2,
      "status": "Injured",
      "lastMatch": "2024-01-10",
      "performance": "Good"
    },
    {
      "id": 4,
      "name": "MS Dhoni",
      "role": "Wicket Keeper",
      "photo":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg",
      "matches": 40,
      "runs": 1890,
      "wickets": 0,
      "average": 47.2,
      "status": "Available",
      "lastMatch": "2024-01-15",
      "performance": "Good"
    },
    {
      "id": 5,
      "name": "Hardik Pandya",
      "role": "All Rounder",
      "photo":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
      "matches": 35,
      "runs": 1456,
      "wickets": 28,
      "average": 41.6,
      "status": "Available",
      "lastMatch": "2024-01-15",
      "performance": "Excellent"
    }
  ];

  // Mock data for team applications
  final List<Map<String, dynamic>> _teamApplications = [
    {
      "id": 1,
      "playerName": "Shubman Gill",
      "role": "Batsman",
      "photo":
          "https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg",
      "experience": "3 years",
      "matches": 25,
      "runs": 1200,
      "wickets": 0,
      "average": 48.0,
      "appliedDate": "2024-01-12",
      "message":
          "I am passionate about cricket and would love to contribute to the team's success.",
      "status": "Pending"
    },
    {
      "id": 2,
      "playerName": "Ishan Kishan",
      "role": "Wicket Keeper",
      "photo":
          "https://images.pexels.com/photos/1043473/pexels-photo-1043473.jpeg",
      "experience": "2 years",
      "matches": 18,
      "runs": 890,
      "wickets": 0,
      "average": 49.4,
      "appliedDate": "2024-01-10",
      "message": "Experienced wicket keeper looking for new opportunities.",
      "status": "Pending"
    },
    {
      "id": 3,
      "playerName": "Mohammed Siraj",
      "role": "Bowler",
      "photo":
          "https://images.pexels.com/photos/1239288/pexels-photo-1239288.jpeg",
      "experience": "4 years",
      "matches": 32,
      "runs": 45,
      "wickets": 48,
      "average": 22.1,
      "appliedDate": "2024-01-08",
      "message": "Fast bowler with good pace and accuracy.",
      "status": "Pending"
    }
  ];

  // Mock data for match history
  final List<Map<String, dynamic>> _matchHistory = [
    {
      "id": 1,
      "opponent": "Mumbai Warriors",
      "date": "2024-01-15",
      "result": "Won",
      "score": "185/6 vs 182/8",
      "venue": "Wankhede Stadium",
      "motm": "Rohit Sharma",
      "highlights": "Excellent batting performance"
    },
    {
      "id": 2,
      "opponent": "Delhi Capitals",
      "date": "2024-01-12",
      "result": "Lost",
      "score": "165/9 vs 168/4",
      "venue": "Feroz Shah Kotla",
      "motm": "Virat Kohli",
      "highlights": "Close match, good bowling effort"
    },
    {
      "id": 3,
      "opponent": "Chennai Super Kings",
      "date": "2024-01-08",
      "result": "Won",
      "score": "195/4 vs 190/7",
      "venue": "M.A. Chidambaram Stadium",
      "motm": "Hardik Pandya",
      "highlights": "All-round performance by Hardik"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _getFilteredPlayers() {
    if (_searchQuery.isEmpty) {
      return _teamPlayers;
    }
    return _teamPlayers.where((player) {
      final name = (player['name'] as String).toLowerCase();
      final role = (player['role'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || role.contains(query);
    }).toList();
  }

  void _showPlayerActions(Map<String, dynamic> player) {
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
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              player['name'],
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              icon: 'star',
              title: 'Set as Captain',
              onTap: () {
                Navigator.pop(context);
                _setCaptain(player);
              },
            ),
            _buildActionTile(
              icon: 'edit',
              title: 'Change Role',
              onTap: () {
                Navigator.pop(context);
                _changeRole(player);
              },
            ),
            _buildActionTile(
              icon: 'send',
              title: 'Send Match Invitation',
              onTap: () {
                Navigator.pop(context);
                _sendMatchInvitation(player);
              },
            ),
            _buildActionTile(
              icon: 'message',
              title: 'Message Player',
              onTap: () {
                Navigator.pop(context);
                _messagePlayer(player);
              },
            ),
            _buildActionTile(
              icon: 'person',
              title: 'View Profile',
              onTap: () {
                Navigator.pop(context);
                _viewProfile(player);
              },
            ),
            _buildActionTile(
              icon: 'delete',
              title: 'Remove from Team',
              onTap: () {
                Navigator.pop(context);
                _removePlayer(player);
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  void _setCaptain(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player['name']} set as captain'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _changeRole(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Role change option for ${player['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _sendMatchInvitation(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Match invitation sent to ${player['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _messagePlayer(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${player['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _viewProfile(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${player['name']} profile'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _removePlayer(Map<String, dynamic> player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Player'),
        content: Text(
            'Are you sure you want to remove ${player['name']} from the team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _teamPlayers.removeWhere((p) => p['id'] == player['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${player['name']} removed from team'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showRecruitmentOptions() {
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
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Player Recruitment',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              icon: 'person_add',
              title: 'Invite Player',
              onTap: () {
                Navigator.pop(context);
                _invitePlayer();
              },
            ),
            _buildActionTile(
              icon: 'post_add',
              title: 'Post Open Position',
              onTap: () {
                Navigator.pop(context);
                _postOpenPosition();
              },
            ),
            _buildActionTile(
              icon: 'search',
              title: 'Browse Available Players',
              onTap: () {
                Navigator.pop(context);
                _browseAvailablePlayers();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _invitePlayer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening player invitation'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _postOpenPosition() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Posting open position'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _browseAvailablePlayers() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Browsing available players'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        title: Text(
          'Team Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to notifications
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search players by name or role...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                unselectedLabelColor: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.7),
                indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
                tabs: [
                  Tab(text: 'Active Players'),
                  Tab(text: 'Applications'),
                  Tab(text: 'Match History'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivePlayersTab(),
          _buildApplicationsTab(),
          _buildMatchHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRecruitmentOptions,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
    );
  }

  Widget _buildActivePlayersTab() {
    final filteredPlayers = _getFilteredPlayers();

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: filteredPlayers.isEmpty
          ? _buildEmptyState(
              icon: 'group',
              title: 'No Players Found',
              subtitle: _searchQuery.isNotEmpty
                  ? 'Try adjusting your search criteria'
                  : 'Start building your team by adding players',
            )
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = filteredPlayers[index];
                return TeamPlayerCardWidget(
                  player: player,
                  onTap: () => _showPlayerActions(player),
                  onLongPress: () => _showPlayerActions(player),
                );
              },
            ),
    );
  }

  Widget _buildApplicationsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: _teamApplications.isEmpty
          ? _buildEmptyState(
              icon: 'inbox',
              title: 'No Applications',
              subtitle: 'New player applications will appear here',
            )
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _teamApplications.length,
              itemBuilder: (context, index) {
                final application = _teamApplications[index];
                return TeamApplicationCardWidget(
                  application: application,
                  onAccept: () => _acceptApplication(application),
                  onDecline: () => _declineApplication(application),
                  onTap: () => _viewApplicationDetails(application),
                );
              },
            ),
    );
  }

  Widget _buildMatchHistoryTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: _matchHistory.isEmpty
          ? _buildEmptyState(
              icon: 'history',
              title: 'No Match History',
              subtitle: 'Team match history will appear here',
            )
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _matchHistory.length,
              itemBuilder: (context, index) {
                final match = _matchHistory[index];
                return MatchHistoryCardWidget(
                  match: match,
                  onTap: () => _viewMatchDetails(match),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _acceptApplication(Map<String, dynamic> application) {
    setState(() {
      _teamApplications.removeWhere((app) => app['id'] == application['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${application['playerName']} accepted to team'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _declineApplication(Map<String, dynamic> application) {
    setState(() {
      _teamApplications.removeWhere((app) => app['id'] == application['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${application['playerName']} application declined'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _viewApplicationDetails(Map<String, dynamic> application) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Viewing ${application['playerName']} application details'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _viewMatchDetails(Map<String, dynamic> match) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing match details vs ${match['opponent']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
