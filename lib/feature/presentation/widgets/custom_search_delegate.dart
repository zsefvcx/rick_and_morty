import 'dart:async';
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

  BuildContext? _context;

  final _suggestion = [
    'Rick',
    'Morty',
    'Summer',
    'Beth',
    'Jerry',
  ];

  final scrollController = ScrollController();

  void setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          final localContext = _context;
          if (query.isNotEmpty && localContext != null) {
            BlocProvider.of<PersonSearchBloc>(localContext).add(SearchPersons(
              personQuery: query,
            ));
            /* context.read<PersonSearchBloc>().add(
                  SearchPersons(
                    personQuery: query,
                  ),
                );*/
          }
        }
      }
    });
  }

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
    if (_context == null) setupScrollController();
    _context = context;
    BlocProvider.of<PersonSearchBloc>(context, listen: false)
      ..page = 1
      ..add(SearchPersons(personQuery: query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        var persons = <PersonEntity>[];
        bool isLoading = false;

        if (state is PersonSearchLoading && state.isFirstFetch) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PersonSearchLoading) {
          persons = state.oldPersonsList;
          isLoading = true;
        } else if (state is PersonSearchLoaded) {
          persons = state.persons;
          if (persons.isEmpty) {
            return const _ShowErrorText(
                errorMassage: 'No Characters with that name found');
          }
        } else if (state is PersonSearchError) {
          return _ShowErrorText(errorMassage: state.massage);
        }
        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < persons.length) {
              return SearchResult(personResult: persons[index]);
            } else {
              Timer(
                const Duration(milliseconds: 30),
                () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                },
              );
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[400],
          ),
          itemCount:
              (persons.isNotEmpty ? persons.length : 0) + (isLoading ? 1 : 0),
        );
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
