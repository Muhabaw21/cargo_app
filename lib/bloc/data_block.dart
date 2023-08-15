import 'package:bloc/bloc.dart';

import '../data/repositories/data_repository.dart';
import '../model/cargo.dart';
class DataState {}

class DataInitial extends DataState {}

class DataLoaded extends DataState {
  final List<Cargo> data;

  DataLoaded(this.data);
}

class DataError extends DataState {
  final String message;

  DataError(this.message);
}

class DataEvent {}

class FetchDataEvent extends DataEvent {
    final Cargo cargo;

  FetchDataEvent(this.cargo);
}

class PostCargoEvent extends DataEvent {
  final Cargo cargo;

  PostCargoEvent(this.cargo);
}

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository _dataRepository = DataRepository();

  DataBloc() : super(DataInitial());

  List<Cargo> _currentData = [];

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is FetchDataEvent) {
      yield DataInitial();
      try {
        final List<Cargo> data = await _dataRepository.postCargo(event.cargo);
        yield DataLoaded(data);
      } catch (e) {
        yield DataError('Failed to fetch data');
      }
    } else if (event is PostCargoEvent) {
      yield DataInitial();
      try {
        final List<Cargo> updatedData = await _dataRepository.postCargo(event.cargo);
        yield DataLoaded(updatedData);
      } catch (e) {
        yield DataError('Failed to post cargo');
      }
    }
  }
}
