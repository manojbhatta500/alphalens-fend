import 'package:alphalens_fend/blocs/Extract_entity/extract_entity_cubit.dart';
import 'package:alphalens_fend/blocs/company/company_cubit.dart';
import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:alphalens_fend/data/models/company_model.dart';
import 'package:alphalens_fend/data/models/extract_entity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Company extends StatefulWidget {
  final String ticker;

  const Company({super.key, required this.ticker});

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    context.read<CompanyCubit>().fetchCompanyDetails(widget.ticker);
    context.read<ExtractEntityCubit>().fetchCompanyEntities(widget.ticker.toUpperCase()); // Trigger the fetch for ExtractEntityCubit
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openWebsite(String urlString) async {
    final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not route link address to: $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<CompanyCubit, CompanyState>(
          builder: (context, state) {
            if (state is CompanyLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              );
            } else if (state is CompanyLoaded) {
              return _buildTerminalLayout(context, theme, state.company);
            } else if (state is CompanyError) {
              return _buildPremiumErrorView(theme, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// 🖥️ UNIFIED RESPONSIVE TERMINAL LAYOUT
  Widget _buildTerminalLayout(BuildContext context, ThemeData theme, CompanyModel company) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 950;
        final double hPadding = isDesktop ? 32.0 : 16.0;

        return Column(
          children: [
            // 1. Scaled Header Bar (Responsive font scaling to avoid overflows)
            _buildTerminalHeader(context, theme, company, isDesktop, hPadding, constraints.maxWidth),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      children: [
                        isDesktop 
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Content Sheets Selector Canvas
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildTabBarNavigation(theme),
                                        const SizedBox(height: 20),
                                        _buildTabbedContentArea(theme, company),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Sidebar Analytics Panel
                                  Expanded(
                                    flex: 2,
                                    child: _buildPersistentMetricsSidebar(theme, company),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPersistentMetricsSidebar(theme, company),
                                  const SizedBox(height: 24),
                                  _buildTabBarNavigation(theme),
                                  const SizedBox(height: 16),
                                  _buildTabbedContentArea(theme, company),
                                ],
                              ),
                        const SizedBox(height: 40),
                        // Ethical Open Source Data Acknowledgment Disclaimer
                        _buildInstitutionalFooter(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// COMPONENT 1: Responsive Terminal Header
  Widget _buildTerminalHeader(BuildContext context, ThemeData theme, CompanyModel company, bool isDesktop, double hPadding, double screenWidth) {
    final isDark = theme.brightness == Brightness.dark;
    final double change = company.currentPrice - company.previousClose;
    final double changePercent = company.previousClose != 0 ? (change / company.previousClose) * 100 : 0.0;
    final bool isPositive = change >= 0;
    final Color metricColor = isPositive ? const Color(0xff10B981) : const Color(0xffEF4444);

    // Dynamic Title & Price Scaling Based on Available Grid Width
    final double titleSize = screenWidth < 450 ? 18 : (screenWidth < 700 ? 22 : 26);
    final double priceSize = screenWidth < 450 ? 20 : (screenWidth < 700 ? 24 : 28);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withOpacity(0.4),
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.06))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface, size: 16),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          company.symbol.toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900, 
                            color: theme.colorScheme.primary, 
                            letterSpacing: 1.0,
                            fontSize: 14
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            company.exchange,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold, 
                              color: theme.colorScheme.primary,
                              fontSize: 10
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company.longName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800, 
                        letterSpacing: -0.5,
                        fontSize: titleSize
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${company.currentPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900, 
                        fontFamily: 'Courier',
                        fontSize: priceSize
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: metricColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: metricColor, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${isPositive ? "+" : ""}${changePercent.toStringAsFixed(2)}%',
                            style: theme.textTheme.labelSmall?.copyWith(color: metricColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 18),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
    );
  }

  /// COMPONENT 2: Rebranded Professional Navigation Controller
  Widget _buildTabBarNavigation(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
        labelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: "Business Profile"),
          Tab(text: "Financial Data"),
          Tab(text: "Corporate Team"),
          Tab(text: "Entities")
        ],
      ),
    );
  }

  /// COMPONENT 3: Canvas Pipeline
  Widget _buildTabbedContentArea(ThemeData theme, CompanyModel company) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return _buildBusinessProfileTab(theme, company);
          case 1:
            return _buildFinancialDataTab(theme, company);
          case 2:
            return _buildCorporateTeamTab(theme, company);
          case 3:
            return _buildAiEntitiesTab(context, theme, company.symbol.toUpperCase()); 
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }/// TAB 4: AI Extracted Entities Network (Fully Responsive Grid)
  Widget _buildAiEntitiesTab(BuildContext context, ThemeData theme, String ticker) {
    return BlocBuilder<ExtractEntityCubit, ExtractEntityState>(
      builder: (context, state) {
        if (state is ExtractEntityLoading) {
          return  Container(
            padding: EdgeInsets.all(48),
            alignment: Alignment.center,
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        if (state is ExtractEntityError) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 36),
                const SizedBox(height: 12),
                Text(
                  state.message, 
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is ExtractEntitySuccess) {
          final List<Entities> entitiesList = state.extractEntityModel.entities ?? [];

          if (entitiesList.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Text(
                "No extracted entity data available for $ticker.", 
                style: theme.textTheme.bodyMedium
              ),
            );
          }

          final Map<String, List<Entities>> groupedEntities = {
            'PERSON': [],
            'COMPANY': [],
            'PRODUCT': [],
            'PLACE': [],
          };

          for (var entity in entitiesList) {
            final type = (entity.entityType ?? '').toUpperCase();
            if (groupedEntities.containsKey(type)) {
              groupedEntities[type]!.add(entity);
            }
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, left: 4.0),
                  child: Text(
                    "AI-Generated Network Analysis for $ticker",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                _buildHorizontalBlueprintSection(theme, 'Key Personnel', Icons.psychology_rounded, Colors.purple, groupedEntities['PERSON']!),
                const SizedBox(height: 24),
                _buildHorizontalBlueprintSection(theme, 'Affiliated Companies', Icons.business_rounded, Colors.orange, groupedEntities['COMPANY']!),
                const SizedBox(height: 24),
                _buildHorizontalBlueprintSection(theme, 'Products & Brands', Icons.token_rounded, Colors.green, groupedEntities['PRODUCT']!),
                const SizedBox(height: 24),
                _buildHorizontalBlueprintSection(theme, 'Geographic Places', Icons.map_rounded, Colors.blue, groupedEntities['PLACE']!),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Responsive section that scales column item widths according to device screen space constraints
  Widget _buildHorizontalBlueprintSection(ThemeData theme, String title, IconData icon, Color color, List<Entities> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title, 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
              child: Text('${items.length}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
            )
          ],
        ),
        const SizedBox(height: 12),
        
        LayoutBuilder(
          builder: (context, constraints) {
            // Determine active column count based on horizontal footprint breakpoint
            int crossAxisCount = 4;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 1; // Pure mobile portrait view standard
            } else if (constraints.maxWidth < 1000) {
              crossAxisCount = 2; // Tablet or split-screen mode landscape window
            }

            // Calculate precise fractional widths factoring in structural margins
            final double itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 12)) / crossAxisCount;

            return Wrap(
              spacing: 12.0, 
              runSpacing: 12.0, 
              children: items.map((item) {
                final String subText = [
                  if (item.role.isNotEmpty) item.role,
                  if (item.details.isNotEmpty) item.details,
                ].join(' • ');

                return InkWell(
                  onTap: () async {
                    if (item.name.isEmpty) return;
                    final Uri searchUrl = Uri.parse(
                      'https://www.google.com/search?q=${Uri.encodeComponent(item.name)}'
                    );
                    if (await canLaunchUrl(searchUrl)) {
                      await launchUrl(searchUrl, mode: LaunchMode.externalApplication);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: itemWidth,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerLow : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.08)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (subText.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subText,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.open_in_new_rounded, 
                          size: 12, 
                          color: theme.colorScheme.onSurface.withOpacity(0.2)
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }


  /// TAB 1: Business Profile Canvas (Fixed truncation, embedded link support)
  Widget _buildBusinessProfileTab(ThemeData theme, CompanyModel company) {
    final String fullAddress = "${company.address1}, ${company.city}, ${company.state} ${company.zip}, ${company.country}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFullWidthMetaRow(theme, Icons.maps_home_work_outlined, "Headquarters", fullAddress),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, thickness: 0.5)),
              _buildFullWidthMetaRow(
                theme, 
                Icons.language_rounded, 
                "Website", 
                company.website,
                isAnchor: true,
                onTap: () => _openWebsite(company.website),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, thickness: 0.5)),
              _buildFullWidthMetaRow(theme, Icons.phone_android_rounded, "Contact Phone", company.phone),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, thickness: 0.5)),
              _buildFullWidthMetaRow(theme, Icons.badge_outlined, "Full-time Staff", "${company.fullTimeEmployees} Employees"),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerLow : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.text_snippet_outlined, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Text('Executive Operational Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                company.longBusinessSummary.isNotEmpty ? company.longBusinessSummary : 'No business summary data available.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.65),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// TAB 2: Financial Data Sheets (Clean metrics presentation, removed "Vector" jargon)
  Widget _buildFinancialDataTab(ThemeData theme, CompanyModel company) {
    return Column(
      children: [
        _buildHighDensityMetricsGrid(
          theme: theme,
          title: "Valuation, Margins & Splits",
          icon: Icons.pie_chart_outline_rounded,
          iconColor: Colors.amber,
          items: [
            {'label': 'Trailing P/E Ratio', 'value': company.trailingPe.toStringAsFixed(2)},
            {'label': 'Forward P/E Ratio', 'value': company.forwardPe.toStringAsFixed(2)},
            {'label': 'PEG Ratio', 'value': company.pegRatio.toStringAsFixed(2)},
            {'label': 'Trailing PEG Ratio', 'value': company.trailingPegRatio.toStringAsFixed(2)},
            {'label': 'Price to Sales (TTM)', 'value': company.priceToSalesTrailing12Months.toStringAsFixed(2)},
            {'label': 'Price to Book Value', 'value': company.priceToBook.toStringAsFixed(2)},
            {'label': 'Gross Margins %', 'value': '${(company.grossMargins * 100).toStringAsFixed(2)}%'},
            {'label': 'EBITDA Margins %', 'value': '${(company.ebitdaMargins * 100).toStringAsFixed(2)}%'},
            {'label': 'Operating Margins %', 'value': '${(company.operatingMargins * 100).toStringAsFixed(2)}%'},
            {'label': 'Profit Margins %', 'value': '${(company.profitMargins * 100).toStringAsFixed(2)}%'},
            {'label': 'Last Split Factor', 'value': company.lastSplitFactor},
          ],
        ),
        const SizedBox(height: 20),
        _buildHighDensityMetricsGrid(
          theme: theme,
          title: "Income Sheet & Balance Sheet Data",
          icon: Icons.account_balance_wallet_outlined,
          iconColor: Colors.teal,
          items: [
            {'label': 'Total Revenue', 'value': '\$${(company.totalRevenue / 1e9).toStringAsFixed(2)}B'},
            {'label': 'Revenue Per Share', 'value': '\$${company.revenuePerShare.toStringAsFixed(2)}'},
            {'label': 'Revenue Growth %', 'value': '${(company.revenueGrowth * 100).toStringAsFixed(2)}%'},
            {'label': 'Gross Profits', 'value': '\$${(company.grossProfits / 1e9).toStringAsFixed(2)}B'},
            {'label': 'EBITDA', 'value': '\$${(company.ebitda / 1e9).toStringAsFixed(2)}B'},
            {'label': 'Earnings Growth %', 'value': '${(company.earningsGrowth * 100).toStringAsFixed(2)}%'},
            {'label': 'Total Cash Asset Pool', 'value': '\$${(company.totalCash / 1e9).toStringAsFixed(2)}B'},
            {'label': 'Total Cash Per Share', 'value': '\$${company.totalCashPerShare.toStringAsFixed(2)}'},
            {'label': 'Total Outstanding Debt', 'value': '\$${(company.totalDebt / 1e9).toStringAsFixed(2)}B'},
            {'label': 'Debt to Equity Multiplier', 'value': company.debtToEquity.toStringAsFixed(2)},
            {'label': 'Quick Liquidity Ratio', 'value': company.quickRatio.toStringAsFixed(2)},
            {'label': 'Current Liquidity Ratio', 'value': company.currentRatio.toStringAsFixed(2)},
            {'label': 'Operating Cash Flow', 'value': '\$${(company.operatingCashflow / 1e9).toStringAsFixed(2)}B'},
            {'label': 'Free Cash Flow Value', 'value': '\$${(company.freeCashflow / 1e9).toStringAsFixed(2)}B'},
          ],
        ),
      ],
    );
  }

  /// TAB 3: Corporate Team Sheet (With clickable list interaction nodes)
  Widget _buildCorporateTeamTab(ThemeData theme, CompanyModel company) {
    if (company.companyOfficers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Text("No corporate team data available.", style: theme.textTheme.bodyMedium),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_rounded, color: Colors.blue, size: 22),
              const SizedBox(width: 10),
              Text('Key Executive Officers', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: company.companyOfficers.length,
            separatorBuilder: (context, index) => Divider(color: theme.dividerColor.withOpacity(0.05)),
            itemBuilder: (context, index) {
              final officer = company.companyOfficers[index];
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Profile analysis vector for ${officer.name} is scheduled for future initialization.'),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          officer.name.isNotEmpty ? officer.name[0] : "?", 
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(officer.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(officer.title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (officer.totalPay > 0)
                            Text('\$${(officer.totalPay / 1e6).toStringAsFixed(2)}M', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontFamily: 'Courier')),
                          if (officer.age > 0)
                            Text('Age: ${officer.age}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// COMPONENT 4: Persistent Analytics Sidebar Terminal
 
 
 
 
  Widget _buildPersistentMetricsSidebar(ThemeData theme, CompanyModel company) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: const Color(0xff9C27B0), size: 22),
              const SizedBox(width: 10),
              Text('Core Analytics Block', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          _buildHighDensityRow(theme, "Market Capitalization", '\$${(company.marketCap / 1e12).toStringAsFixed(3)}T'),
          _buildHighDensityRow(theme, "Enterprise Valuation", '\$${(company.enterpriseValue / 1e12).toStringAsFixed(3)}T'),
          _buildHighDensityRow(theme, "Beta Risk Index", company.beta.toStringAsFixed(2)),
          _buildHighDensityRow(theme, "Daily Volume Level", _formatLargeInt(company.volume)),
          _buildHighDensityRow(theme, "Average Volume (10D)", _formatLargeInt(company.averageVolume10Days)),
          _buildHighDensityRow(theme, "Ask Price Tracker", '\$${company.ask.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "Bid Price Tracker", '\$${company.bid.toStringAsFixed(2)}'),
          Divider(color: theme.dividerColor.withOpacity(0.06), height: 24),
          _buildHighDensityRow(theme, "52-Week Range Low", '\$${company.fiftyTwoWeekLow.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "52-Week Range High", '\$${company.fiftyTwoWeekHigh.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "50-Day Baseline Avg", '\$${company.fiftyDayAverage.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "200-Day Baseline Avg", '\$${company.twoHundredDayAverage.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "52-Week Delta %", '${(company.fiftyTwoWeekChangePercent * 100).toStringAsFixed(2)}%'),
          Divider(color: theme.dividerColor.withOpacity(0.06), height: 24),
          _buildHighDensityRow(theme, "Target High Valuation", '\$${company.targetHighPrice.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "Target Mean Consensus", '\$${company.targetMeanPrice.toStringAsFixed(2)}'),
          _buildHighDensityRow(theme, "Analyst Recommendation", company.recommendationKey.toUpperCase()),
          _buildHighDensityRow(theme, "Total Analyst Consensus Pool", '${company.numberOfAnalystOpinions} Opinions'),
        ],
      ),
    );
  }

  /// COMPONENT 5: Ethical Open-Source Acknowledgment Footer
  Widget _buildInstitutionalFooter(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Divider(color: theme.dividerColor.withOpacity(0.06)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.35)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "All financial visualizations and entity metadata displayed are derived exclusively from open-source repository streams. AlphaLens presents this metrics compilation without implicit transactional warranty.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.35),
                    fontSize: 11,
                    height: 1.4
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// REUSABLE META ROW (Fixes truncation by wrapping naturally or creating actionable hyperlinks)
  Widget _buildFullWidthMetaRow(ThemeData theme, IconData icon, String label, String value, {bool isAnchor = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: isAnchor
                ? InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Text(
                      value.isNotEmpty ? value : "N/A",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    value.isNotEmpty ? value : "N/A",
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }

  /// REUSABLE METRICS GENERATOR TABLE BLOCK
  Widget _buildHighDensityMetricsGrid({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 40,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                // decoration: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.03))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(items[index]['label']!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w600)),
                    Text(items[index]['value']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Courier')),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildHighDensityRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w600)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontFamily: 'Courier')),
        ],
      ),
    );
  }

  String _formatLargeInt(int val) {
    if (val >= 1e9) return '${(val / 1e9).toStringAsFixed(2)}B';
    if (val >= 1e6) return '${(val / 1e6).toStringAsFixed(2)}M';
    return val.toString();
  }

  Widget _buildPremiumErrorView(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 44),
            const SizedBox(height: 16),
            Text('Data Transmission Halt', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<CompanyCubit>().fetchCompanyDetails(widget.ticker),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry Connection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}