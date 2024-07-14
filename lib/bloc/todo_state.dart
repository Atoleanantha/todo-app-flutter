
import 'package:equatable/equatable.dart';
import '../model/todo.model.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  const TodosLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodosError extends TodoState {}
