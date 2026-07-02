import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:alphalens_fend/ui/company/company.dart';
import 'package:alphalens_fend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🛠️ Premium Functional Modules Enum 
/// Handles individual styling, assets, and future navigation features cleanly.
enum DashboardModule {
  watchlist('Watchlist', Icons.star_border_rounded, Color(0xffFFB020)),
  research('Research', Icons.analytics_outlined, Color(0xff9C27B0)),
  analysis('Analysis', Icons.donut_large_rounded, Color(0xff1D9BF0)),
  entity('Entity', Icons.layers_outlined, Color(0xff10B981));

  final String title;
  final IconData icon;
  final Color accentColor;

  const DashboardModule(this.title, this.icon, this.accentColor);

  /// Centralized Router: Add your navigation/logic for each card here!
  void handleTap(BuildContext context) {
    switch (this) {
      case DashboardModule.watchlist:
        // TODO: Navigate to Watchlist view
        break;
      case DashboardModule.research:
        // TODO: Fire off Research API actions / navigate
        break;
      case DashboardModule.analysis:
        // TODO: Open System Dynamics / Simulation panel
        break;
      case DashboardModule.entity:
        // TODO: Route to Knowledge Graph / Entity explorer
        break;
    }
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});


  /// Centralized ticker navigation logic
  void _navigateToTicker(BuildContext context, String ticker) {
    final cleanTicker = ticker.trim().toUpperCase();
    if (cleanTicker.isEmpty) return;

    // showFeedback(context, cleanTicker, Colors.blue);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Company(ticker: cleanTicker,),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Chatbot Floating Action Button with a subtle pulse neon shadow
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff1d9bf0).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Initialize Custom LLM Chatbot
          },
          elevation: 0,
          backgroundColor: const Color(0xff1d9bf0),
          icon: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
          label: const Text(
            'Alpha AI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 14,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isWeb = maxWidth > 750;
            final double horizontalPadding = isWeb ? 64.0 : 24.0;

            return Stack(
              children: [
                // Top Navigation Header (Logo & Global Controls)
                Positioned(
                  top: 20,
                  left: horizontalPadding,
                  right: horizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Alpha Lens Premium Brand Signature
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff1d9bf0), Color(0xff007bb5)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff1d9bf0).withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'α',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ),
                          if (isWeb) ...[
                            const SizedBox(width: 14),
                            Text(
                              'ALPHA LENS',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0,
                                color: theme.colorScheme.onSurface.withOpacity(0.85),
                              ),
                            ),
                          ]
                        ],
                      ),
                      
                      // Global Actions Core
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceContainerLow.withOpacity(0.5),
                              padding: const EdgeInsets.all(10),
                            ),
                            icon: Icon(
                              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              size: 20,
                            ),
                            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                          ),
                          const SizedBox(width: 12),
                          
                          // Interactive Profile Anchor
                          PopupMenuButton<String>(
                            onSelected: (value) {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
                            ),
                            offset: const Offset(0, 50),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              child: Icon(
                                Icons.person_outline_rounded,
                                size: 22,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(Icons.settings_outlined, size: 18),
                                    SizedBox(width: 12),
                                    Text('Settings', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout_rounded, size: 18, color: theme.colorScheme.error),
                                    const SizedBox(width: 12),
                                    Text('Logout', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Core Main Body Layout Panel
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24.0,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 90), // Spacing below top navigation bar
                          
                          // Component 1: Search Console
                          _buildPremiumSearchBar(theme, maxWidth, context),
                          const SizedBox(height: 32),

                          // Component 2: High-contrast Ticker Badges
                          _buildPremiumTickerChips(theme, context),
                          const SizedBox(height: 40),

                          // Sophisticated Custom Micro-Divider Layout
                          Row(
                            children: [
                              Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.1), thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(Icons.insights_rounded, size: 16, color: theme.colorScheme.outline.withOpacity(0.3)),
                              ),
                              Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.1), thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Component 3: Premium Dynamic Presentation View Modules
                          _buildPremiumAnalysisGrid(context, theme, maxWidth),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// COMPONENT 1: Premium Glassmorphic Search Field
  Widget _buildPremiumSearchBar(ThemeData theme, double maxWidth,BuildContext context) {
    final double searchWidth = maxWidth > 600 ? 580 : maxWidth;

    return SizedBox(
      width: searchWidth,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: TextField(
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
         onSubmitted: (value) => _navigateToTicker(context, value),
          decoration: InputDecoration(
            hintText: 'Search ticker (e.g., TSLA, MSFT)...',
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary.withOpacity(0.7)),
            suffixIcon: Icon(Icons.arrow_right, color: theme.colorScheme.outline),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            filled: true,
            fillColor: theme.brightness == Brightness.dark 
                ? theme.colorScheme.surfaceContainerLow.withOpacity(0.7)
                : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.6), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  /// COMPONENT 2: Premium Clean Financial Ticker Micro-Chips
  Widget _buildPremiumTickerChips(ThemeData theme, BuildContext context) {
    final tickers = ['TSLA', 'MSFT', 'GOOG', 'META'];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: tickers.map((ticker) {
        return InkWell(
          onTap: () => _navigateToTicker(context, ticker),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              ticker,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// COMPONENT 3: Responsive Action Modular Matrix driven by DashboardModule Enum
  Widget _buildPremiumAnalysisGrid(BuildContext context, ThemeData theme, double maxWidth) {
    final modules = DashboardModule.values;

    if (maxWidth < 650) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: modules.map((mod) => _buildAnimatedModuleCard(
          context,
          mod, 
          theme, 
          width: (maxWidth - 64) / 2,
        )).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: modules.map((mod) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildAnimatedModuleCard(
            context,
            mod, 
            theme,
          ),
        ),
      )).toList(),
    );
  }

  /// Custom Interactive Feature Cards compiled from unique DashboardModule definitions
  Widget _buildAnimatedModuleCard(BuildContext context, DashboardModule module, ThemeData theme, {double? width}) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: 130,
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.04 : 0.025),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => module.handleTap(context),
          borderRadius: BorderRadius.circular(24),
          splashColor: module.accentColor.withOpacity(0.05),
          highlightColor: module.accentColor.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: module.accentColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    module.icon,
                    size: 24,
                    color: module.accentColor,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  module.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}