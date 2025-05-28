import 'package:flutter/material.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/data/repositories/task_repository.dart';
import 'package:notiq/models/task.model.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskProvider(this._taskRepository);

  // VARIABLES
  bool _isLoading = false;
  List<Task> _tasks = [];
  Task? _selectedTask;
  Task? _newTask;

  // GETTERS
  bool get isLoading => _isLoading;
  List<Task> get tasks => _tasks;
  Task? get selectedTask => _selectedTask;

  // SETTERS
  void selectTask(Task? task) {
    _selectedTask = task;
    notifyListeners();
  }

  // ACTIONS
  Future<GenericResponse> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _taskRepository.getTasks();
      if (response.isSuccess) {
        _tasks = response.data ?? [];
        return GenericResponse(
          isSuccess: true,
          message: 'Tasks fetched successfully',
        );
      } else {
        _tasks = [];
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to fetch tasks: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> addTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _taskRepository.createTask(task);
      if (response.isSuccess) {
        await fetchTasks();
        return GenericResponse(
          isSuccess: true,
          message: 'Task added successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to add task: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> updateTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _taskRepository.updateTask(task);
      if (response.isSuccess) {
        await fetchTasks();
        notifyListeners();
        return GenericResponse(
          isSuccess: true,
          message: 'Task updated successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to update task: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> deleteTask(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _taskRepository.deleteTask(id);
      if (response.isSuccess) {
        await fetchTasks();
        return GenericResponse(
          isSuccess: true,
          message: 'Task deleted successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to delete task: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> fetchTasksByStatus(bool isCompleted) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _taskRepository.getTasksByStatus(isCompleted);
      if (response.isSuccess) {
        _tasks = response.data ?? [];
        return GenericResponse(
          isSuccess: true,
          message: 'Tasks fetched successfully',
        );
      } else {
        _tasks = [];
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to fetch tasks: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      final task = _tasks.where((t) => t.id == taskId).firstOrNull;
      if (task != null) {
        final updatedTask = task.copyWith(isCompleted: isCompleted);
        await updateTask(updatedTask);
      }
    } catch (e) {
      print('Error updating task completion: $e');
    } finally {
      notifyListeners();
    }
  }
}
