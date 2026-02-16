enum CurrencyCode { ves, usd, usdt }

enum TransactionType { income, expense, transfer }

String currencyCodeToString(CurrencyCode code) {
  switch (code) {
    case CurrencyCode.ves:
      return 'VES';
    case CurrencyCode.usd:
      return 'USD';
    case CurrencyCode.usdt:
      return 'USDT';
  }
}

CurrencyCode currencyCodeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'USD':
      return CurrencyCode.usd;
    case 'USDT':
      return CurrencyCode.usdt;
    case 'VES':
    default:
      return CurrencyCode.ves;
  }
}

String transactionTypeToString(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return 'income';
    case TransactionType.expense:
      return 'expense';
    case TransactionType.transfer:
      return 'transfer';
  }
}

TransactionType transactionTypeFromString(String value) {
  switch (value.toLowerCase()) {
    case 'income':
      return TransactionType.income;
    case 'transfer':
      return TransactionType.transfer;
    case 'expense':
    default:
      return TransactionType.expense;
  }
}
