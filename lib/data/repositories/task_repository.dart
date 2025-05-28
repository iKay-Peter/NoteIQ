import 'package:brick_core/core.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/brick/repository.dart';
import 'package:notiq/models/task.model.dart';

abstract class TaskRepository {
  Future<GenericResponse<List<Task>>> getTasks();

  Future<GenericResponse<Task>> getTask(String taskId);

  Future<GenericResponse<Task>> createTask(Task task);

  Future<GenericResponse<Task>> updateTask(Task task);

  Future<GenericResponse> deleteTask(String taskId);

  Future<GenericResponse<List<Task>>> getTasksByStatus(bool isCompleted);

  Future<GenericResponse> updateTaskCompletion(String taskId, bool isCompleted);
}

class TaskImplementation implements TaskRepository {
  final Repository _repository;

  TaskImplementation(this._repository);

  @override
  Future<GenericResponse<Task>> createTask(Task task) async {
    try {
      final response = await _repository.upsert<Task>(task);
      return GenericResponse<Task>(
        isSuccess: true,
        message: 'Task created successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse<Task>(
        isSuccess: false,
        message: 'Failed to save task: $e',
      );
    }
  }

  @override
  Future<GenericResponse> deleteTask(String taskId) async {
    try {
      final response = await _repository.get<Task>(
        query: Query.where('id', taskId),
      );
      var firstOrNull = response.isNotEmpty ? response.first : null;
      if (firstOrNull == null) {
        return GenericResponse(isSuccess: false, message: 'Task not found');
      }
      final deleteResponse = await _repository.delete<Task>(firstOrNull);
      if (deleteResponse) {
        return GenericResponse(
          isSuccess: true,
          message: 'Task deleted successfully',
        );
      } else {
        return GenericResponse(
          isSuccess: false,
          message: 'Failed to delete task',
        );
      }
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to delete task: $e',
      );
    }
  }

  @override
  Future<GenericResponse<Task>> getTask(String taskId) async {
    try {
      final response = await _repository.get<Task>(
        query: Query.where('id', taskId),
      );
      var firstOrNull = response.isNotEmpty ? response.first : null;
      if (firstOrNull == null) {
        return GenericResponse<Task>(
          isSuccess: false,
          message: 'Task not found',
        );
      }

      return GenericResponse<Task>(
        isSuccess: true,
        message: 'Task retrieved successfully',
        data:
            firstOrNull, // Assuming you want the first task or null if not found
      );
    } catch (e) {
      return GenericResponse<Task>(
        isSuccess: false,
        message: 'Failed to retrieve task: $e',
      );
    }
  }

  @override
  Future<GenericResponse<List<Task>>> getTasks() async {
    try {
      var userId = UserSession().getUser?.id;
      final response = await _repository.get<Task>(
        query: Query.where('user_id', userId),
      );

      if (response.isEmpty) {
        return GenericResponse(
          isSuccess: false,
          message: 'Task not found for User',
        );
      }

      return GenericResponse(
        isSuccess: true,
        message: 'Task retrieved successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to retrieve task: $e',
      );
    }
  }

  @override
  Future<GenericResponse<List<Task>>> getTasksByStatus(bool isCompleted) async {
    try {
      var userId = UserSession().getUser?.id;
      final response = await _repository.get<Task>(
        query: Query(
          where: [
            Where('user_id', value: userId),
            Where('is_completed', value: isCompleted),
          ],
        ),
      );

      if (response.isEmpty) {
        return GenericResponse(
          isSuccess: false,
          message: 'Task not found for User',
        );
      }

      return GenericResponse(
        isSuccess: true,
        message: 'Task retrieved successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to retrieve task: $e',
      );
    }
  }

  @override
  Future<GenericResponse<Task>> updateTask(Task task) async {
    try {
      final response = await _repository.upsert<Task>(task);
      return GenericResponse<Task>(
        isSuccess: true,
        message: 'Task updated successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse<Task>(
        isSuccess: false,
        message: 'Failed to update task: $e',
      );
    }
  }

  @override
  Future<GenericResponse> updateTaskCompletion(
    String taskId,
    bool isCompleted,
  ) async {
    try {
      final response = await _repository.get<Task>(
        query: Query.where('id', taskId),
      );
      var task = response.isNotEmpty ? response.first : null;
      if (task == null) {
        return GenericResponse(isSuccess: false, message: 'Task not found');
      }
      // Update the isCompleted property
      task.copyWith(isCompleted: isCompleted);
      await _repository.upsert<Task>(task);
      return GenericResponse(
        isSuccess: true,
        message: 'Task completion updated successfully',
      );
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to update task completion: $e',
      );
    }
  }
}
