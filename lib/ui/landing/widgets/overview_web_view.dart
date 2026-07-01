import 'package:flutter/material.dart';

class OverviewWebView extends StatefulWidget {
  const OverviewWebView({super.key});

  @override
  State<OverviewWebView> createState() => _OverviewWebViewState();
}

class _OverviewWebViewState extends State<OverviewWebView> with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    // Create an infinite breathing animation for the logo glow
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // ================= LEFT SIDE: BRAND & INTELLIGENCE PANEL =================
        Expanded(
          flex: 5,
          child: Container(
            color: isDark ? const Color(0xFF0B1222) : const Color(0xFFF1F5F9),
            padding: const EdgeInsets.all(64.0),
            // Entry Animation: Fades in and slides up subtly over 800ms
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Alpha Logo Container with Dynamic Animated Glow
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2 + (_logoController.value * 0.3)),
                              blurRadius: 10 + (_logoController.value * 15),
                              spreadRadius: 1 + (_logoController.value * 3),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'α',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Main Branding
                  Text(
                    'ALPHA LENS',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Text(
                    'Equity Research & Analysis System',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.blue,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Premium Intelligence Copywriter
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Text(
                      "We integrate cutting-edge AI architectures and advanced System Dynamics simulations to decode complex market feedback loops—empowering your equity research with predictive intelligence.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ================= RIGHT SIDE: INTERACTIVE AUTH ACTIONS =================
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(64.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Get Started',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign In Execution Trigger
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Create Account Execution Trigger
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}