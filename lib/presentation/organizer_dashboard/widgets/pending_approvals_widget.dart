import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PendingApprovalsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> approvals;
  final bool isNepali;
  final Function(Map<String, dynamic>) onApprove;
  final Function(Map<String, dynamic>) onDecline;

  const PendingApprovalsWidget({
    super.key,
    required this.approvals,
    required this.isNepali,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNepali ? "अनुमोदनका लागि पेन्डिङ" : "Pending Approvals",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (approvals.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "${approvals.length}",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (approvals.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: approvals.length > 3 ? 3 : approvals.length,
              itemBuilder: (context, index) {
                final approval = approvals[index];
                return _buildApprovalCard(approval);
              },
            ),
          if (approvals.length > 3)
            TextButton(
              onPressed: () {},
              child: Text(
                isNepali
                    ? "सबै हेर्नुहोस् (${approvals.length})"
                    : "View All (${approvals.length})",
                style: TextStyle(color: AppTheme.lightTheme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> approval) {
    final bool isTeamApplication = approval["type"] == "team_application";

    return Dismissible(
      key: Key("approval_${approval["id"]}"),
      background: Container(
        margin: EdgeInsets.only(bottom: 3.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(3.w),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'check',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              isNepali ? "स्वीकार" : "Accept",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 3.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(3.w),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              isNepali ? "अस्वीकार" : "Decline",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'close',
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onApprove(approval);
        } else {
          onDecline(approval);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: AppTheme.warningLight.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isTeamApplication
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        isTeamApplication ? 'person_add' : 'sports_cricket',
                    color: isTeamApplication
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.successLight,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTeamApplication
                            ? (isNepali ? "टोली आवेदन" : "Team Application")
                            : (isNepali ? "खेल अनुरोध" : "Match Request"),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        isTeamApplication
                            ? "${approval["playerName"]} - ${approval["teamName"]}"
                            : "${approval["requestingTeam"]} vs ${approval["opponentTeam"]}",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isTeamApplication)
                        Text(
                          "${isNepali ? "स्थिति" : "Position"}: ${approval["position"]}",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        )
                      else
                        Text(
                          "${isNepali ? "स्थान" : "Venue"}: ${approval["venue"]}",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    isNepali ? "पेन्डिङ" : "Pending",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onDecline(approval),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.errorLight,
                      size: 16,
                    ),
                    label: Text(
                      isNepali ? "अस्वीकार" : "Decline",
                      style: TextStyle(color: AppTheme.errorLight),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.errorLight),
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onApprove(approval),
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      isNepali ? "स्वीकार" : "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successLight,
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successLight.withValues(alpha: 0.7),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            isNepali ? "कुनै पेन्डिङ अनुमोदन छैन" : "No pending approvals",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            isNepali
                ? "सबै आवेदनहरू प्रक्रिया भइसकेका छन्"
                : "All applications have been processed",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
