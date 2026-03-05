import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/portfolio_content.dart';

class PortfolioRepository {
  PortfolioRepository({
    http.Client? client,
    AssetBundle? assetBundle,
    String? remoteUrl,
  }) : _client = client ?? http.Client(),
       _assetBundle = assetBundle ?? rootBundle,
       _remoteUrl =
           (remoteUrl ?? const String.fromEnvironment('PORTFOLIO_DATA_URL'))
               .trim();

  final http.Client _client;
  final AssetBundle _assetBundle;
  final String _remoteUrl;

  Future<PortfolioContent> loadContent() async {
    if (_remoteUrl.isNotEmpty) {
      try {
        final remote = await _loadFromRemote(_remoteUrl);
        if (remote != null) {
          return remote;
        }
      } catch (_) {
        // Ignore remote errors and fall back to local asset.
      }
    }

    final localRaw = await _assetBundle.loadString(
      'assets/data/portfolio_content.json',
    );
    final decoded = jsonDecode(localRaw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Portfolio JSON root must be an object.');
    }
    return PortfolioContent.fromJson(decoded);
  }

  void dispose() => _client.close();

  Future<PortfolioContent?> _loadFromRemote(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return PortfolioContent.fromJson(decoded);
  }
}
