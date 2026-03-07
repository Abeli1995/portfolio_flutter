import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_text.dart';
import '../models/portfolio_content.dart';
import 'project_details_dialog.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({
    super.key,
    required this.content,
    required this.locale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final PortfolioContent content;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 900;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF0B1120),
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ]
                : const [
                    Color(0xFFE6FFFA),
                    Color(0xFFF8FAFC),
                    Color(0xFFFFF7ED),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: _TopBar(
                  locale: locale,
                  onLocaleChanged: onLocaleChanged,
                  themeMode: themeMode,
                  onThemeModeChanged: onThemeModeChanged,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroCard(
                        content: content,
                        locale: locale,
                        onTapTelegram: () => _openExternal(
                          context,
                          content.profile.links['Telegram'] ??
                              content.profile.links['telegram'] ??
                              '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (compact)
                        Column(
                          children: [
                            // Обо мне
                            _AboutCard(
                              text: localizedValue(
                                content.profile.about,
                                locale,
                              ),
                              locale: locale,
                            ),
                            const SizedBox(height: 16),
                            // Навыки
                            _SkillsCard(skills: content.skills, locale: locale),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _AboutCard(
                                text: localizedValue(
                                  content.profile.about,
                                  locale,
                                ),
                                locale: locale,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SkillsCard(
                                skills: content.skills,
                                locale: locale,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      // Проекты
                      _ProjectsCard(
                        projects: content.projects,
                        locale: locale,
                        onOpenProject: (url) => _openExternal(context, url),
                      ),
                      const SizedBox(height: 16),
                      _ContactsCard(
                        locale: locale,
                        content: content,
                        onTapEmail: () => _copyEmail(context),
                        onOpenLink: (url) => _openExternal(context, url),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content.profile.email));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr(locale, 'copied_email'))));
    }
  }

  Future<void> _openExternal(BuildContext context, String rawUrl) async {
    final preparedUrl =
        rawUrl.startsWith('http://') || rawUrl.startsWith('https://')
        ? rawUrl
        : 'https://$rawUrl';
    final uri = Uri.tryParse(preparedUrl);
    if (uri == null) {
      return;
    }

    final ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr(locale, 'cant_open_link'))));
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
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
  Widget build(BuildContext context) {
    final resolvedThemeMode = themeMode == ThemeMode.system
        ? (Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light)
        : themeMode;

    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/my_photo.png',
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr(locale, 'language'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<String>(value: 'ru', label: Text('RU')),
                      ButtonSegment<String>(value: 'en', label: Text('EN')),
                    ],
                    selected: <String>{locale.languageCode},
                    onSelectionChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      onLocaleChanged(Locale(value.first));
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr(locale, 'theme'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: <ThemeMode>{resolvedThemeMode},
                    onSelectionChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      onThemeModeChanged(value.first);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.content,
    required this.locale,
    required this.onTapTelegram,
  });

  final PortfolioContent content;
  final Locale locale;
  final VoidCallback onTapTelegram;

  @override
  Widget build(BuildContext context) {
    final telegramUrl =
        content.profile.links['Telegram'] ??
        content.profile.links['telegram'] ??
        '';

    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizedValue(content.profile.role, locale),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content.profile.name,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizedValue(content.profile.summary, locale),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _MetaChip(
                  icon: Icons.location_on_outlined,
                  label:
                      '${tr(locale, 'location')}: ${content.profile.location}',
                ),
                if (telegramUrl.isNotEmpty)
                  _MetaChip(
                    icon: Icons.open_in_new,
                    label: 'Telegram',
                    onTap: onTapTelegram,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.text, required this.locale});

  final String text;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(locale, 'about'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.skills, required this.locale});

  final List<String> skills;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(locale, 'skills'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      side: BorderSide.none,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

/// Карточка с проектами
class _ProjectsCard extends StatelessWidget {
  const _ProjectsCard({
    required this.projects,
    required this.locale,
    required this.onOpenProject,
  });

  final List<ProjectItem> projects;
  final Locale locale;
  final ValueChanged<String> onOpenProject;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(locale, 'projects'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: projects
                  .map(
                    (project) => SizedBox(
                      width: 320,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizedValue(project.title, locale),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localizedValue(project.description, locale),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tr(locale, 'tech_stack'),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: project.stack
                                    .map(
                                      (tech) => Chip(
                                        label: Text(tech),
                                        side: BorderSide.none,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                              const SizedBox(height: 12),
                              Builder(
                                builder: (context) {
                                  final hasUrl = project.url.trim().isNotEmpty;
                                  final hasResponsibilities =
                                      project.responsibilities.isNotEmpty;
                                  if (!hasUrl && !hasResponsibilities) {
                                    return const SizedBox.shrink();
                                  }

                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (hasResponsibilities)
                                        FilledButton.icon(
                                          onPressed: () =>
                                              ProjectDetailsDialog.show(
                                                context: context,
                                                project: project,
                                                locale: locale,
                                              ),
                                          icon: const Icon(Icons.info_outline),
                                          label: Text(
                                            tr(locale, 'project_details'),
                                          ),
                                        ),
                                      if (hasUrl)
                                        FilledButton.tonalIcon(
                                          onPressed: () =>
                                              onOpenProject(project.url),
                                          icon: const Icon(Icons.open_in_new),
                                          label: Text(
                                            tr(locale, 'open_project'),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactsCard extends StatelessWidget {
  const _ContactsCard({
    required this.locale,
    required this.content,
    required this.onTapEmail,
    required this.onOpenLink,
  });

  final Locale locale;
  final PortfolioContent content;
  final VoidCallback onTapEmail;
  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(locale, 'contacts'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              localizedValue(content.contactMessage, locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onTapEmail,
                  icon: const Icon(Icons.mail_outline),
                  label: Text(content.profile.email),
                ),
                ...content.profile.links.entries.map(
                  (entry) => OutlinedButton.icon(
                    onPressed: () => onOpenLink(entry.value),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(entry.key),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      side: BorderSide.none,
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colorScheme.surface.withValues(alpha: isDark ? 0.75 : 0.9),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.45 : 0.6,
          ),
        ),
      ),
      child: child,
    );
  }
}
