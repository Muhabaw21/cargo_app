import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateTo extends NavigationEvent {
  final String routeName;

  NavigateTo(this.routeName);

  @override
  List<Object> get props => [routeName];
}

class NavigationState extends Equatable {
  final String routeName;

  const NavigationState(this.routeName);

  @override
  List<Object> get props => [routeName];
}
