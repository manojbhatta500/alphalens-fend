import 'dart:convert';

CompanyModel companyModelFromJson(String str) => CompanyModel.fromJson(json.decode(str));
String companyModelToJson(CompanyModel data) => json.encode(data.rawData);

class CompanyModel {
  // Always keep these core identifiers explicit
  final String symbol;
  final String longName;
  
  // The ultimate shield: holds everything safely
  final Map<String, dynamic> rawData;

  CompanyModel({
    required this.symbol,
    required this.longName,
    required this.rawData,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      symbol: json["symbol"]?.toString() ?? "UNKNOWN",
      longName: json["longName"] ?? json["shortName"] ?? "Unknown Company",
      rawData: json,
    );
  }

  // ==========================================================================
  // SAFE GETTERS (Protects UI from unexpected Type Changes or Missing Keys)
  // ==========================================================================

  // --- Profile / Info ---
  String get address1 => rawData["address1"]?.toString() ?? "";
  String get city => rawData["city"]?.toString() ?? "";
  String get state => rawData["state"]?.toString() ?? "";
  String get zip => rawData["zip"]?.toString() ?? "";
  String get country => rawData["country"]?.toString() ?? "";
  String get phone => rawData["phone"]?.toString() ?? "";
  String get website => rawData["website"]?.toString() ?? "";
  String get industry => rawData["industry"] ?? rawData["industryDisp"] ?? "N/A";
  String get sector => rawData["sector"] ?? rawData["sectorDisp"] ?? "N/A";
  String get longBusinessSummary => rawData["longBusinessSummary"]?.toString() ?? "No summary available.";
  int get fullTimeEmployees => _safeInt(rawData["fullTimeEmployees"]) ?? 0;

  // --- Financial Key Indicators ---
  double get currentPrice => _safeDouble(rawData["currentPrice"]) ?? 0.0;
  double get open => _safeDouble(rawData["open"]) ?? 0.0;
  double get previousClose => _safeDouble(rawData["previousClose"]) ?? 0.0;
  double get dayLow => _safeDouble(rawData["dayLow"]) ?? 0.0;
  double get dayHigh => _safeDouble(rawData["dayHigh"]) ?? 0.0;
  double get regularMarketPreviousClose => _safeDouble(rawData["regularMarketPreviousClose"]) ?? 0.0;
  double get regularMarketOpen => _safeDouble(rawData["regularMarketOpen"]) ?? 0.0;
  double get regularMarketDayLow => _safeDouble(rawData["regularMarketDayLow"]) ?? 0.0;
  double get regularMarketDayHigh => _safeDouble(rawData["regularMarketDayHigh"]) ?? 0.0;
  double get regularMarketPrice => _safeDouble(rawData["regularMarketPrice"]) ?? 0.0;
  
  // --- Targets & Analyst Opinions ---
  double get targetHighPrice => _safeDouble(rawData["targetHighPrice"]) ?? 0.0;
  double get targetLowPrice => _safeDouble(rawData["targetLowPrice"]) ?? 0.0;
  double get targetMeanPrice => _safeDouble(rawData["targetMeanPrice"]) ?? 0.0;
  double get targetMedianPrice => _safeDouble(rawData["targetMedianPrice"]) ?? 0.0;
  double get recommendationMean => _safeDouble(rawData["recommendationMean"]) ?? 0.0;
  String get recommendationKey => rawData["recommendationKey"]?.toString() ?? "N/A";
  int get numberOfAnalystOpinions => _safeInt(rawData["numberOfAnalystOpinions"]) ?? 0;

  // --- Valuation & Growth Measures ---
  int get marketCap => _safeInt(rawData["marketCap"]) ?? 0;
  int get enterpriseValue => _safeInt(rawData["enterpriseValue"]) ?? 0;
  double get priceToSalesTrailing12Months => _safeDouble(rawData["priceToSalesTrailing12Months"]) ?? 0.0;
  double get priceToBook => _safeDouble(rawData["priceToBook"]) ?? 0.0;
  double get profitMargins => _safeDouble(rawData["profitMargins"]) ?? 0.0;
  double get grossMargins => _safeDouble(rawData["grossMargins"]) ?? 0.0;
  double get ebitdaMargins => _safeDouble(rawData["ebitdaMargins"]) ?? 0.0;
  double get operatingMargins => _safeDouble(rawData["operatingMargins"]) ?? 0.0;
  double get revenueGrowth => _safeDouble(rawData["revenueGrowth"]) ?? 0.0;
  double get earningsGrowth => _safeDouble(rawData["earningsGrowth"]) ?? 0.0;

