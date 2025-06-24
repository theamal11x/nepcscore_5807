import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleSelectionWidget extends StatelessWidget {
  final bool isNepali;
  final String? selectedRole;
  final Function(String) onRoleSelected;
  final VoidCallback onProceed;

  const RoleSelectionWidget({
    super.key,
    required this.isNepali,
    this.selectedRole,
    required this.onRoleSelected,
    required this.onProceed,
  });

  String _getLocalizedText(String english, String nepali) {
    return isNepali ? nepali : english;
  }

  String _getLocalizedRole(String role) {
    switch (role.toLowerCase()) {
      case 'player':
        return isNepali ? 'खेलाडी' : 'Player';
      case 'fan':
        return isNepali ? 'प्रशंसक' : 'Fan';
      case 'organizer':
        return isNepali ? 'आयोजक' : 'Organizer';
      case 'admin':
        return isNepali ? 'प्रशासक' : 'Admin';
      default:
        return role;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'player':
        return Icons.sports_cricket;
      case 'fan':
        return Icons.favorite;
      case 'organizer':
        return Icons.event;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = ['Player', 'Fan', 'Organizer', 'Admin'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success message
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  _getLocalizedText(
                      'Login successful! Please select your role to continue.',
                      'लगइन सफल! जारी राख्न कृपया आफ्नो भूमिका चयन गर्नुहोस्।'),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Role selection title
        Text(
          _getLocalizedText('Select Your Role', 'आफ्नो भूमिका चयन गर्नुहोस्'),
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 3.h),

        // Role chips
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          alignment: WrapAlignment.center,
          children: roles.map((role) {
            final isSelected = selectedRole == role;
            return GestureDetector(
              onTap: () => onRoleSelected(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getRoleIcon(role).codePoint.toString(),
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _getLocalizedRole(role),
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 6.h),

        // Continue button
        SizedBox(
          height: 6.h,
          child: ElevatedButton(
            onPressed: selectedRole != null ? onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedRole != null
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.outline,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
              elevation: selectedRole != null ? 2 : 0,
            ),
            child: Text(
              _getLocalizedText('Continue', 'जारी राख्नुहोस्'),
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
