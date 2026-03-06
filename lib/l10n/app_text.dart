import 'package:flutter/widgets.dart';

const Map<String, Map<String, String>> _texts = {
  'loading_title': {
    'ru': 'Загружаю портфолио...',
    'en': 'Loading portfolio...',
  },
  'loading_subtitle': {
    'ru': 'Пробую взять свежие данные из GitHub.',
    'en': 'Trying to fetch the latest data from GitHub.',
  },
  'error_title': {
    'ru': 'Не удалось загрузить данные',
    'en': 'Failed to load data',
  },
  'error_body': {
    'ru': 'Проверь JSON и ссылку PORTFOLIO_DATA_URL.',
    'en': 'Check your JSON and PORTFOLIO_DATA_URL.',
  },
  'retry': {'ru': 'Повторить', 'en': 'Retry'},
  'about': {'ru': 'Обо мне', 'en': 'About me'},
  'skills': {'ru': 'Навыки', 'en': 'Skills'},
  'projects': {'ru': 'Проекты', 'en': 'Projects'},
  'contacts': {'ru': 'Контакты', 'en': 'Contacts'},
  'location': {'ru': 'Город', 'en': 'Location'},
  'email': {'ru': 'Почта', 'en': 'Email'},
  'tech_stack': {'ru': 'Стек', 'en': 'Stack'},
  'open_project': {'ru': 'Открыть проект', 'en': 'Open project'},
  'open_link': {'ru': 'Открыть', 'en': 'Open'},
  'language': {'ru': 'Язык', 'en': 'Language'},
  'theme': {'ru': 'Тема', 'en': 'Theme'},
  'copied_email': {
    'ru': 'Email скопирован в буфер обмена',
    'en': 'Email copied to clipboard',
  },
  'cant_open_link': {
    'ru': 'Не удалось открыть ссылку',
    'en': 'Could not open link',
  },
  'updated_from_remote': {
    'ru': 'Источник данных: GitHub JSON',
    'en': 'Data source: GitHub JSON',
  },
};

String tr(Locale locale, String key) {
  final item = _texts[key];
  if (item == null || item.isEmpty) {
    return key;
  }

  final code = locale.languageCode;
  return item[code] ?? item['en'] ?? item.values.first;
}
