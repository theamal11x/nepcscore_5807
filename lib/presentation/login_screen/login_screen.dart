import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/cricket_logo_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_selection_widget.dart';
import './widgets/signup_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showRoleSelection = false;
  bool _isNepali = false;
  String? _selectedRole;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'player@cricket.com': {
      'password': 'player123',
      'role': 'Player',
      'name': 'Rohit Sharma'
    },
    'fan@cricket.com': {
      'password': 'fan123',
      'role': 'Fan',
      'name': 'Cricket Fan'
    },
    'organizer@cricket.com': {
      'password': 'organizer123',
      'role': 'Organizer',
      'name': 'Match Organizer'
    },
    'admin@cricket.com': {
      'password': 'admin123',
      'role': 'Admin',
      'name': 'System Admin'
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isNepali = !_isNepali;
    });
  }

  String _getLocalizedText(String english, String nepali) {
    return _isNepali ? nepali : english;
  }

  void _validateInputs() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = _getLocalizedText('Email is required', 'इमेल आवश्यक छ');
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailError = _getLocalizedText('Please enter a valid email',
            'कृपया मान्य इमेल प्रविष्ट गर्नुहोस्');
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError =
            _getLocalizedText('Password is required', 'पासवर्ड आवश्यक छ');
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _passwordError = _getLocalizedText(
            'Password must be at least 6 characters',
            'पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ');
      });
      return;
    }

    _performLogin();
  }

  void _performLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email]!['password'] == password) {
      // Successful authentication - show role selection
      setState(() {
        _isLoading = false;
        _showRoleSelection = true;
        _selectedRole = _mockCredentials[email]!['role'];
      });

      // Haptic feedback for success
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        _isLoading = false;
        _passwordError = _getLocalizedText(
            'Invalid email or password. Please try again.',
            'गलत इमेल वा पासवर्ड। कृपया फेरि प्रयास गर्नुहोस्।');
      });

      // Haptic feedback for error
      HapticFeedback.heavyImpact();
    }
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _proceedToDashboard() {
    if (_selectedRole != null) {
      // Navigate to appropriate dashboard based on role
      switch (_selectedRole!.toLowerCase()) {
        case 'player':
          Navigator.pushReplacementNamed(context, '/player-dashboard');
          break;
        case 'fan':
          Navigator.pushReplacementNamed(context, '/player-dashboard');
          break;
        case 'organizer':
          Navigator.pushReplacementNamed(context, '/team-management-screen');
          break;
        case 'admin':
          Navigator.pushReplacementNamed(context, '/match-creation-screen');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/player-dashboard');
      }
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _getLocalizedText('Forgot Password', 'पासवर्ड बिर्सनुभयो'),
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          _getLocalizedText('Please contact support for password recovery.',
              'पासवर्ड रिकभरीको लागि सपोर्टलाई सम्पर्क गर्नुहोस्।'),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _getLocalizedText('OK', 'ठिक छ'),
              style: TextStyle(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    // For now, show a dialog since signup screen is not implemented
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _getLocalizedText('Sign Up', 'साइन अप'),
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          _getLocalizedText('Sign up feature will be available soon.',
              'साइन अप सुविधा चाँडै उपलब्ध हुनेछ।'),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _getLocalizedText('OK', 'ठिक छ'),
              style: TextStyle(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Language toggle
                      Align(
                        alignment: Alignment.topRight,
                        child: LanguageToggleWidget(
                          isNepali: _isNepali,
                          onToggle: _toggleLanguage,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Cricket logo
                      CricketLogoWidget(isNepali: _isNepali),

                      SizedBox(height: 6.h),

                      // Login form or role selection
                      _showRoleSelection
                          ? RoleSelectionWidget(
                              isNepali: _isNepali,
                              selectedRole: _selectedRole,
                              onRoleSelected: _selectRole,
                              onProceed: _proceedToDashboard,
                            )
                          : LoginFormWidget(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isPasswordVisible: _isPasswordVisible,
                              isLoading: _isLoading,
                              isNepali: _isNepali,
                              emailError: _emailError,
                              passwordError: _passwordError,
                              onPasswordToggle: _togglePasswordVisibility,
                              onLogin: _validateInputs,
                              onForgotPassword: _forgotPassword,
                            ),

                      const Spacer(),

                      // Sign up link (only show if not in role selection)
                      if (!_showRoleSelection) ...[
                        SizedBox(height: 4.h),
                        SignupLinkWidget(
                          isNepali: _isNepali,
                          onSignUp: _navigateToSignUp,
                        ),
                      ],

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
