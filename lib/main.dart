import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:magic_tasks/core/routing/routes.dart';
import 'package:magic_tasks/core/theme/app_theme.dart';
import 'package:magic_tasks/core/utils/snack_bar.dart';
import 'package:magic_tasks/core/widgets/app_snackbar.dart';
import 'package:magic_tasks/features/task/models/enum.g.dart';
import 'package:magic_tasks/features/task/models/task.dart';
import 'package:magic_tasks/features/task/repositories/task_repository.dart';
import 'package:magic_tasks/features/task/view/bloc/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(StatusAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(TaskRepository()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              AppSnackbar(key: snackbarKey),
            ],
          );
        },
        themeMode: ThemeMode.system,
        theme: const AppTheme().theme,
        darkTheme: const AppDarkTheme().theme,
        routerConfig: router,
      ),
    );
  }
}
