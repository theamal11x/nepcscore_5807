import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CricketLogoWidget extends StatelessWidget {
  final bool isNepali;

  const CricketLogoWidget({
    super.key,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cricket logo container
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'sports_cricket',
              color: Colors.white,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App title
        Text(
          isNepali ? 'नेपाल क्रिकेट स्कोर' : 'nepCscore',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // Subtitle
        Text(
          isNepali ? 'घरेलु क्रिकेट समुदाय' : 'Grassroots Cricket Community',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
