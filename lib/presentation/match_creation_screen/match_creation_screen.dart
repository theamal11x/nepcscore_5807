import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_settings_step_widget.dart';
import './widgets/match_details_step_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/review_step_widget.dart';
import './widgets/team_selection_step_widget.dart';

class MatchCreationScreen extends StatefulWidget {
  const MatchCreationScreen({super.key});

  @override
  State<MatchCreationScreen> createState() => _MatchCreationScreenState();
}

class _MatchCreationScreenState extends State<MatchCreationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Mock data for match creation
  final Map<String, dynamic> _matchData = {
    'title': '',
    'date': null,
    'time': null,
    'venue': '',
    'format': 'T20',
    'team1': null,
    'team2': null,
    'overs': 20,
    'powerplayOvers': 6,
    'drsAvailable': false,
    'players': [],
    'isDraft': false,
  };

  final List<Map<String, dynamic>> _availableTeams = [
    {
      'id': 1,
      'name': 'Kathmandu Kings',
      'logo':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=100&h=100&fit=crop',
      'players': 15,
      'captain': 'Rohit Paudel'
    },
    {
      'id': 2,
      'name': 'Pokhara Warriors',
      'logo':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop',
      'players': 12,
      'captain': 'Sandeep Lamichhane'
    },
    {
      'id': 3,
      'name': 'Chitwan Tigers',
      'logo':
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=100&h=100&fit=crop',
      'players': 18,
      'captain': 'Paras Khadka'
    },
    {
      'id': 4,
      'name': 'Lalitpur Legends',
      'logo':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=100&h=100&fit=crop',
      'players': 14,
      'captain': 'Gyanendra Malla'
    },
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveDraft() {
    setState(() {
      _matchData['isDraft'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Match saved as draft'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _createMatch() {
    // Validate all required fields
    if (_validateMatchData()) {
      // Show success dialog
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  bool _validateMatchData() {
    return _matchData['title'].isNotEmpty &&
        _matchData['date'] != null &&
        _matchData['time'] != null &&
        _matchData['venue'].isNotEmpty &&
        _matchData['team1'] != null &&
        _matchData['team2'] != null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Match Created!',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your match has been successfully created.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Match Code: ',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    Text(
                      'NCM${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/live-match-screen');
              },
              child: Text('Start Live Scoring'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/player-dashboard');
              },
              child: Text('Go to Dashboard'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Match'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Save Draft',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          ProgressIndicatorWidget(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),

          // Step Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MatchDetailsStepWidget(
                  matchData: _matchData,
                  onDataChanged: (key, value) {
                    setState(() {
                      _matchData[key] = value;
                    });
                  },
                ),
                TeamSelectionStepWidget(
                  matchData: _matchData,
                  availableTeams: _availableTeams,
                  onDataChanged: (key, value) {
                    setState(() {
                      _matchData[key] = value;
                    });
                  },
                ),
                AdvancedSettingsStepWidget(
                  matchData: _matchData,
                  onDataChanged: (key, value) {
                    setState(() {
                      _matchData[key] = value;
                    });
                  },
                ),
                ReviewStepWidget(
                  matchData: _matchData,
                  availableTeams: _availableTeams,
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentStep == _totalSteps - 1
                          ? _createMatch
                          : _nextStep,
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? 'Create Match'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
