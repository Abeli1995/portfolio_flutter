import 'package:flutter/widgets.dart';

typedef LocalizedText = Map<String, String>;

String localizedValue(LocalizedText value, Locale locale) {
  if (value.isEmpty) {
    return '';
  }

  final code = locale.languageCode;
  return value[code] ?? value['en'] ?? value.values.first;
}

class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.skills,
    required this.projects,
    required this.contactMessage,
  });

  final Profile profile;
  final List<String> skills;
  final List<ProjectItem> projects;
  final LocalizedText contactMessage;

  factory PortfolioContent.fromJson(Map<String, dynamic> json) {
    final profileJson = _asMap(json['profile']);
    final projectList = _asList(json['projects']);

    return PortfolioContent(
      profile: Profile.fromJson(profileJson),
      skills: _asList(json['skills'])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(growable: false),
      projects: projectList
          .map((item) => ProjectItem.fromJson(_asMap(item)))
          .toList(growable: false),
      contactMessage: _asLocalizedText(
        json['contactMessage'],
        fallback: 'Open for collaboration.',
      ),
    );
  }
}

class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.summary,
    required this.about,
    required this.location,
    required this.email,
    required this.links,
  });

  final String name;
  final LocalizedText role;
  final LocalizedText summary;
  final LocalizedText about;
  final String location;
  final String email;
  final Map<String, String> links;

  factory Profile.fromJson(Map<String, dynamic> json) {
    final linksJson = _asMap(json['links']);
    return Profile(
      name: _asString(json['name'], fallback: 'Your Name'),
      role: _asLocalizedText(json['role'], fallback: 'Flutter Developer'),
      summary: _asLocalizedText(
        json['summary'],
        fallback: 'Building practical apps with Flutter.',
      ),
      about: _asLocalizedText(
        json['about'],
        fallback: 'I like clean architecture and performance-focused UI.',
      ),
      location: _asString(json['location'], fallback: 'Unknown'),
      email: _asString(json['email'], fallback: ''),
      links: linksJson.map((key, value) => MapEntry(key, _asString(value))),
    );
  }
}

class ProjectItem {
  const ProjectItem({
    required this.title,
    required this.description,
    required this.stack,
    required this.responsibilities,
    required this.url,
  });

  final LocalizedText title;
  final LocalizedText description;
  final List<String> stack;
  final List<LocalizedText> responsibilities;
  final String url;

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: _asLocalizedText(json['title'], fallback: 'Untitled project'),
      description: _asLocalizedText(
        json['description'],
        fallback: 'No description.',
      ),
      stack: _asList(json['stack']).map((item) => item.toString()).toList(),
      responsibilities: _asLocalizedTextList(json['responsibilities']),
      url: _asString(json['url']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry('$key', value));
  }
  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) {
    return value;
  }
  return const [];
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }
  final converted = value.toString().trim();
  return converted.isEmpty ? fallback : converted;
}

LocalizedText _asLocalizedText(dynamic value, {required String fallback}) {
  if (value is String) {
    final text = value.trim().isEmpty ? fallback : value.trim();
    return {'ru': text, 'en': text};
  }

  if (value is Map) {
    final mapped = <String, String>{};
    value.forEach((key, value) {
      mapped['$key'] = _asString(value);
    });
    mapped.removeWhere((key, value) => value.isEmpty);

    if (mapped.isEmpty) {
      return {'ru': fallback, 'en': fallback};
    }

    final first = mapped.values.first;
    mapped.putIfAbsent('en', () => first);
    mapped.putIfAbsent('ru', () => mapped['en']!);
    return mapped;
  }

  return {'ru': fallback, 'en': fallback};
}

List<LocalizedText> _asLocalizedTextList(dynamic value) {
  if (value is! List) {
    return const [];
  }

  final result = <LocalizedText>[];
  for (final item in value) {
    final text = _asLocalizedText(item, fallback: '');
    final normalized = <String, String>{};
    text.forEach((key, value) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        normalized[key] = trimmed;
      }
    });
    if (normalized.isNotEmpty) {
      normalized.putIfAbsent('en', () => normalized.values.first);
      normalized.putIfAbsent('ru', () => normalized['en']!);
      result.add(normalized);
    }
  }

  return result;
}
