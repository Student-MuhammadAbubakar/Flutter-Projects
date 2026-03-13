import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'update_book_screen.dart';

class DetailScreen extends StatelessWidget {
  final int bookId;

  const DetailScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    // Find the book with the given ID from the provider's list
    final book = bookProvider.books.firstWhere(
          (b) => b.id == bookId,
      orElse: () => throw Exception('Book not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('ID: ${book.id}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Title: ${book.title}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Author: ${book.author}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Total Pages: ${book.totalPages}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Pages Read: ${book.pagesRead}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Status: ${book.status}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateBookScreen(book: book),
                        ),
                      );
                      // If the update was successful, refresh the book list
                      if (updated == true) {
                        await bookProvider.loadBooks();
                      }
                    },
                    child: const Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Book'),
                          content: const Text('Are you sure you want to delete this book?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await bookProvider.deleteBook(book.id);
                          Navigator.pop(context); // Go back to home after deletion
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delete failed: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}