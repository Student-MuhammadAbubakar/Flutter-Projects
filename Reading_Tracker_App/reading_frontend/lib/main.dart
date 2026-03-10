import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];
  bool isLoading = true;
  String errorMsg = "";

  // Fetch books from FastAPI
  Future<void> fetchBooks() async {
    final url = Uri.parse("http://10.0.2.2:8000/books"); // use PC IP for real device
    try {
      final response =
      await http.get(url).timeout(const Duration(seconds: 5)); // 5s timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          books = data;
          isLoading = false;
          errorMsg = "";
        });
      } else {
        setState(() {
          isLoading = false;
          errorMsg = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = "Network error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  // Show book details in bottom sheet
  void showBookDetails(Map book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book["title"],
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Author: ${book["author"]}"),
              const SizedBox(height: 5),
              Text("Total Pages: ${book["total_pages"]}"),
              const SizedBox(height: 5),
              Text("Pages Read: ${book["pages_read"]}"),
              const SizedBox(height: 5),
              Text("Status: ${book["status"]}"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Tracker"),
        centerTitle: true,
      ),
      body: isLoading
          ? ListView.builder(
        // Skeleton loading effect
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          margin:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const ListTile(
            title: SizedBox(
                height: 20,
                child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey))),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ),
      )
          : errorMsg.isNotEmpty
          ? Center(
        child: Text(errorMsg,
            style: const TextStyle(color: Colors.red)),
      )
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(
                book["title"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () => showBookDetails(book),
              ),
            ),
          );
        },
      ),
    );
  }
}