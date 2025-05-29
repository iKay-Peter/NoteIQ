import 'package:flutter/material.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/app/utils/task_details.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/data/repositories/task_repository.dart';
import 'package:notiq/models/task.model.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskProvider(this._taskRepository);

  // VARIABLES
  bool _isLoading = false;
  List<Task> _tasks = [];
  Task? _selectedTask;
  String? _newTaskTitle;
  TaskDetails _taskDetails = TaskDetails();

  // GETTERS
  bool get isLoading => _isLoading;
  List<Task> get tasks => _tasks;
  Task? get selectedTask => _selectedTask;
  TaskDetails get taskDetails => _taskDetails;
  String? get newTaskTitle => _newTaskTitle;

  // SETTERS
  void selectTask(Task? task) {
    _selectedTask = task;
    notifyListeners();
  }

  void setNewTaskTitle(String title) {
    _newTaskTitle = title;
    notifyListeners();
  }

  void updateTaskDetails({
    DateTime? dueDate,
    TimeOfDay? dueTime,
    String? priority,
    String? tag,
    bool? isRecurring,
    Duration? recurrenceInterval,
  }) {
    _taskDetails = _taskDetails.copyWith(
      dueDate: dueDate,
      dueTime: dueTime,
      priority: priority,
      tag: tag,
      isRecurring: isRecurring,
      recurrenceInterval: recurrenceInterval,
    );
    notifyListeners();
  }

  void resetTaskDetails() {
    _taskDetails.reset();
    _newTaskTitle = null;
    notifyListeners();
  }

  // Create a new task with current details
  Task createNewTask() {
    if (_newTaskTitle == null || _newTaskTitle!.isEmpty) {
      throw Exception('Task title is required');
    }

    DateTime? dueDateTime;
    if (_taskDetails.dueDate != null && _taskDetails.dueTime != null) {
      dueDateTime = DateTime(
        _taskDetails.dueDate!.year,
        _taskDetails.dueDate!.month,
        _taskDetails.dueDate!.day,
        _taskDetails.dueTime!.hour,
        _taskDetails.dueTime!.minute,
      );
    }

    return Task(
      user_id: UserSession().getUser!.id,
      title: _newTaskTitle!,
      dueDate: dueDateTime,
      priority: _taskDetails.priority,
      tag: _taskDetails.tag,
      isRecurring: _taskDetails.isRecurring,
      recurrenceInterval: _taskDetails.recurrenceInterval,
    );
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

  // Future<GenericResponse> addTask() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _newTask!.copyWith(user_id: UserSession().getUser!.id);
  //     var response = await _taskRepository.createTask(_newTask!);
  //     if (response.isSuccess) {
  //       await fetchTasks();
  //       return GenericResponse(
  //         isSuccess: true,
  //         message: 'Task added successfully',
  //       );
  //     } else {
  //       return GenericResponse(isSuccess: false, message: response.message);
  //     }
  //   } catch (error) {
  //     return GenericResponse(
  //       isSuccess: false,
  //       message: 'Failed to add task: $error',
  //     );
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

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

  // Create a new task with current details and save it
  Future<GenericResponse> addTask() async {
    _isLoading = true;
    notifyListeners();
    try {
      final task = createNewTask();
      var response = await _taskRepository.createTask(task);
      if (response.isSuccess) {
        _tasks.insert(0, response.data!);
        resetTaskDetails(); // Reset the details after successful creation
        return GenericResponse(
          isSuccess: true,
          message: 'Task created successfully',
          data: response.data,
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (e) {
      return GenericResponse(isSuccess: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
