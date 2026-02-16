import 'package:drift/drift.dart';

import '../local/app_database.dart';

class FinanceRepository {
  FinanceRepository(this._db);

  final AppDatabase _db;

  Stream<List<Account>> watchAccounts() {
    return (_db.select(_db.accounts)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<void> upsertAccount(AccountsCompanion account) {
    return _db.into(_db.accounts).insertOnConflictUpdate(account);
  }

  Stream<List<Category>> watchCategories({String? type}) {
    final query = _db.select(_db.categories);
    if (type != null) {
      query.where((tbl) => tbl.type.equals(type));
    }
    return query.watch();
  }

  Future<void> upsertCategory(CategoriesCompanion category) {
    return _db.into(_db.categories).insertOnConflictUpdate(category);
  }

  Stream<List<Transaction>> watchTransactions() {
    return (_db.select(_db.transactions)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<void> upsertTransaction(TransactionsCompanion transaction) {
    return _db.into(_db.transactions).insertOnConflictUpdate(transaction);
  }

  Stream<List<Budget>> watchBudgets() {
    return _db.select(_db.budgets).watch();
  }

  Future<void> upsertBudget(BudgetsCompanion budget) {
    return _db.into(_db.budgets).insertOnConflictUpdate(budget);
  }

  Stream<List<DebtsLoan>> watchDebtsLoans() {
    return _db.select(_db.debtsLoans).watch();
  }

  Future<void> upsertDebtLoan(DebtsLoansCompanion debtLoan) {
    return _db.into(_db.debtsLoans).insertOnConflictUpdate(debtLoan);
  }

  Stream<List<SavingsGoal>> watchSavingsGoals() {
    return _db.select(_db.savingsGoals).watch();
  }

  Future<void> upsertSavingsGoal(SavingsGoalsCompanion goal) {
    return _db.into(_db.savingsGoals).insertOnConflictUpdate(goal);
  }

  Stream<List<RecurringRule>> watchRecurringRules() {
    return _db.select(_db.recurringRules).watch();
  }

  Future<void> upsertRecurringRule(RecurringRulesCompanion rule) {
    return _db.into(_db.recurringRules).insertOnConflictUpdate(rule);
  }

  Stream<List<ExchangeRate>> watchExchangeRates() {
    return _db.select(_db.exchangeRates).watch();
  }

  Future<void> upsertExchangeRate(ExchangeRatesCompanion rate) {
    return _db.into(_db.exchangeRates).insertOnConflictUpdate(rate);
  }

  Future<ExchangeRate?> getExchangeRate(String id) {
    return (_db.select(
      _db.exchangeRates,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}
