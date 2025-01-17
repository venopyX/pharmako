import 'package:flutter/material.dart';

/// A widget that displays an animated loading indicator with optional text
class AnimatedLoading extends StatelessWidget {
  /// Optional text to display below the loading indicator
  final String? text;

  /// Optional scale factor for the loading indicator size
  final double scale;

  /// Creates an animated loading widget
  const AnimatedLoading({
    super.key,
    this.text,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: scale,
            child: const CircularProgressIndicator(),
          ),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
