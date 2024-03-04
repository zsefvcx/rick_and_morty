import 'package:equatable/equatable.dart';

abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();
}

class SearchPersons extends PersonSearchEvent {
  final String personQuery;

  const SearchPersons({required this.personQuery});

  @override
  List<Object?> get props => [personQuery];
}
