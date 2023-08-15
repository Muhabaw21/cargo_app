import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigatestateEvent.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState('/login')) {
    on<NavigateTo>((event, emit) {
      emit(NavigationState(event.routeName));
    });
  }
}

