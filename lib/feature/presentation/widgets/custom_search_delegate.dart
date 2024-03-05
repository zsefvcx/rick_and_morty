import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_block.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Searh for characters...');

  final _suggestion = [
    'Rick',
    'Morty',
    'Summer',
    'Beth',
    'Jerry',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    dev.log('Inside custom delegate and search query is $query',
        error: false, time: DateTime.now());

    BlocProvider.of<PersonSearchBloc>(context, listen: false)
        .add(SearchPersons(personQuery: query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PersonSearchLoaded) {
          final person = state.persons;
          if (person.isEmpty) {
            return const _ShowErrorText(
                errorMassage: 'No Characters with that name found');
          }

          return ListView.builder(
            itemCount: person.isNotEmpty ? person.length : 0,
            itemBuilder: (context, index) {
              PersonEntity result = person[index];
              return SearchResult(personResult: result);
            },
          );
        } else if (state is PersonSearchError) {
          return _ShowErrorText(errorMassage: state.massage);
        } else {
          return const Center(
            child: Icon(Icons.now_wallpaper),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return Container();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => Text(
        _suggestion[index],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _suggestion.length,
    );
  }
}

class _ShowErrorText extends StatelessWidget {
  final String errorMassage;

  const _ShowErrorText({required this.errorMassage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMassage,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
