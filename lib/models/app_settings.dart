/// Model class representing application settings
class AppSettings {
  // Theme settings
  final bool isDarkMode;
  final String primaryColor;
  final bool highContrastMode;
  final bool animationsEnabled;

  // Display settings
  final String language;
  final String dateFormat;
  final bool use24HourFormat;
  final String currency;
  final int decimalPlaces;

  // Inventory settings
  final int lowStockThreshold;
  final int expiryWarningDays;
  final bool autoGenerateBarcodes;
  final bool trackBatchNumbers;
  final bool enableLocationTracking;

  // Sales settings
  final bool requireCustomerInfo;
  final bool printReceipts;
  final bool allowDiscounts;
  final double maxDiscountPercent;
  final bool trackSalesPerson;

  // Backup settings
  final bool autoBackup;
  final int backupFrequencyDays;
  final String backupLocation;
  final int retainBackupDays;
  final bool compressBackups;

  // Security settings
  final int sessionTimeoutMinutes;
  final bool requirePasswordChange;
  final int passwordExpiryDays;
  final bool twoFactorAuth;
  final bool logFailedAttempts;

  const AppSettings({
    // Theme settings
    this.isDarkMode = false,
    this.primaryColor = 'blue',
    this.highContrastMode = false,
    this.animationsEnabled = true,

    // Display settings
    this.language = 'en',
    this.dateFormat = 'MM/dd/yyyy',
    this.use24HourFormat = false,
    this.currency = 'USD',
    this.decimalPlaces = 2,

    // Inventory settings
    this.lowStockThreshold = 10,
    this.expiryWarningDays = 30,
    this.autoGenerateBarcodes = true,
    this.trackBatchNumbers = true,
    this.enableLocationTracking = false,

    // Sales settings
    this.requireCustomerInfo = false,
    this.printReceipts = true,
    this.allowDiscounts = true,
    this.maxDiscountPercent = 20.0,
    this.trackSalesPerson = true,

    // Backup settings
    this.autoBackup = true,
    this.backupFrequencyDays = 1,
    this.backupLocation = 'backups/',
    this.retainBackupDays = 30,
    this.compressBackups = true,

    // Security settings
    this.sessionTimeoutMinutes = 30,
    this.requirePasswordChange = true,
    this.passwordExpiryDays = 90,
    this.twoFactorAuth = false,
    this.logFailedAttempts = true,
  });

  /// Create a copy of this settings with updated fields
  AppSettings copyWith({
    bool? isDarkMode,
    String? primaryColor,
    bool? highContrastMode,
    bool? animationsEnabled,
    String? language,
    String? dateFormat,
    bool? use24HourFormat,
    String? currency,
    int? decimalPlaces,
    int? lowStockThreshold,
    int? expiryWarningDays,
    bool? autoGenerateBarcodes,
    bool? trackBatchNumbers,
    bool? enableLocationTracking,
    bool? requireCustomerInfo,
    bool? printReceipts,
    bool? allowDiscounts,
    double? maxDiscountPercent,
    bool? trackSalesPerson,
    bool? autoBackup,
    int? backupFrequencyDays,
    String? backupLocation,
    int? retainBackupDays,
    bool? compressBackups,
    int? sessionTimeoutMinutes,
    bool? requirePasswordChange,
    int? passwordExpiryDays,
    bool? twoFactorAuth,
    bool? logFailedAttempts,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      currency: currency ?? this.currency,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      expiryWarningDays: expiryWarningDays ?? this.expiryWarningDays,
      autoGenerateBarcodes: autoGenerateBarcodes ?? this.autoGenerateBarcodes,
      trackBatchNumbers: trackBatchNumbers ?? this.trackBatchNumbers,
      enableLocationTracking: enableLocationTracking ?? this.enableLocationTracking,
      requireCustomerInfo: requireCustomerInfo ?? this.requireCustomerInfo,
      printReceipts: printReceipts ?? this.printReceipts,
      allowDiscounts: allowDiscounts ?? this.allowDiscounts,
      maxDiscountPercent: maxDiscountPercent ?? this.maxDiscountPercent,
      trackSalesPerson: trackSalesPerson ?? this.trackSalesPerson,
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequencyDays: backupFrequencyDays ?? this.backupFrequencyDays,
      backupLocation: backupLocation ?? this.backupLocation,
      retainBackupDays: retainBackupDays ?? this.retainBackupDays,
      compressBackups: compressBackups ?? this.compressBackups,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      requirePasswordChange: requirePasswordChange ?? this.requirePasswordChange,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      logFailedAttempts: logFailedAttempts ?? this.logFailedAttempts,
    );
  }

