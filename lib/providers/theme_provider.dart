// providers/theme_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod

class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() => false; 

  void toggle(bool isDark) => state = isDark;
}
