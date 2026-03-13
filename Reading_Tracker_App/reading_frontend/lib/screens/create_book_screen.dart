import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({Key? key}) : super(key: key);

  @override
  _CreateBookScreenState createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _totalPagesController = TextEditingController();
  final _pagesReadController = TextEditingController();
  String _selectedStatus = 'un_read';

  final List<String> statuses = ['un_read', 'in_progress', 'completed'];

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalPagesController,
                decoration: const InputDecoration(labelText: 'Total Pages'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total pages';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pagesReadController,
                decoration: const InputDecoration(labelText: 'Pages Read'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pages read';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  int total = int.tryParse(_totalPagesController.text) ?? 0;
                  int read = int.parse(value);
                  if (read > total) {
                    return 'Pages read cannot exceed total pages';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final bookData = {
                      'title': _titleController.text,
                      'author': _authorController.text,
                      'Total_pages': int.parse(_totalPagesController.text),
                      'pages_read': int.parse(_pagesReadController.text),
                      'status': _selectedStatus,
                    };
                    try {
                      await bookProvider.addBook(bookData);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add book: $e')),
                      );
                    }
                  }
                },
                child: const Text('Create Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}