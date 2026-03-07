import 'package:flutter/material.dart';

import '../l10n/app_text.dart';
import '../models/portfolio_content.dart';

class ProjectDetailsDialog extends StatelessWidget {
  const ProjectDetailsDialog({
    super.key,
    required this.project,
    required this.locale,
  });

  final ProjectItem project;
  final Locale locale;

  static Future<void> show({
    required BuildContext context,
    required ProjectItem project,
    required Locale locale,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) =>
          ProjectDetailsDialog(project: project, locale: locale),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsibilities = project.responsibilities
        .map((item) => localizedValue(item, locale))
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);

    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      title: Text(localizedValue(project.title, locale)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (responsibilities.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                tr(locale, 'responsibilities'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...responsibilities.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•', style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(locale, 'close')),
        ),
      ],
    );
  }
}
