import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get iconPath => text().nullable()();
  TextColumn get defaultCurrency => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get accountId => text()();
  TextColumn get destinationAccountId => text().nullable()();
  TextColumn get categoryId => text()();
  IntColumn get date => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringRuleId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get color => text()();
  TextColumn get icon => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  RealColumn get monthlyLimit => real()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DebtsLoans extends Table {
  TextColumn get id => text()();
  TextColumn get personName => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get type => text()();
  IntColumn get dueDate => integer().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real()();
  TextColumn get currency => text()();
  IntColumn get deadline => integer().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecurringRules extends Table {
  TextColumn get id => text()();
  TextColumn get frequency => text()();
  IntColumn get intervalValue => integer()();
  TextColumn get specificDays => text().withDefault(const Constant('[]'))();
  IntColumn get maxOccurrences => integer().nullable()();
  IntColumn get endDate => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ExchangeRates extends Table {
  TextColumn get id => text()();
  RealColumn get bcvUsdVes => real()();
  RealColumn get binanceUsdtVes => real()();
  IntColumn get lastBcvUpdate => integer()();
  IntColumn get lastBinanceUpdate => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Accounts,
    Transactions,
    Categories,
    Budgets,
    DebtsLoans,
    SavingsGoals,
    RecurringRules,
    ExchangeRates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedDefaults();
    },
  );

  Future<void> _seedDefaults() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await into(accounts).insertOnConflictUpdate(
      AccountsCompanion.insert(
        id: 'default',
        name: 'Main account',
        iconPath: const Value(null),
        defaultCurrency: 'VES',
        createdAt: now,
        updatedAt: now,
        isDeleted: const Value(false),
      ),
    );
    await into(categories).insertOnConflictUpdate(
      CategoriesCompanion.insert(
        id: 'uncategorized',
        name: 'Uncategorized',
        type: 'expense',
        color: '#8C8C8C',
        icon: 'question',
      ),
    );
    await into(exchangeRates).insertOnConflictUpdate(
      ExchangeRatesCompanion.insert(
        id: 'default',
        bcvUsdVes: 0,
        binanceUsdtVes: 0,
        lastBcvUpdate: now,
        lastBinanceUpdate: now,
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'zentra.sqlite'));
    return NativeDatabase(file, logStatements: false);
  });
}
