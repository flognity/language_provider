# language_provider
Language Provider for flutter applications

## How to install
This repository is meant to be a included as a submodule of flutter apps. Just navigate to your lib directory and add the submodule where you would like. E.g.
```
cd lib
cd util
git submodule add https://github.com/flognity/language_provider.git
git submodule update --init --recursive
```

For the LanguageTextProvider to work, please include the `flutter_localizations` package in your pubspec.yaml file:
```
  flutter_localizations:
    sdk: flutter
```
## Example
An example code for the implementation of BaseTextProvider that should be located in `../../lang/text_provider.dart` is given here:
```
class TextProvider implements BaseTextProvider {
  static const List<String> _supportedLanguages = ['en', 'de'];
  static const Map<String, Map<String, String>> _textProviderValues =
  <String, Map<String, String>>{
    'title': {
      'en': 'This is a title in English.',
      'de': 'Das ist ein Titel auf Deutsch.',
    },
    'subtitle': {
      'en': 'This is an English Subtitle.',
     'de': 'Dies ist ein deutscher Untertitel.',
    },
  };
  TextProvider();
  @override
  UnmodifiableListView<String> get getSupportedLanguages =>
      UnmodifiableListView(_supportedLanguages);
  @override
  UnmodifiableMapView<String, Map<String, String>> get getTextProviderValues =>
      UnmodifiableMapView(_textProviderValues);
}
```