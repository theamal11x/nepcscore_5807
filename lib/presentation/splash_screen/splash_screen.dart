import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cricket_logo_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _fadeAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryLight,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    final List<Future<void>> tasks = [
      _checkAuthenticationStatus(),
      _loadUserPreferences(),
      _fetchEssentialData(),
      _prepareCachedStatistics(),
    ];

    for (int i = 0; i < tasks.length; i++) {
      await tasks[i];
      if (mounted) {
        setState(() {
          _loadingText = _getLoadingText(i + 1);
        });
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  String _getLoadingText(int step) {
    switch (step) {
      case 1:
        return 'Checking authentication...';
      case 2:
        return 'Loading preferences...';
      case 3:
        return 'Fetching match data...';
      case 4:
        return 'Preparing statistics...';
      default:
        return 'Almost ready...';
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock authentication check
  }

  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock language preferences loading
  }

  Future<void> _fetchEssentialData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Mock essential match data fetching
  }

  Future<void> _prepareCachedStatistics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock statistics preparation
  }

  void _navigateToNextScreen() {
    // Mock navigation logic based on user status
    final bool isAuthenticated = false; // Mock authentication status
    final bool isNewUser = true; // Mock new user status

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/player-dashboard');
      } else if (isNewUser) {
        Navigator.pushReplacementNamed(context, '/login-screen');
      } else {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _loadingText = 'Retrying...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryVariantLight,
              AppTheme.secondaryLight,
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: _hasError ? _buildErrorView() : _buildSplashContent(),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Cricket Logo with Animation
        AnimatedBuilder(
          animation: _logoScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _logoScaleAnimation.value,
              child: CricketLogoWidget(
                size: 25.w,
                color: AppTheme.onPrimaryLight,
              ),
            );
          },
        ),

        SizedBox(height: 4.h),

        // App Name
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'nepCscore',
            style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
              color: AppTheme.onPrimaryLight,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Cricket Community Management',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
        ),

        const Spacer(flex: 2),

        // Loading Section
        if (_isLoading) ...[
          LoadingIndicatorWidget(
            color: AppTheme.onPrimaryLight,
            size: 6.w,
          ),
          SizedBox(height: 2.h),
          Text(
            _loadingText,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],

        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.onPrimaryLight,
          size: 15.w,
        ),
        SizedBox(height: 3.h),
        Text(
          'Oops! Something went wrong',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.onPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Please check your internet connection\nand try again',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onPrimaryLight.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.onPrimaryLight,
            foregroundColor: AppTheme.primaryLight,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
