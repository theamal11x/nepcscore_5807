import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> commentary;
  final bool isRefreshing;

  const CommentaryWidget({
    super.key,
    required this.commentary,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      itemCount: commentary.length,
      itemBuilder: (context, index) {
        final comment = commentary[index];
        return _buildCommentaryItem(context, comment);
      },
    );
  }

  Widget _buildCommentaryItem(
      BuildContext context, Map<String, dynamic> comment) {
    return GestureDetector(
      onLongPress: () => _showShareDialog(context, comment),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getCommentaryBorderColor(comment["type"]),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getCommentaryColor(comment["type"]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    comment["over"],
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: _getCommentaryIcon(comment["type"]),
                  color: _getCommentaryColor(comment["type"]),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  comment["timestamp"],
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              comment["text"],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                _buildActionButton(
                  icon: 'thumb_up',
                  label: 'Like',
                  onTap: () => _handleLike(comment["id"]),
                ),
                SizedBox(width: 4.w),
                _buildActionButton(
                  icon: 'share',
                  label: 'Share',
                  onTap: () => _shareCommentary(comment),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.textMediumEmphasisLight,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCommentaryColor(String type) {
    switch (type) {
      case 'boundary':
        return Colors.green;
      case 'wicket':
        return Colors.red;
      case 'six':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  Color _getCommentaryBorderColor(String type) {
    switch (type) {
      case 'boundary':
        return Colors.green.withValues(alpha: 0.3);
      case 'wicket':
        return Colors.red.withValues(alpha: 0.3);
      case 'six':
        return Colors.blue.withValues(alpha: 0.3);
      default:
        return AppTheme.dividerLight;
    }
  }

  String _getCommentaryIcon(String type) {
    switch (type) {
      case 'boundary':
        return 'sports_cricket';
      case 'wicket':
        return 'close';
      case 'six':
        return 'sports_baseball';
      default:
        return 'play_arrow';
    }
  }

  void _handleLike(int commentId) {
    HapticFeedback.selectionClick();
    // Handle like functionality
  }

  void _shareCommentary(Map<String, dynamic> comment) {
    HapticFeedback.lightImpact();
    // Handle share functionality
  }

  void _showShareDialog(BuildContext context, Map<String, dynamic> comment) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Commentary',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Share this moment: "${comment["text"]}"',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textMediumEmphasisLight),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _shareCommentary(comment);
            },
            child: Text(
              'Share',
              style: TextStyle(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
