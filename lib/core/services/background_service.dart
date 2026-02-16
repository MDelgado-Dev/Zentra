import 'package:workmanager/workmanager.dart';

import '../data/local/app_database.dart';
import '../data/repositories/finance_repository.dart';
import 'exchange_rate_service.dart';

const String taskUpdateRates = 'update_rates';
const String taskProcessRecurring = 'process_recurring';
const String taskDailySnapshot = 'daily_snapshot';

class BackgroundService {
  Future<void> initialize() async {
    await Workmanager().initialize(_dispatcher, isInDebugMode: false);
  }

  Future<void> registerTasks() async {
    await Workmanager().registerPeriodicTask(
      taskUpdateRates,
      taskUpdateRates,
      frequency: const Duration(minutes: 15),
    );
  }
}

@pragma('vm:entry-point')
void _dispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskUpdateRates) {
      final db = AppDatabase();
      final repository = FinanceRepository(db);
      final service = ExchangeRateService(repository);
      await service.updateRatesIfNeeded();
      await db.close();
    } else if (task == taskProcessRecurring) {
      await _processRecurring();
    } else if (task == taskDailySnapshot) {
      await _dailySnapshot();
    }
    return Future.value(true);
  });
}

Future<void> _processRecurring() async {
  // Placeholder for recurring transactions processing.
}

Future<void> _dailySnapshot() async {
  // Placeholder for daily finance snapshot generation.
}