  // --- Valuation Ratios ---
  double get trailingPe => _safeDouble(rawData["trailingPE"]) ?? 0.0;
  double get forwardPe => _safeDouble(rawData["forwardPE"]) ?? 0.0;
  double get pegRatio => _safeDouble(rawData["pegRatio"]) ?? 0.0;
  double get trailingPegRatio => _safeDouble(rawData["trailingPegRatio"]) ?? 0.0;
  double get beta => _safeDouble(rawData["beta"]) ?? 0.0;

  // --- Income Statement & Balance Sheet items ---
  int get totalRevenue => _safeInt(rawData["totalRevenue"]) ?? 0;
  int get grossProfits => _safeInt(rawData["grossProfits"]) ?? 0;
  int get ebitda => _safeInt(rawData["ebitda"]) ?? 0;
  int get totalCash => _safeInt(rawData["totalCash"]) ?? 0;
  int get totalDebt => _safeInt(rawData["totalDebt"]) ?? 0;
  double get totalCashPerShare => _safeDouble(rawData["totalCashPerShare"]) ?? 0.0;
  double get revenuePerShare => _safeDouble(rawData["revenuePerShare"]) ?? 0.0;
  double get debtToEquity => _safeDouble(rawData["debtToEquity"]) ?? 0.0;
  double get quickRatio => _safeDouble(rawData["quickRatio"]) ?? 0.0;
  double get currentRatio => _safeDouble(rawData["currentRatio"]) ?? 0.0;
  double get returnOnAssets => _safeDouble(rawData["returnOnAssets"]) ?? 0.0;
  double get returnOnEquity => _safeDouble(rawData["returnOnEquity"]) ?? 0.0;
  int get freeCashflow => _safeInt(rawData["freeCashflow"]) ?? 0;
  int get operatingCashflow => _safeInt(rawData["operatingCashflow"]) ?? 0;

  // --- Dividends & Splits ---
  double get payoutRatio => _safeDouble(rawData["payoutRatio"]) ?? 0.0;
  double get trailingAnnualDividendRate => _safeDouble(rawData["trailingAnnualDividendRate"]) ?? 0.0;
  double get trailingAnnualDividendYield => _safeDouble(rawData["trailingAnnualDividendYield"]) ?? 0.0;
  String get lastSplitFactor => rawData["lastSplitFactor"]?.toString() ?? "N/A";

  // --- Volume & Trading Info ---
  int get volume => _safeInt(rawData["volume"]) ?? 0;
  int get regularMarketVolume => _safeInt(rawData["regularMarketVolume"]) ?? 0;
  int get averageVolume => _safeInt(rawData["averageVolume"]) ?? 0;
  int get averageVolume10Days => _safeInt(rawData["averageVolume10days"]) ?? 0;
  double get bid => _safeDouble(rawData["bid"]) ?? 0.0;
  double get ask => _safeDouble(rawData["ask"]) ?? 0.0;

  // --- 52 Week Ranges ---
  double get fiftyTwoWeekLow => _safeDouble(rawData["fiftyTwoWeekLow"]) ?? 0.0;
  double get fiftyTwoWeekHigh => _safeDouble(rawData["fiftyTwoWeekHigh"]) ?? 0.0;
  double get fiftyDayAverage => _safeDouble(rawData["fiftyDayAverage"]) ?? 0.0;
  double get twoHundredDayAverage => _safeDouble(rawData["twoHundredDayAverage"]) ?? 0.0;
  double get fiftyTwoWeekChangePercent => _safeDouble(rawData["fiftyTwoWeekChangePercent"]) ?? 0.0;

  // --- General Metadata Strings ---
  String get currency => rawData["currency"]?.toString() ?? "USD";
  String get financialCurrency => rawData["financialCurrency"]?.toString() ?? "USD";
  String get exchange => rawData["exchange"]?.toString() ?? "N/A";
  String get fullExchangeName => rawData["fullExchangeName"]?.toString() ?? "N/A";
  String get marketState => rawData["marketState"]?.toString() ?? "CLOSED";

  // --- Complex Nested Object Parsing ---
  List<CompanyOfficer> get companyOfficers {
    final officersData = rawData["companyOfficers"];
    if (officersData is List) {
      return officersData.map((x) => CompanyOfficer.fromJson(x)).toList();
    }
    return [];
  }

  // ==========================================================================
  // BULLETPROOF PARSING SHIELDS
  // ==========================================================================
  static double? _safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class CompanyOfficer {
  final Map<String, dynamic> _raw;

  CompanyOfficer(this._raw);

  factory CompanyOfficer.fromJson(Map<String, dynamic> json) => CompanyOfficer(json);

  String get name => _raw["name"]?.toString() ?? "Unknown";
  String get title => _raw["title"]?.toString() ?? "Officer";
  int get age => CompanyModel._safeInt(_raw["age"]) ?? 0;
  int get totalPay => CompanyModel._safeInt(_raw["totalPay"]) ?? 0;
}