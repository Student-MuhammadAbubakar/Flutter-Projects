import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_services.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Book? _foundBook;
  bool _isLoading = false;
  String? _error;

  Future<void> _search() async {
    final title = _searchController.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _foundBook = null;
    });
    try {
      final book = await ApiService().searchBook(title);
      setState(() {
        _foundBook = book;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter book title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text('Error: $_error')
            else if (_foundBook != null)
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(_foundBook!.title),
                      subtitle: Text('by ${_foundBook!.author}'),
                      onTap: () {
                        // Navigate to detail screen using the book's ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(bookId: _foundBook!.id),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                const Text('Enter a title to search'),
          ],
        ),
      ),
    );
  }
}