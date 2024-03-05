import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const unexpectedErrorMessage = 'Unexpected Error';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentStyate = state;

    var oldPerson = <PersonEntity>[];

    if (currentStyate is PersonLoaded) {
      oldPerson = currentStyate.personsList;
    }

    emit(PersonLoading(oldPersonsList: oldPerson, isFirstFetch: page == 1));

    final failureOrPerson =
        await getAllPersons(params: PagePersonParams(page: page));
    final character = failureOrPerson.$2;
    final failure = failureOrPerson.$1;
    if (failure != null) {
      emit(PersonError(message: _mapFailureToMassage(failure)));
    } else if (character != null) {
      page++;
      final persons = (state as PersonLoading).oldPersonsList;
      persons.addAll(character);
      emit(PersonLoaded(personsList: persons));
    } else {
      throw Exception(unexpectedErrorMessage);
    }
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
