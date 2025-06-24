import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TeamApplicationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> applications;
  final bool isNepali;

  const TeamApplicationsWidget({
    super.key,
    required this.applications,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
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
              CustomIconWidget(
                iconName: 'assignment',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                isNepali ? "टोली आवेदनहरू" : "Team Applications",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_getPendingCount() > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "${_getPendingCount()}",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          applications.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: applications.map((application) {
                    return _buildApplicationCard(application);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> application) {
    final status = application["status"] as String;
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 2.5.h,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                child: CustomImageWidget(
                  imageUrl: application["teamLogo"] as String,
                  width: 5.h,
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application["teamName"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${isNepali ? "पद:" : "Position:"} ${application["position"]}",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: statusIcon,
                      color: statusColor,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _getStatusText(status),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                "${isNepali ? "आवेदन मिति:" : "Applied on:"} ${application["appliedDate"]}",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          if (status == "pending") ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _withdrawApplication(application),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorLight,
                      side: BorderSide(color: AppTheme.errorLight),
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                    child: Text(
                      isNepali ? "फिर्ता लिनुहोस्" : "Withdraw",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _viewApplicationDetails(application),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                    child: Text(
                      isNepali ? "विवरण" : "Details",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'assignment_turned_in',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            isNepali ? "कुनै आवेदन छैन" : "No applications yet",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            isNepali
                ? "टोलीहरूमा आवेदन दिन सुरु गर्नुहोस्"
                : "Start applying to teams to see them here",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getPendingCount() {
    return applications.where((app) => app["status"] == "pending").length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return AppTheme.warningLight;
      case "accepted":
        return AppTheme.successLight;
      case "rejected":
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case "pending":
        return "schedule";
      case "accepted":
        return "check_circle";
      case "rejected":
        return "cancel";
      default:
        return "help";
    }
  }

  String _getStatusText(String status) {
    if (isNepali) {
      switch (status) {
        case "pending":
          return "पेन्डिङ";
        case "accepted":
          return "स्वीकृत";
        case "rejected":
          return "अस्वीकृत";
        default:
          return "अज्ञात";
      }
    } else {
      switch (status) {
        case "pending":
          return "Pending";
        case "accepted":
          return "Accepted";
        case "rejected":
          return "Rejected";
        default:
          return "Unknown";
      }
    }
  }

  void _withdrawApplication(Map<String, dynamic> application) {
    // Handle application withdrawal
  }

  void _viewApplicationDetails(Map<String, dynamic> application) {
    // Handle viewing application details
  }
}
