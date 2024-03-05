import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_peson.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const unexpectedErrorMessage = 'Unexpected Error';

class PersonSeachBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSeachBloc({required this.searchPerson}) : super(PersonEmty());

  Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
    if (event is SearchPersons) {
      yield* _mapFetchPersonsToState(event.personQuery);
    }
  }

  Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
    yield PersonSearchLoading();

    final failureOrPerson =
        await searchPerson(params: SearchPersonParams(query: personQuery));
    final persons = failureOrPerson.$2;
    final failure = failureOrPerson.$1;
    yield failure != null
        ? PersonSearchError(massage: _mapFailureToMassage(failure))
        : persons != null
            ? PersonSearchLoaded(persons: persons)
            : throw Exception(unexpectedErrorMessage);
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
