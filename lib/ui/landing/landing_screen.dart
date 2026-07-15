import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:alphalens_fend/ui/landing/widgets/OverviewMobileView.dart';
import 'package:alphalens_fend/ui/landing/widgets/overview_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Global Persistent Theme Toggle Button Position
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),
          
          // Responsive Screen Layout Discriminator Switch
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return const OverviewWebView();
              } else {
                // When you make your mobile file later, return OverviewMobileView() here!
                return const OverviewMobileView(); 
              }
            },
          ),
        ],
      ),
    );
  }
}