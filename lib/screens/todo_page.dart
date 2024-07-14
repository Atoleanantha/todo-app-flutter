import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_manager/widgets/weather_card.dart';

import '../api/weather_repository.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoPage extends StatelessWidget {
  WeatherRepository weatherRepository;
  TodoPage({required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(

      builder: (context, state) {
        if (state is TodosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodosLoaded) {
          if(state.todos.isEmpty){
            return const Center(child: Text("No Tasks"),);
          }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              if(index==0){
                return WeatherCard(weatherRepository: weatherRepository);
              }
              final todo = state.todos[index];

              return Dismissible(
                  key: Key(todo.id),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("You want to delete task?"),
                        showCloseIcon: true,
                        action: SnackBarAction(label: "Delete", onPressed: (){
                          context.read<TodoBloc>().add(DeleteTodo(todo.id));

                        },
                        ),
                      ),
                    );
                  },
                  background: Container(color: Colors.red),
                  child:Card(
                    shadowColor:todo.isCompleted? Colors.green:Colors.red,
                    elevation: 10,
                    child: ListTile(
                      
                      leading: todo.isCompleted?const Icon(Icons.done,color: Colors.green,):Icon(Icons.hourglass_top,color: Colors.red,),
                      title: Text(todo.task.toUpperCase()),
                      subtitle: Text(todo.description,style:const TextStyle(fontSize: 16),),
                      trailing:
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          context.read<TodoBloc>().add(UpdateTodo(
                              todo.copyWith(isCompleted: value ?? false)));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: todo.isCompleted?Colors.red:Colors.green,content: Text(todo.isCompleted?"Marked as incomplete":"Marked as completed.")));
                        },
                      ),
                      onLongPress: () {
                        context.read<TodoBloc>().add(UpdateTodo(
                            todo.copyWith(isPriority:todo.isPriority? false:true)));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(todo.isPriority?"Removed from Priority list":"Added in priority list.")));
                        // context.read<TodoBloc>().add(DeleteTodo(todo.id));
                      },
                      titleTextStyle: TextStyle(color: todo.isCompleted?Colors.green:Colors.red,fontWeight: FontWeight.bold,fontSize: 20) ,
                    ),
                  ));
            },
          );
        } else {
          return const Center(child: Text('Failed to load todos'));
        }
      },
    );
  }
}
