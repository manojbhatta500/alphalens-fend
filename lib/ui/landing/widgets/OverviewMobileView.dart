import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewMobileView extends StatefulWidget {
  const OverviewMobileView({super.key});

  @override
  State<OverviewMobileView> createState() => _OverviewMobileViewState();
}

class _OverviewMobileViewState extends State<OverviewMobileView> with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();
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

    return Container(
      color: isDark ? const Color(0xFF0B1222) : const Color(0xFFF1F5F9),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Stack(
          children: [
            // ================= MAIN SCROLLABLE CONTENT =================
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 36), // Extra spacing for the top-right toggle
                              
                              // Alpha Logo Container with Dynamic Animated Glow
                              AnimatedBuilder(
                                animation: _logoController,
                                builder: (context, child) {
                                  return Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.2 + (_logoController.value * 0.3)),
                                          blurRadius: 8 + (_logoController.value * 12),
                                          spreadRadius: 1 + (_logoController.value * 2),
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'α',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              
                              // Main Branding
                              Text(
                                'ALPHA LENS',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              Text(
                                'Equity Research & Analysis System',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.blue,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Premium Intelligence Copywriter
                              Text(
                                "We integrate cutting-edge AI architectures and advanced System Dynamics simulations to decode complex market feedback loops—empowering your equity research with predictive intelligence.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              
                              const Spacer(),
                              const SizedBox(height: 48),

                              // ================= INTERACTIVE AUTH ACTIONS =================
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(maxWidth: 320),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Get Started',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Sign In Execution Trigger
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    const SizedBox(height: 12),

                                    // Create Account Execution Trigger
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        side: const BorderSide(color: Colors.blue, width: 1.5),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ================= CORNER THEME TOGGLE BUTTON =================
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}