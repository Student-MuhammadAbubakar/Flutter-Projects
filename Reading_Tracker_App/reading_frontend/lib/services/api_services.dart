import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/analytics.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // GET /books
  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  // POST /books
  Future<int> createBook(Map<String, dynamic> bookData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bookData),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['book_id'];
    } else {
      throw Exception('Failed to create book');
    }
  }

  // PATCH /books/{id}
  Future<void> updateBook(int id, Map<String, dynamic> updateData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/books/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    }
  }

  // DELETE /books/{id}
  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/books/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }

  // GET /search?title=
  Future<Book> searchBook(String title) async {
    final response = await http.get(Uri.parse('$baseUrl/search?title=$title'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Book.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Book not found');
    } else {
      throw Exception('Search failed');
    }
  }

  // GET /analytics
  Future<Analytics> getAnalytics() async {
    final response = await http.get(Uri.parse('$baseUrl/analytics'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Analytics.fromJson(data);
    } else {
      throw Exception('Failed to load analytics');
    }
  }
}