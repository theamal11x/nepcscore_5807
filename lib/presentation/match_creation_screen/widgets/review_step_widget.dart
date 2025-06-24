import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewStepWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;
  final List<Map<String, dynamic>> availableTeams;

  const ReviewStepWidget({
    super.key,
    required this.matchData,
    required this.availableTeams,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Create',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Review all match details before creating',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Match Overview Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'sports_cricket',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          matchData['title'] ?? 'Match Title',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Date and Time
                  _buildInfoRow(
                    icon: 'calendar_today',
                    label: 'Date & Time',
                    value: _formatDateTime(),
                  ),
                  SizedBox(height: 1.h),

                  // Venue
                  _buildInfoRow(
                    icon: 'location_on',
                    label: 'Venue',
                    value: matchData['venue'] ?? 'Not specified',
                  ),
                  SizedBox(height: 1.h),

                  // Format
                  _buildInfoRow(
                    icon: 'timer',
                    label: 'Format',
                    value:
                        '${matchData['format']} - ${matchData['overs']} overs',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Teams Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'groups',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Teams',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      // Team 1
                      Expanded(
                        child: matchData['team1'] != null
                            ? _buildTeamCard(matchData['team1'])
                            : _buildEmptyTeamCard('Team 1'),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'VS',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Team 2
                      Expanded(
                        child: matchData['team2'] != null
                            ? _buildTeamCard(matchData['team2'])
                            : _buildEmptyTeamCard('Team 2'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Match Settings
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'settings',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Match Settings',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildSettingRow(
                      'Overs per Innings', '${matchData['overs']}'),
                  if (matchData['format'] != 'Test')
                    _buildSettingRow(
                        'Powerplay Overs', '${matchData['powerplayOvers']}'),
                  _buildSettingRow('DRS Available',
                      matchData['drsAvailable'] ? 'Yes' : 'No'),
                  if (matchData['weather'] != null)
                    _buildSettingRow('Weather', matchData['weather']),
                  if (matchData['pitchType'] != null)
                    _buildSettingRow('Pitch Type', matchData['pitchType']),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Share Options
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Share Match',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Share match details with players and fans',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareViaWhatsApp(context),
                          icon: CustomIconWidget(
                            iconName: 'message',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text('WhatsApp'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareViaSMS(context),
                          icon: CustomIconWidget(
                            iconName: 'sms',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text('SMS'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Important Notes
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Important Notes',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Match code will be generated for easy sharing\n'
                  '• Live scoring will be available once match starts\n'
                  '• Players can be invited after match creation\n'
                  '• Match details can be edited before start time',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          '$label: ',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(Map<String, dynamic> team) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CustomImageWidget(
              imageUrl: team['logo'],
              width: 12.w,
              height: 12.w,
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
            '${team['players']} players',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTeamCard(String teamLabel) {
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
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'No $teamLabel',
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

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime() {
    final date = matchData['date'];
    final time = matchData['time'];

    if (date == null && time == null) {
      return 'Not specified';
    }

    String result = '';
    if (date != null) {
      result += '${date.day}/${date.month}/${date.year}';
    }
    if (time != null) {
      if (result.isNotEmpty) result += ' at ';
      result += time.format(null);
    }

    return result;
  }

  void _shareViaWhatsApp(BuildContext context) {
    final matchTitle = matchData['title'] ?? 'Cricket Match';
    final venue = matchData['venue'] ?? 'TBD';
    final format = matchData['format'] ?? 'T20';

    final message = '''
🏏 Cricket Match Invitation 🏏

Match: $matchTitle
Format: $format
Venue: $venue
Date: ${_formatDateTime()}

Join us for an exciting cricket match! 

#nepCscore #Cricket #Nepal
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp...'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard functionality
          },
        ),
      ),
    );
  }

  void _shareViaSMS(BuildContext context) {
    final matchTitle = matchData['title'] ?? 'Cricket Match';

    final message = '''
Cricket Match: $matchTitle
${_formatDateTime()}
Venue: ${matchData['venue'] ?? 'TBD'}
Format: ${matchData['format']} 

Join us! - nepCscore
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening SMS app...'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard functionality
          },
        ),
      ),
    );
  }
}
