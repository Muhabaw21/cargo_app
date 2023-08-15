import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'localization_event.dart';
import 'localization_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(Locale('en'))) {
    on<ChangeLocale>((event, emit) {
      emit(LocaleState(event.locale));
    });
  }
}
