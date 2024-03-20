import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_card.dart';

class PersonsList extends StatelessWidget {
  PersonsList({super.key});

  final scrollController = ScrollController();

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          //BlocProvider.of<PersonListCubit>(const).loadPerson();
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        var persons = <PersonEntity>[];
        bool isLoading = false;

        switch (state) {
          case PersonLoading state:
            if(state.isFirstFetch){
              return const _LoadingIndicator();
            }
            persons = state.oldPersonsList;
            isLoading = true;
          case PersonLoaded state:
            persons = state.personsList;
          case PersonEmpty _:
            return Container();
          case PersonError state:
            return Text(
              state.message,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            );
        }

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < persons.length) {
              return PersonCard(person: persons[index]);
            } else {
              Timer(
                const Duration(milliseconds: 30),
                () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                },
              );
              return const _LoadingIndicator();
            }
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[400],
          ),
          itemCount: persons.length + (isLoading ? 1 : 0),
        );
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

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
