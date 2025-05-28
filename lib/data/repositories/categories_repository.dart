import 'package:brick_core/core.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/brick/repository.dart';
import 'package:notiq/models/category.model.dart';

abstract class CategoriesRepository {
  Future<GenericResponse<List<Category>>> getCategories();

  Future<GenericResponse<Category>> getCategory(String categoryId);

  Future<GenericResponse<Category>> createCategory(Category category);

  Future<GenericResponse<Category>> updateCategory(Category category);

  Future<GenericResponse> deleteCategory(String categoryId);
}

class CategoriesImplementation implements CategoriesRepository {
  final Repository _repository;

  CategoriesImplementation(this._repository);

  @override
  Future<GenericResponse<Category>> createCategory(Category category) async {
    try {
      final response = await _repository.upsert<Category>(category);
      return GenericResponse<Category>(
        isSuccess: true,
        message: 'Category created successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse<Category>(
        isSuccess: false,
        message: 'Failed to save Category: $e',
      );
    }
  }

  @override
  Future<GenericResponse> deleteCategory(String categoryId) async {
    try {
      final response = await _repository.get<Category>(
        query: Query.where('id', categoryId),
      );
      var firstOrNull = response.isNotEmpty ? response.first : null;
      if (firstOrNull == null) {
        return GenericResponse(isSuccess: false, message: 'Task not found');
      }
      final deleteResponse = await _repository.delete<Category>(firstOrNull);
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
  Future<GenericResponse<List<Category>>> getCategories() async {
    try {
      var userId = UserSession().getUser?.id;
      final response = await _repository.get<Category>(
        query: Query.where('user_id', userId),
      );

      if (response.isEmpty) {
        return GenericResponse(
          isSuccess: false,
          message: 'Category not found for User',
        );
      }

      return GenericResponse(
        isSuccess: true,
        message: 'Category retrieved successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to retrieve Category: $e',
      );
    }
  }

  @override
  Future<GenericResponse<Category>> getCategory(String categoryId) async {
    try {
      final response = await _repository.get<Category>(
        query: Query.where('id', categoryId),
      );
      var firstOrNull = response.isNotEmpty ? response.first : null;
      if (firstOrNull == null) {
        return GenericResponse<Category>(
          isSuccess: false,
          message: 'Category not found',
        );
      }

      return GenericResponse<Category>(
        isSuccess: true,
        message: 'Category retrieved successfully',
        data:
            firstOrNull, // Assuming you want the first task or null if not found
      );
    } catch (e) {
      return GenericResponse<Category>(
        isSuccess: false,
        message: 'Failed to retrieve Category: $e',
      );
    }
  }

  @override
  Future<GenericResponse<Category>> updateCategory(Category category) async {
    try {
      final response = await _repository.upsert<Category>(category);
      return GenericResponse<Category>(
        isSuccess: true,
        message: 'Category updated successfully',
        data: response,
      );
    } catch (e) {
      return GenericResponse<Category>(
        isSuccess: false,
        message: 'Failed to update Category: $e',
      );
    }
  }
}
