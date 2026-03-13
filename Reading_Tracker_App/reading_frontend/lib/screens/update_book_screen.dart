import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class UpdateBookScreen extends StatefulWidget {
  final Book book;

  const UpdateBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  _UpdateBookScreenState createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pagesReadController;
  late String _selectedStatus;

  final List<String> statuses = ['un_read', 'in_progress', 'completed'];

  @override
  void initState() {
    super.initState();
    _pagesReadController = TextEditingController(
      text: widget.book.pagesRead.toString(),
    );
    _selectedStatus = widget.book.status;
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pagesReadController,
                decoration: const InputDecoration(labelText: 'Pages Read'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pages read';
                  }
                  final read = int.tryParse(value);
                  if (read == null) {
                    return 'Enter a valid number';
                  }
                  if (read > widget.book.totalPages) {
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
                    final updateData = {
                      'pages_read': int.parse(_pagesReadController.text),
                      'status': _selectedStatus,
                    };
                    try {
                      await bookProvider.updateBook(widget.book.id, updateData);
                      // Return true to indicate success
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Update failed: $e')),
                      );
                    }
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}