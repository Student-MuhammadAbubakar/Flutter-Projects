import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_services.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _api = ApiService();

  Future<void> loadBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _books = await _api.getBooks();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> addBook(Map<String, dynamic> bookData) async {
    try {
      await _api.createBook(bookData);
      await loadBooks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBook(int id, Map<String, dynamic> updateData) async {
    try {
      await _api.updateBook(id, updateData);
      await loadBooks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await _api.deleteBook(id);
      await loadBooks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}