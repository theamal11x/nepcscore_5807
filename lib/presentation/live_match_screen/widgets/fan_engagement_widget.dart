import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FanEngagementWidget extends StatefulWidget {
  final List<Map<String, dynamic>> polls;
  final Function(int, int) onVote;

  const FanEngagementWidget({
    super.key,
    required this.polls,
    required this.onVote,
  });

  @override
  State<FanEngagementWidget> createState() => _FanEngagementWidgetState();
}

class _FanEngagementWidgetState extends State<FanEngagementWidget> {
  bool _isExpanded = false;
  int _selectedReaction = -1;

  final List<Map<String, dynamic>> _reactions = [
    {"emoji": "🔥", "label": "Fire", "count": 45},
    {"emoji": "👏", "label": "Clap", "count": 32},
    {"emoji": "😍", "label": "Love", "count": 28},
    {"emoji": "💪", "label": "Strong", "count": 19},
    {"emoji": "🎯", "label": "Target", "count": 15},
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? 35.h : 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle and Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              HapticFeedback.selectionClick();
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'poll',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Fan Engagement',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: _isExpanded
                            ? 'keyboard_arrow_down'
                            : 'keyboard_arrow_up',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Quick Reactions (Always Visible)
          if (!_isExpanded) _buildQuickReactions(),

          // Expanded Content
          if (_isExpanded) ...[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reactions Section
                    _buildReactionsSection(),

                    SizedBox(height: 3.h),

                    // Polls Section
                    if (widget.polls.isNotEmpty) ...[
                      _buildPollsSection(),
                      SizedBox(height: 2.h),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickReactions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _reactions
            .take(5)
            .map((reaction) => _buildQuickReactionButton(reaction))
            .toList(),
      ),
    );
  }

  Widget _buildQuickReactionButton(Map<String, dynamic> reaction) {
    final isSelected = _selectedReaction == _reactions.indexOf(reaction);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReaction = _reactions.indexOf(reaction);
          reaction["count"]++;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reaction["emoji"],
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(width: 1.w),
            Text(
              "${reaction["count"]}",
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.textMediumEmphasisLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Reactions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
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
                children: _reactions
                    .map((reaction) => _buildReactionButton(reaction))
                    .toList(),
              ),
              SizedBox(height: 2.h),
              Text(
                'React to the live action!',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReactionButton(Map<String, dynamic> reaction) {
    final isSelected = _selectedReaction == _reactions.indexOf(reaction);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReaction = _reactions.indexOf(reaction);
          reaction["count"]++;
        });
        HapticFeedback.mediumImpact();
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              reaction["emoji"],
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(height: 0.5.h),
            Text(
              reaction["label"],
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.textMediumEmphasisLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${reaction["count"]}",
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.textMediumEmphasisLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Polls',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...widget.polls.map((poll) => _buildPollCard(poll)),
      ],
    );
  }

  Widget _buildPollCard(Map<String, dynamic> poll) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
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
            poll["question"],
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          ...(poll["options"] as List).asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return _buildPollOption(
                poll["id"], index, option, poll["userVoted"]);
          }),
          SizedBox(height: 1.h),
          Text(
            "${poll["totalVotes"]} votes",
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollOption(int pollId, int optionIndex,
      Map<String, dynamic> option, bool userVoted) {
    return GestureDetector(
      onTap: userVoted ? null : () => widget.onVote(pollId, optionIndex),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: userVoted
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: userVoted
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option["text"],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: userVoted ? AppTheme.lightTheme.primaryColor : null,
                ),
              ),
            ),
            if (userVoted) ...[
              Text(
                "${option["percentage"]}%",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(width: 2.w),
              SizedBox(
                width: 20.w,
                child: LinearProgressIndicator(
                  value: option["percentage"] / 100,
                  backgroundColor: AppTheme.dividerLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
