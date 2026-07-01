import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:alphalens_fend/ui/auth/widgets/signup_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Theme Toggle Button (Top Right Corner)
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),
          
          // Layout Switcher
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return const SignupWeb();
              } else {
                // Future mobile placeholder
                return const SignupWeb();
              }
            },
          ),
        ],
      ),
    );
  }
}