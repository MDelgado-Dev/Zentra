import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/data/local/app_database.dart';

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final repo = ref.read(financeRepositoryProvider);
  return repo.watchTransactions();
});
