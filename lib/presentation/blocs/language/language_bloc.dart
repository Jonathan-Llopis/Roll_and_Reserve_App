import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_event.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageBloc(this.sharedPreferences)
      : super(LanguageState(const Locale('es'))) {
    on<ChangeLanguageEvent>((event, emit) async {
      final code = event.locale.countryCode != null
          ? '${event.locale.languageCode}_${event.locale.countryCode}'
          : event.locale.languageCode;
      await sharedPreferences.setString('locale', code);
      emit(LanguageState(event.locale));
    });

    on<GetLocaleEvent>((event, emit) async {
      final localeString = sharedPreferences.getString('locale');
      if (localeString != null && localeString.isNotEmpty) {
        final parts = localeString.split('_');
        final countryCode =
            parts.length > 1 && parts[1] != 'null' ? parts[1] : null;
        emit(LanguageState(Locale(parts[0], countryCode)));
      } else {
        emit(LanguageState(const Locale('es')));
      }
    });
  }
}
