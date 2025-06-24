import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CricketLogoWidget extends StatefulWidget {
  final double size;
  final Color color;

  const CricketLogoWidget({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  State<CricketLogoWidget> createState() => _CricketLogoWidgetState();
}

class _CricketLogoWidgetState extends State<CricketLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color.withValues(alpha: 0.1),
        border: Border.all(
          color: widget.color.withValues(alpha: 0.3),
          width: 2.0,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring
          Container(
            width: widget.size * 0.9,
            height: widget.size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
          ),

          // Cricket Ball Animation
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: CustomIconWidget(
                  iconName: 'sports_cricket',
                  color: widget.color,
                  size: widget.size * 0.4,
                ),
              );
            },
          ),

          // Center Cricket Stumps
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stumps
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Container(
                      width: 2.0,
                      height: widget.size * 0.15,
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    );
                  }),
                ),

                // Bails
                Container(
                  width: widget.size * 0.08,
                  height: 1.5,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
              ],
            ),
          ),

          // App Initial Letters
          Positioned(
            bottom: widget.size * 0.15,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 0.5.h,
              ),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'nC',
                style: TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: widget.size * 0.12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
