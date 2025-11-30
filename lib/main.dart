import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/task_cubit.dart';
import 'repository/task_repository.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = TaskRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepPurple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );

    return BlocProvider(
      create: (_) => TaskCubit(repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Tracker',
        theme: base.copyWith(brightness: Brightness.light),
        darkTheme: base.copyWith(brightness: Brightness.dark),
        themeMode: ThemeMode.system, // follow device setting
        home: const HomePage(),
      ),
    );
  }
}
