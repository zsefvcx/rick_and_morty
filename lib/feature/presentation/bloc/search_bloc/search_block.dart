import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_peson.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const unexpectedErrorMessage = 'Unexpected Error';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  int page = 1;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmty()) {
    on<SearchPersons>(
      (event, emit) async {
        if (state is PersonSearchLoading) return;

        var oldPerson = <PersonEntity>[];

        final currentState = state;

        if (currentState is PersonSearchLoaded) {
          oldPerson = currentState.persons;
        }

        emit(PersonSearchLoading(
          oldPersonsList: oldPerson,
          isFirstFetch: page == 1,
        ));
        final failureOrPerson = await searchPerson(
            params: SearchPersonParams(
          query: event.personQuery,
          page: page,
        ));
        final character = failureOrPerson.$2;
        final failure = failureOrPerson.$1;
        if (failure != null) {
          emit(PersonSearchError(massage: _mapFailureToMassage(failure)));
        } else if (character != null) {
          page++;
          final persons = (state as PersonSearchLoading).oldPersonsList;
          persons.addAll(character);
          emit(PersonSearchLoaded(persons: persons));
        } else {
          throw Exception(unexpectedErrorMessage);
        }
      },
    );
  }

  String _mapFailureToMassage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return serverFailureMessage;
      case CacheFailure _:
        return cacheFailureMessage;
      default:
        return unexpectedErrorMessage;
    }
  }
}
