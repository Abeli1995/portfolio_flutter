# Portfolio Flutter (Web)

Сайт-визитка портфолио на Flutter Web с:
- двумя языками (`ru` и `en`);
- контентом из JSON;
- деплоем через GitHub Actions в GitHub Pages.

## Структура данных

Основной JSON:
- `content/portfolio_content.json` (источник для GitHub Actions и прод-сайта)
- `assets/data/portfolio_content.json` (fallback для локального запуска)

## Локальный запуск

```bash
flutter pub get
flutter run -d chrome
```

Локальный fallback всегда берется из `assets/data/portfolio_content.json`.

Если хотите протестировать загрузку данных с удаленного URL:

```bash
flutter run -d chrome --dart-define=PORTFOLIO_DATA_URL=https://raw.githubusercontent.com/<user>/<repo>/main/content/portfolio_content.json
```

## GitHub Actions

### 1) Deploy Flutter Web

Файл: `.github/workflows/deploy_web.yml`

Что делает:
- запускается на `push` в `main` или вручную;
- собирает `flutter build web`;
- публикует сайт в GitHub Pages;
- передает `PORTFOLIO_DATA_URL` на raw JSON в репозитории.

### 2) Update Portfolio Content

Файл: `.github/workflows/update_content.yml`

Что делает:
- запускается вручную (`workflow_dispatch`);
- принимает полный JSON в input `content_json`;
- валидирует JSON через `jq`;
- обновляет `content/portfolio_content.json` и `assets/data/portfolio_content.json`;
- делает коммит и пуш.

## Что поменять под себя

1. В `content/portfolio_content.json`:
- имя, описание, проекты, контакты, ссылки.
2. В `.github/workflows/deploy_web.yml`:
- при необходимости `--base-href`.
3. Включить GitHub Pages:
- Repository Settings -> Pages -> Source: GitHub Actions.
