import '../data/repositories/finance_repository.dart';
import '../domain/currency.dart';

class CurrencyService {
  CurrencyService(this._repository);

  final FinanceRepository _repository;

  Future<double> convert({
    required double amount,
    required CurrencyCode from,
    required CurrencyCode to,
  }) async {
    if (from == to) {
      return _normalize(amount);
    }

    final rate = await _repository.getExchangeRate('default');
    if (rate == null || rate.bcvUsdVes == 0 || rate.binanceUsdtVes == 0) {
      return _normalize(amount);
    }

    double inVes;
    switch (from) {
      case CurrencyCode.ves:
        inVes = amount;
        break;
      case CurrencyCode.usd:
        inVes = amount * rate.bcvUsdVes;
        break;
      case CurrencyCode.usdt:
        inVes = amount * rate.binanceUsdtVes;
        break;
    }

    double result;
    switch (to) {
      case CurrencyCode.ves:
        result = inVes;
        break;
      case CurrencyCode.usd:
        result = inVes / rate.bcvUsdVes;
        break;
      case CurrencyCode.usdt:
        result = inVes / rate.binanceUsdtVes;
        break;
    }

    return _normalize(result);
  }

  double _normalize(double value) => double.parse(value.toStringAsFixed(6));
}
