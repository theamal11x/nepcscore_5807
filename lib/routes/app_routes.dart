import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/team_management_screen/team_management_screen.dart';
import '../presentation/player_dashboard/player_dashboard.dart';
import '../presentation/match_creation_screen/match_creation_screen.dart';
import '../presentation/live_match_screen/live_match_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String playerDashboard = '/player-dashboard';
  static const String liveMatchScreen = '/live-match-screen';
  static const String teamManagementScreen = '/team-management-screen';
  static const String matchCreationScreen = '/match-creation-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    playerDashboard: (context) => const PlayerDashboard(),
    liveMatchScreen: (context) => const LiveMatchScreen(),
    teamManagementScreen: (context) => const TeamManagementScreen(),
    matchCreationScreen: (context) => const MatchCreationScreen(),
  };
}
