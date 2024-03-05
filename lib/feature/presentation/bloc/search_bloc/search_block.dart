import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_peson.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const unexpectedErrorMessage = 'Unexpected Error';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmty()) {
    on<SearchPersons>(
      (event, emit) async {
        emit(PersonSearchLoading());
        final failureOrPerson = await searchPerson(
            params: SearchPersonParams(query: event.personQuery));
        final persons = failureOrPerson.$2;
        final failure = failureOrPerson.$1;
        failure != null
            ? emit(PersonSearchError(massage: _mapFailureToMassage(failure)))
            : persons != null
                ? emit(PersonSearchLoaded(persons: persons))
                : throw Exception(unexpectedErrorMessage);
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
