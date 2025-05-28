import 'package:flutter/material.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/data/repositories/categories_repository.dart';
import 'package:notiq/models/category.model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoriesRepository _categoryRepository;

  CategoryProvider(this._categoryRepository);

  // VARIABLES
  bool _isLoading = false;
  List<Category> _categories = [];
  Category? _selectedCategory;

  // GETTERS
  bool get isLoading => _isLoading;
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;

  // SETTERS
  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ACTIONS
  Future<GenericResponse> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _categoryRepository.getCategories();
      if (response.isSuccess) {
        _categories = response.data ?? [];
        return GenericResponse(
          isSuccess: true,
          message: 'Categories fetched successfully',
        );
      } else {
        _categories = [];
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to fetch categories: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> addCategory(Category category) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _categoryRepository.createCategory(category);
      if (response.isSuccess) {
        await fetchCategories();
        return GenericResponse(
          isSuccess: true,
          message: 'Category added successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to add category: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> updateCategory(Category category) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _categoryRepository.updateCategory(category);
      if (response.isSuccess) {
        await fetchCategories();
        return GenericResponse(
          isSuccess: true,
          message: 'Category updated successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to update category: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> deleteCategory(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await _categoryRepository.deleteCategory(id);
      if (response.isSuccess) {
        await fetchCategories();
        return GenericResponse(
          isSuccess: true,
          message: 'Category deleted successfully',
        );
      } else {
        return GenericResponse(isSuccess: false, message: response.message);
      }
    } catch (error) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to delete category: $error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
