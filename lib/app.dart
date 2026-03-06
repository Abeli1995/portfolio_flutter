import 'package:flutter/material.dart';

import 'l10n/app_text.dart';
import 'models/portfolio_content.dart';
import 'services/portfolio_repository.dart';
import 'widgets/portfolio_page.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final PortfolioRepository _repository = PortfolioRepository();
  late Future<PortfolioContent> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _repository.loadContent();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  void _reloadContent() {
    setState(() {
      _contentFuture = _repository.loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioContent>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _LoadingScreen(locale: widget.locale);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _ErrorScreen(
            locale: widget.locale,
            error: snapshot.error,
            onRetry: _reloadContent,
          );
        }

        return PortfolioPage(
          content: snapshot.data!,
          locale: widget.locale,
          onLocaleChanged: widget.onLocaleChanged,
          themeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 14),
            Text(tr(locale, 'loading_title')),
            const SizedBox(height: 6),
            Text(
              tr(locale, 'loading_subtitle'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.locale, required this.onRetry, this.error});

  final Locale locale;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(locale, 'error_title'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(tr(locale, 'error_body'), textAlign: TextAlign.center),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onRetry,
                  child: Text(tr(locale, 'retry')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
