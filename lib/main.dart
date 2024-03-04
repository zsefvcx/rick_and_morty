import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/common/app_colors.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_block.dart';
import 'package:rick_and_morty/feature/presentation/pages/person_screen.dart';
import 'package:rick_and_morty/locator_service.dart' as di;

import 'locator_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark();
    final colorScheme = ThemeData.dark().colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
          create: (context) => sl<PersonListCubit>()..loadPerson(),
        ),
        BlocProvider<PersonSeachBloc>(
          create: (context) => sl<PersonSeachBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: darkTheme.copyWith(
          scaffoldBackgroundColor: AppColors.mainBackGroung,
          colorScheme:
              colorScheme.copyWith(background: AppColors.mainBackGroung),
        ),
        home: const HomePage(),
      ),
    );
  }
}
