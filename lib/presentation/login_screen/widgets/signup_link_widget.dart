import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignupLinkWidget extends StatelessWidget {
  final bool isNepali;
  final VoidCallback onSignUp;

  const SignupLinkWidget({
    super.key,
    required this.isNepali,
    required this.onSignUp,
  });

  String _getLocalizedText(String english, String nepali) {
    return isNepali ? nepali : english;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getLocalizedText('New to Cricket Community? ',
                'क्रिकेट समुदायमा नयाँ हुनुहुन्छ? '),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          GestureDetector(
            onTap: onSignUp,
            child: Text(
              _getLocalizedText('Sign Up', 'साइन अप'),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
