import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty/feature/domain/use_cases/search_person.dart';
import 'package:rick_and_morty/core/error/failure.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({
    required this.searchPerson,
  }) : super(PersonEmpty()) {
    on<PersonSearchEvent>((event, emit) {
      if (event is SearchPersons) {
        _onSearchPerson(event, emit);
      }
    });
  }

  Future<void> _onSearchPerson(
    SearchPersons event,
    Emitter<PersonSearchState> emit,
  ) async {
    emit(PersonSearchLoading());
    final failureOrPerson = await searchPerson(
      SearchPersonParams(query: event.personQuery),
    );
    final newState = failureOrPerson.fold(
      (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
      (person) => PersonSearchLoaded(persons: person),
    );
    emit(newState);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
