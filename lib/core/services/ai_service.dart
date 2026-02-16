import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../config/platform_info.dart';

class AiService {
  AiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> chat({required String message, String? locale}) async {
    final uri = _resolveEndpoint(AppConfig.aiEndpoint);
    final payload = {'message': message, 'locale': locale ?? 'es'};

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['reply'] is String) {
          return decoded['reply'] as String;
        }
      }
    } catch (_) {
      // Ignore failures and return a safe response.
    }

    return 'AI service is not configured yet.';
  }

  Uri _resolveEndpoint(String endpoint) {
    if (kIsWeb) {
      return Uri.parse(endpoint);
    }

    final uri = Uri.parse(endpoint);
    if (isAndroid && uri.host == 'localhost') {
      return uri.replace(host: '10.0.2.2');
    }
    return uri;
  }
}
