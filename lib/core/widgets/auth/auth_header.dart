import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_text_styles.dart';

class AuthHeader extends StatefulWidget {
  const AuthHeader({super.key});

  @override
  State<AuthHeader> createState() => _AuthHeaderState();
}

class _AuthHeaderState extends State<AuthHeader> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    if (_isKeyboardVisible != bottomInset > 100) {
      setState(() {
        _isKeyboardVisible = bottomInset > 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isKeyboardVisible) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;
    final safeTop = MediaQuery.of(context).padding.top;

    const logoContentHeight = 80.0;
    const minSpacing = 40.0;

    final maxTop = screenSize.height * 0.5 - logoContentHeight - minSpacing;
    final topPosition = (screenSize.height * 0.15).clamp(0.0, maxTop);

    return Positioned(
      top: topPosition + safeTop,
      left: 0,
      right: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/white_default_logo.png',
              width: 60,
              height: 58,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 2),
            Text('TreeMov', style: AppTextStyles.ttNorms16W900.white),
          ],
        ),
      ),
    );
  }
}
