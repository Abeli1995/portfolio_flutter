import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter/models/portfolio_content.dart';

void main() {
  test('localizedValue uses requested locale and fallback', () {
    const value = {'ru': 'Привет', 'en': 'Hello'};

    expect(localizedValue(value, const Locale('ru')), 'Привет');
    expect(localizedValue(value, const Locale('en')), 'Hello');
    expect(localizedValue(const {'en': 'Hello'}, const Locale('ru')), 'Hello');
  });
}
