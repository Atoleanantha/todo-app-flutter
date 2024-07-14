import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodosLoading());
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> todosJson = json.decode(todosString);
      final todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      emit(TodosLoaded(todos));
    } else {
      emit(const TodosLoaded([]));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final List<Todo> updatedTodos = List.from((state as TodosLoaded).todos)..add(event.todo);
      await _saveTodos(updatedTodos);
      emit(TodosLoaded( updatedTodos));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final updatedTodos = (state as TodosLoaded).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      await _saveTodos(updatedTodos);
      emit(TodosLoaded( updatedTodos));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final updatedTodos = (state as TodosLoaded).todos.where((todo) => todo.id != event.id).toList();
      await _saveTodos(updatedTodos);
      emit(TodosLoaded( updatedTodos));
    }
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString = json.encode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosString);
  }
}
