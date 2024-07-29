// main.dart (continued)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_manager/screens/add_todo_bottonsheet.dart';
import 'package:todo_manager/screens/priority_task_page.dart';
import 'package:todo_manager/screens/todo_page.dart';

import 'api/weather_repository.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/weather/weather_bloc.dart';
import 'bloc/weather/weather_event.dart';
import 'model/todo.model.dart';

void main() {
  final WeatherRepository weatherRepository = WeatherRepository();
  runApp(MyApp(weatherRepository: weatherRepository));
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  MyApp({required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc()..add(LoadTodos()),
        ),
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(weatherRepository),
        ),
      ],
      child: MaterialApp(
        darkTheme: ThemeData.dark(),
        home: MainPage(weatherRepository: weatherRepository),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final WeatherRepository weatherRepository;

  const MainPage({super.key, required this.weatherRepository});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TodoPage(weatherRepository: widget.weatherRepository),
      PriorityTasks(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Priority Tasks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        tooltip: "ADD TODO",
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BlocProvider.value(
                value: BlocProvider.of<TodoBloc>(context),
                child: AddTodoBottomSheet(
                  onAdd: (title, description, isPriority, isCompleted) {
                    final newTodo = Todo(
                      id: DateTime.now().toString(),
                      task: title,
                      description: description,
                      isPriority: isPriority,
                      isCompleted: isCompleted,
                    );
                    context.read<TodoBloc>().add(AddTodo(newTodo));
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}
