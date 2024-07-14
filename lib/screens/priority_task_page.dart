import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class PriorityTasks extends StatelessWidget {
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
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              if(state.todos[index].isPriority ) {
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
                    child:ListTile(
                      horizontalTitleGap: 1.0,
                      title: Text(todo.task.toUpperCase()),
                      subtitle: Text(todo.description,style: TextStyle(fontSize: 16),),
                      trailing:
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          context.read<TodoBloc>().add(UpdateTodo(
                              todo.copyWith(isCompleted: value ?? false)));
                        },
                      ),
                      onLongPress: () {
                        context.read<TodoBloc>().add(UpdateTodo(
                            todo.copyWith(isPriority:todo.isPriority? false:true)));
                        // context.read<TodoBloc>().add(DeleteTodo(todo.id));
                      },
                      titleTextStyle: TextStyle(color: todo.isCompleted?Colors.green:Colors.red,fontWeight: FontWeight.bold,fontSize: 20) ,
                    ));
              }
            },
          );
        } else {
          return Center(child: Text('Failed to load todos'));
        }
      },
    );
  }
}
