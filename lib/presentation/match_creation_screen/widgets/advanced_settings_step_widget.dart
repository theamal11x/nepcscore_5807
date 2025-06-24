import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsStepWidget extends StatefulWidget {
  final Map<String, dynamic> matchData;
  final Function(String, dynamic) onDataChanged;

  const AdvancedSettingsStepWidget({
    super.key,
    required this.matchData,
    required this.onDataChanged,
  });

  @override
  State<AdvancedSettingsStepWidget> createState() =>
      _AdvancedSettingsStepWidgetState();
}

class _AdvancedSettingsStepWidgetState
    extends State<AdvancedSettingsStepWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String format = widget.matchData['format'] ?? 'T20';
    final int maxOvers = format == 'T20'
        ? 20
        : format == 'ODI'
            ? 50
            : 90;
    final int currentOvers = widget.matchData['overs'] ??
        (format == 'T20'
            ? 20
            : format == 'ODI'
                ? 50
                : 90);
    final int powerplayOvers =
        widget.matchData['powerplayOvers'] ?? (format == 'T20' ? 6 : 10);
    final bool drsAvailable = widget.matchData['drsAvailable'] ?? false;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure match rules and additional settings',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Match Format Summary
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Match Format: $format',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getFormatDescription(format),
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Overs Limit
          Text(
            'Overs per Innings',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overs: $currentOvers',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    Text(
                      'Max: $maxOvers',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Slider(
                  value: currentOvers.toDouble(),
                  min: format == 'Test' ? 20.0 : 5.0,
                  max: maxOvers.toDouble(),
                  divisions: format == 'Test'
                      ? 14
                      : (maxOvers - (format == 'T20' ? 5 : 10)),
                  onChanged: (value) {
                    widget.onDataChanged('overs', value.round());
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Powerplay Settings
          if (format != 'Test') ...[
            Text(
              'Powerplay Overs',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Powerplay: $powerplayOvers overs',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      Text(
                        'Max: ${(currentOvers * 0.3).round()}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Slider(
                    value: powerplayOvers.toDouble(),
                    min: 4.0,
                    max: (currentOvers * 0.3).roundToDouble(),
                    divisions: ((currentOvers * 0.3).round() - 4),
                    onChanged: (value) {
                      widget.onDataChanged('powerplayOvers', value.round());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // DRS Setting
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Decision Review System (DRS)',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Allow teams to review umpire decisions',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: drsAvailable,
                  onChanged: (value) {
                    widget.onDataChanged('drsAvailable', value);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Expandable Advanced Options
          Card(
            child: ExpansionTile(
              title: Text(
                'Additional Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              subtitle: Text(
                'Weather conditions, pitch type, and more',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    children: [
                      // Weather Conditions
                      _buildSettingTile(
                        title: 'Weather Conditions',
                        subtitle: 'Clear, Cloudy, Overcast',
                        icon: 'wb_sunny',
                        onTap: () => _showWeatherDialog(),
                      ),
                      SizedBox(height: 2.h),

                      // Pitch Type
                      _buildSettingTile(
                        title: 'Pitch Type',
                        subtitle: 'Batting, Bowling, Balanced',
                        icon: 'grass',
                        onTap: () => _showPitchDialog(),
                      ),
                      SizedBox(height: 2.h),

                      // Toss Winner
                      _buildSettingTile(
                        title: 'Toss Winner',
                        subtitle: 'To be decided before match',
                        icon: 'casino',
                        onTap: () => _showTossDialog(),
                      ),
                      SizedBox(height: 2.h),

                      // Match Officials
                      _buildSettingTile(
                        title: 'Match Officials',
                        subtitle: 'Umpires and scorers',
                        icon: 'person',
                        onTap: () => _showOfficialsDialog(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Player Invitation Section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
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
                      iconName: 'group_add',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Player Invitations',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Invite players to join teams after match creation',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Player invitation system will be available after match creation')),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  label: Text('Setup Invitations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormatDescription(String format) {
    switch (format) {
      case 'T20':
        return 'Fast-paced 20 overs per side format';
      case 'ODI':
        return 'One Day International - 50 overs per side';
      case 'Test':
        return 'Traditional long format cricket';
      default:
        return 'Cricket match format';
    }
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showWeatherDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Weather Conditions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              ['Clear', 'Cloudy', 'Overcast', 'Light Rain'].map((weather) {
            return ListTile(
              title: Text(weather),
              onTap: () {
                widget.onDataChanged('weather', weather);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPitchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pitch Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              ['Batting Friendly', 'Bowling Friendly', 'Balanced'].map((pitch) {
            return ListTile(
              title: Text(pitch),
              onTap: () {
                widget.onDataChanged('pitchType', pitch);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTossDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Toss Settings'),
        content: Text('Toss will be conducted before the match starts'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showOfficialsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Match Officials'),
        content: Text('Assign umpires and scorers for the match'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Setup Later'),
          ),
        ],
      ),
    );
  }
}
