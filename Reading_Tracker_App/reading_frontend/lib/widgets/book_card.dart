import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = book.totalPages > 0
        ? (book.pagesRead / book.totalPages * 100)
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${book.id}'),
        ),
        title: Text(book.title),
        subtitle: Text('by ${book.author}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${percentage.toStringAsFixed(1)}%'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                // Pass only the book ID, not the whole object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(bookId: book.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}