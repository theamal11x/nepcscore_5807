import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isNepali;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onPasswordToggle;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.isNepali,
    this.emailError,
    this.passwordError,
    required this.onPasswordToggle,
    required this.onLogin,
    required this.onForgotPassword,
  });

  String _getLocalizedText(String english, String nepali) {
    return isNepali ? nepali : english;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome text
          Text(
            _getLocalizedText('Welcome Back!', 'फिर्ता स्वागत छ!'),
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          Text(
            _getLocalizedText('Sign in to continue your cricket journey',
                'आफ्नो क्रिकेट यात्रा जारी राख्न साइन इन गर्नुहोस्'),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Email/Phone field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getLocalizedText('Email', 'इमेल'),
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: _getLocalizedText(
                      'Enter your email', 'आफ्नो इमेल प्रविष्ट गर्नुहोस्'),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  errorText: emailError,
                  errorMaxLines: 2,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Password field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getLocalizedText('Password', 'पासवर्ड'),
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: _getLocalizedText('Enter your password',
                      'आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्'),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: isLoading ? null : onPasswordToggle,
                    icon: CustomIconWidget(
                      iconName:
                          isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  errorText: passwordError,
                  errorMaxLines: 2,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading ? null : onForgotPassword,
              child: Text(
                _getLocalizedText('Forgot Password?', 'पासवर्ड बिर्सनुभयो?'),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                elevation: 2,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      _getLocalizedText('Login', 'लगइन'),
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 3.h),

          // Mock credentials info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedText('Demo Credentials:', 'डेमो प्रमाणहरू:'),
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildCredentialRow(
                    'Player', 'player@cricket.com', 'player123'),
                _buildCredentialRow('Fan', 'fan@cricket.com', 'fan123'),
                _buildCredentialRow(
                    'Organizer', 'organizer@cricket.com', 'organizer123'),
                _buildCredentialRow('Admin', 'admin@cricket.com', 'admin123'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String role, String email, String password) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Text(
        '$role: $email / $password',
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
