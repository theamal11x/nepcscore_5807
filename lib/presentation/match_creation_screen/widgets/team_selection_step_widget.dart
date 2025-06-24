import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TeamSelectionStepWidget extends StatefulWidget {
  final Map<String, dynamic> matchData;
  final List<Map<String, dynamic>> availableTeams;
  final Function(String, dynamic) onDataChanged;

  const TeamSelectionStepWidget({
    super.key,
    required this.matchData,
    required this.availableTeams,
    required this.onDataChanged,
  });

  @override
  State<TeamSelectionStepWidget> createState() =>
      _TeamSelectionStepWidgetState();
}

class _TeamSelectionStepWidgetState extends State<TeamSelectionStepWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTeams = [];

  @override
  void initState() {
    super.initState();
    _filteredTeams = widget.availableTeams;
  }

  void _filterTeams(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTeams = widget.availableTeams;
      } else {
        _filteredTeams = widget.availableTeams
            .where((team) => (team['name'] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectTeam(Map<String, dynamic> team, String teamKey) {
    widget.onDataChanged(teamKey, team);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${team['name']} selected as ${teamKey == 'team1' ? 'Team 1' : 'Team 2'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _createNewTeam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController teamNameController =
            TextEditingController();
        return AlertDialog(
          title: Text('Create New Team'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: teamNameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  hintText: 'Enter team name',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'You can add players after creating the team',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (teamNameController.text.isNotEmpty) {
                  final newTeam = {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'name': teamNameController.text,
                    'logo':
                        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=100&h=100&fit=crop',
                    'players': 0,
                    'captain': 'TBD',
                    'isNew': true,
                  };
                  setState(() {
                    widget.availableTeams.add(newTeam);
                    _filteredTeams = widget.availableTeams;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Team "${teamNameController.text}" created successfully')),
                  );
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Selection',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Select two teams for the match',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Search Bar
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search teams...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: _createNewTeam,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            onChanged: _filterTeams,
          ),
          SizedBox(height: 3.h),

          // Selected Teams Display
          if (widget.matchData['team1'] != null ||
              widget.matchData['team2'] != null)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Teams',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      // Team 1
                      Expanded(
                        child: widget.matchData['team1'] != null
                            ? _buildSelectedTeamCard(
                                widget.matchData['team1'], 'Team 1')
                            : _buildEmptyTeamSlot('Team 1'),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'VS',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Team 2
                      Expanded(
                        child: widget.matchData['team2'] != null
                            ? _buildSelectedTeamCard(
                                widget.matchData['team2'], 'Team 2')
                            : _buildEmptyTeamSlot('Team 2'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          if (widget.matchData['team1'] != null ||
              widget.matchData['team2'] != null)
            SizedBox(height: 3.h),

          // Available Teams List
          Text(
            'Available Teams',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredTeams.length,
            itemBuilder: (context, index) {
              final team = _filteredTeams[index];
              final isTeam1Selected =
                  widget.matchData['team1']?['id'] == team['id'];
              final isTeam2Selected =
                  widget.matchData['team2']?['id'] == team['id'];
              final isSelected = isTeam1Selected || isTeam2Selected;

              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  contentPadding: EdgeInsets.all(3.w),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: team['logo'],
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    team['name'],
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'people',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${team['players']} players',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Captain: ${team['captain']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: isSelected
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isTeam1Selected ? 'Team 1' : 'Team 2',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.matchData['team1'] == null)
                              ElevatedButton(
                                onPressed: () => _selectTeam(team, 'team1'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(15.w, 5.h),
                                ),
                                child: Text('Team 1'),
                              ),
                            if (widget.matchData['team1'] == null &&
                                widget.matchData['team2'] == null)
                              SizedBox(width: 2.w),
                            if (widget.matchData['team2'] == null)
                              ElevatedButton(
                                onPressed: () => _selectTeam(team, 'team2'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(15.w, 5.h),
                                ),
                                child: Text('Team 2'),
                              ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTeamCard(Map<String, dynamic> team, String teamLabel) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CustomImageWidget(
              imageUrl: team['logo'],
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            team['name'],
            style: AppTheme.lightTheme.textTheme.titleSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            teamLabel,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTeamSlot(String teamLabel) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select $teamLabel',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
