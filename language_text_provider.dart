/* ****************************************************************************
 * Copyright (c) 2021 flognity
 * This code was written by flognity (Florian Wilhelm)
 * If distributed, this comment shall be included in all copies the Software.
 *
 * This comment includes instructions on how to use the Language Text Provider.
 *
 * Please read before using it.
 * ----------------------------------------------------------------------------
 * For the LanguageTextProvider to work, please include the
 * flutter_localizations in your pubspec.yaml file:
 *
 * flutter_localizations:
 *   sdk: flutter
 * ----------------------------------------------------------------------------
 * Example code for the implementation of BaseTextProvider that should be
 * located in '../../lang/text_provider.dart' is given here:
 * ----------------------------------------------------------------------------
 * class TextProvider implements BaseTextProvider {
 *   static const List<String> _supportedLanguages = ['en', 'de'];
 *   static const Map<String, Map<String, String>> _textProviderValues =
 *   <String, Map<String, String>>{
 *     'title': {
 *       'en': 'This is a title in English.',
 *       'de': 'Das ist ein Titel auf Deutsch.',
 *     },
 *     'subtitle': {
 *       'en': 'This is an English Subtitle.',
 *      'de': 'Dies ist ein deutscher Untertitel.',
 *     },
 *   };
 *   TextProvider();
 *
 *   @override
 *   UnmodifiableListView<String> get getSupportedLanguages =>
 *       UnmodifiableListView(_supportedLanguages);
 *
 *   @override
 *   UnmodifiableMapView<String, Map<String, String>> get getTextProviderValues =>
 *       UnmodifiableMapView(_textProviderValues);
 * }
***************************************************************************** */
import 'dart:collection';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

import '../../lang/text_provider.dart'; //This import must implement the abstract class BaseTextProvider

///abstract base class that should be implemented by a TextProvider class
abstract class BaseTextProvider {
  static const List<String> _supportedLanguages = [];
  static const Map<String, Map<String, String>> _textProviderValues =
      <String, Map<String, String>>{};

  UnmodifiableListView<String> get getSupportedLanguages =>
      UnmodifiableListView(_supportedLanguages);
  UnmodifiableMapView<String, Map<String, String>> get getTextProviderValues =>
      UnmodifiableMapView(_textProviderValues);
}

///This is a base class
class LanguageTextProvider {
  final Locale locale;

  ///TextProvider must be be implemented in '../../lang/text_provider.dart'.
  ///TextProvider is the implementation of BaseTextProvider
  static final textProvider = TextProvider();

  final UnmodifiableMapView<String, Map<String, String>> _languageMap =
      textProvider.getTextProviderValues;

  LanguageTextProvider(this.locale);

  //allow access to the delegate from the MaterialApp
  static const LocalizationsDelegate<LanguageTextProvider> delegate =
      _LanguageTextProviderDelegate();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static LanguageTextProvider of(BuildContext context) {
    return Localizations.of<LanguageTextProvider>(
        context, LanguageTextProvider)!;
  }

  static List<String> languages() => textProvider.getSupportedLanguages;

  static final String _defaultLanguage = languages().first;

  String getText(String stringId) {
    if (_languageMap[stringId] != null) {
      //entry for stringId exist. Check for desired language
      if (_languageMap[stringId]![locale.languageCode] != null) {
        //desired language entry exist
        return _languageMap[stringId]![locale.languageCode]!;
      } else {
        //desired language entry does not exist. Return the default language
        return _languageMap[stringId]![_defaultLanguage]!;
      }
    } else {
      return 'stringID [$stringId] not found';
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _LanguageTextProviderDelegate
    extends LocalizationsDelegate<LanguageTextProvider> {
  const _LanguageTextProviderDelegate();

  @override
  bool isSupported(Locale locale) =>
      LanguageTextProvider.languages().contains(locale.languageCode);

  @override
  Future<LanguageTextProvider> load(Locale locale) {
    // Returning a SynchronousFuture our load is static
    return SynchronousFuture<LanguageTextProvider>(
        LanguageTextProvider(locale));
  }

  @override
  bool shouldReload(_LanguageTextProviderDelegate old) => false;
}
