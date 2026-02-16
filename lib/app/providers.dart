import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/local/app_database.dart';
import '../core/data/repositories/finance_repository.dart';
import '../core/services/ai_service.dart';
import '../core/services/auth_service.dart';
import '../core/services/currency_service.dart';
import '../core/services/exchange_rate_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/security_service.dart';
import '../core/services/sync_service.dart';
import '../core/services/voice_service.dart';
import '../features/settings/presentation/settings_controller.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(ref.read(appDatabaseProvider));
});

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return CurrencyService(ref.read(financeRepositoryProvider));
});

final exchangeRateServiceProvider = Provider<ExchangeRateService>((ref) {
  return ExchangeRateService(ref.read(financeRepositoryProvider));
});

final aiServiceProvider = Provider<AiService>((ref) => AiService());
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authStateProvider = StreamProvider((ref) {
  return ref.read(authServiceProvider).authStateChanges();
});
final voiceServiceProvider = Provider<VoiceService>((ref) => VoiceService());
final securityServiceProvider = Provider<SecurityService>(
  (ref) => SecurityService(),
);
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      return SettingsController();
    });
