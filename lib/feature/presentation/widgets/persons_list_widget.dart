import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_card.dart';

class PersonsList extends StatelessWidget {
  const PersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (BuildContext context, PersonState state) {
        var persons = <PersonEntity>[];
        if (state is PersonLoading && state.isFirstFetch) {
          return const _LoadingIndicator();
        } else if (state is PersonLoaded) {
          persons = state.personsList;
        }
        return ListView.separated(
          itemBuilder: (context, index) => PersonCard(person: persons[index]),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[400],
          ),
          itemCount: persons.length,
        );
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
