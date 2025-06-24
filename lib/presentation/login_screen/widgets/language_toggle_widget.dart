import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageToggleWidget extends StatelessWidget {
  final bool isNepali;
  final VoidCallback onToggle;

  const LanguageToggleWidget({
    super.key,
    required this.isNepali,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flag icon
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNepali
                    ? const Color(0xFFDC143C) // Nepal flag red
                    : const Color(0xFF012169), // UK flag blue
              ),
              child: Center(
                child: Text(
                  isNepali ? '🇳🇵' : '🇬🇧',
                  style: TextStyle(fontSize: 3.w),
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Language text
            Text(
              isNepali ? 'नेपाली' : 'English',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(width: 1.w),

            // Toggle icon
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
