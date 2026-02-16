class AppConfig {
  static const String appName = 'Zentra';
  static const String exchangeRatesSource =
      'https://ve.dolarapi.com/v1/dolares';
  static const int exchangeRatesUpdateMinutes = 10;
  static const String aiEndpoint =
      'https://us-central1-zentra-hub.cloudfunctions.net/chat';
}