  /// Convert settings to JSON
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'primaryColor': primaryColor,
      'highContrastMode': highContrastMode,
      'animationsEnabled': animationsEnabled,
      'language': language,
      'dateFormat': dateFormat,
      'use24HourFormat': use24HourFormat,
      'currency': currency,
      'decimalPlaces': decimalPlaces,
      'lowStockThreshold': lowStockThreshold,
      'expiryWarningDays': expiryWarningDays,
      'autoGenerateBarcodes': autoGenerateBarcodes,
      'trackBatchNumbers': trackBatchNumbers,
      'enableLocationTracking': enableLocationTracking,
      'requireCustomerInfo': requireCustomerInfo,
      'printReceipts': printReceipts,
      'allowDiscounts': allowDiscounts,
      'maxDiscountPercent': maxDiscountPercent,
      'trackSalesPerson': trackSalesPerson,
      'autoBackup': autoBackup,
      'backupFrequencyDays': backupFrequencyDays,
      'backupLocation': backupLocation,
      'retainBackupDays': retainBackupDays,
      'compressBackups': compressBackups,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'requirePasswordChange': requirePasswordChange,
      'passwordExpiryDays': passwordExpiryDays,
      'twoFactorAuth': twoFactorAuth,
      'logFailedAttempts': logFailedAttempts,
    };
  }

  /// Create settings from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      primaryColor: json['primaryColor'] as String? ?? 'blue',
      highContrastMode: json['highContrastMode'] as bool? ?? false,
      animationsEnabled: json['animationsEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      dateFormat: json['dateFormat'] as String? ?? 'MM/dd/yyyy',
      use24HourFormat: json['use24HourFormat'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'USD',
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
      lowStockThreshold: json['lowStockThreshold'] as int? ?? 10,
      expiryWarningDays: json['expiryWarningDays'] as int? ?? 30,
      autoGenerateBarcodes: json['autoGenerateBarcodes'] as bool? ?? true,
      trackBatchNumbers: json['trackBatchNumbers'] as bool? ?? true,
      enableLocationTracking: json['enableLocationTracking'] as bool? ?? false,
      requireCustomerInfo: json['requireCustomerInfo'] as bool? ?? false,
      printReceipts: json['printReceipts'] as bool? ?? true,
      allowDiscounts: json['allowDiscounts'] as bool? ?? true,
      maxDiscountPercent: (json['maxDiscountPercent'] as num?)?.toDouble() ?? 20.0,
      trackSalesPerson: json['trackSalesPerson'] as bool? ?? true,
      autoBackup: json['autoBackup'] as bool? ?? true,
      backupFrequencyDays: json['backupFrequencyDays'] as int? ?? 1,
      backupLocation: json['backupLocation'] as String? ?? 'backups/',
      retainBackupDays: json['retainBackupDays'] as int? ?? 30,
      compressBackups: json['compressBackups'] as bool? ?? true,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] as int? ?? 30,
      requirePasswordChange: json['requirePasswordChange'] as bool? ?? true,
      passwordExpiryDays: json['passwordExpiryDays'] as int? ?? 90,
      twoFactorAuth: json['twoFactorAuth'] as bool? ?? false,
      logFailedAttempts: json['logFailedAttempts'] as bool? ?? true,
    );
  }

  /// Get default settings
  factory AppSettings.defaults() {
    return const AppSettings();
  }
}
