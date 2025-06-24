import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BallInputModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onBallSubmitted;

  const BallInputModal({
    super.key,
    required this.onBallSubmitted,
  });

  @override
  State<BallInputModal> createState() => _BallInputModalState();
}

class _BallInputModalState extends State<BallInputModal> {
  int _runs = 0;
  bool _isWicket = false;
  bool _isWide = false;
  bool _isNoBall = false;
  bool _isBye = false;
  bool _isLegBye = false;
  String _wicketType = 'Bowled';
  String _commentary = '';

  final List<String> _wicketTypes = [
    'Bowled',
    'Caught',
    'LBW',
    'Run Out',
    'Stumped',
    'Hit Wicket',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Ball Input',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Runs Selection
                  _buildSectionHeader('Runs Scored'),
                  SizedBox(height: 1.h),
                  _buildRunsSelector(),

                  SizedBox(height: 3.h),

                  // Extras Section
                  _buildSectionHeader('Extras'),
                  SizedBox(height: 1.h),
                  _buildExtrasSection(),

                  SizedBox(height: 3.h),

                  // Wicket Section
                  _buildSectionHeader('Wicket'),
                  SizedBox(height: 1.h),
                  _buildWicketSection(),

                  SizedBox(height: 3.h),

                  // Commentary
                  _buildSectionHeader('Commentary (Optional)'),
                  SizedBox(height: 1.h),
                  _buildCommentaryInput(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Submit Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitBall,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Submit Ball',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
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

  Widget _buildRunsSelector() {
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
            children:
                [0, 1, 2, 3].map((runs) => _buildRunButton(runs)).toList(),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 5, 6].map((runs) => _buildRunButton(runs)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton(int runs) {
    final isSelected = _runs == runs;
    Color buttonColor = AppTheme.lightTheme.colorScheme.surface;
    Color textColor = AppTheme.textHighEmphasisLight;

    if (runs == 4) {
      buttonColor = isSelected ? Colors.green : Colors.green.shade100;
      textColor = isSelected ? Colors.white : Colors.green.shade800;
    } else if (runs == 6) {
      buttonColor = isSelected ? Colors.blue : Colors.blue.shade100;
      textColor = isSelected ? Colors.white : Colors.blue.shade800;
    } else if (isSelected) {
      buttonColor = AppTheme.lightTheme.primaryColor;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _runs = runs;
        });
        HapticFeedback.selectionClick();
      },
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            runs == 0 ? '•' : '$runs',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtrasSection() {
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
            children: [
              Expanded(
                child: _buildCheckboxTile('Wide', _isWide, (value) {
                  setState(() {
                    _isWide = value ?? false;
                  });
                }),
              ),
              Expanded(
                child: _buildCheckboxTile('No Ball', _isNoBall, (value) {
                  setState(() {
                    _isNoBall = value ?? false;
                  });
                }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildCheckboxTile('Bye', _isBye, (value) {
                  setState(() {
                    _isBye = value ?? false;
                    if (_isBye) _isLegBye = false;
                  });
                }),
              ),
              Expanded(
                child: _buildCheckboxTile('Leg Bye', _isLegBye, (value) {
                  setState(() {
                    _isLegBye = value ?? false;
                    if (_isLegBye) _isBye = false;
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildWicketSection() {
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
          CheckboxListTile(
            title: Text(
              'Wicket Taken',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            value: _isWicket,
            onChanged: (value) {
              setState(() {
                _isWicket = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (_isWicket) ...[
            SizedBox(height: 1.h),
            DropdownButtonFormField<String>(
              value: _wicketType,
              decoration: InputDecoration(
                labelText: 'Wicket Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _wicketTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _wicketType = value ?? 'Bowled';
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentaryInput() {
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
      child: TextField(
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Add commentary for this ball...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          _commentary = value;
        },
      ),
    );
  }

  void _submitBall() {
    final ballData = {
      'runs': _runs,
      'isWicket': _isWicket,
      'wicketType': _isWicket ? _wicketType : null,
      'isWide': _isWide,
      'isNoBall': _isNoBall,
      'isBye': _isBye,
      'isLegBye': _isLegBye,
      'commentary': _commentary.isNotEmpty ? _commentary : null,
      'timestamp': DateTime.now(),
    };

    widget.onBallSubmitted(ballData);
    Navigator.pop(context);

    // Haptic feedback based on ball type
    if (_isWicket) {
      HapticFeedback.heavyImpact();
    } else if (_runs == 4 || _runs == 6) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }
}
