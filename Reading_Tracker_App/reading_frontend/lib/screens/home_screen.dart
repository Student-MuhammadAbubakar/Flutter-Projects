import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/book_card.dart';
import 'create_book_screen.dart';
import 'search_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookProvider>().loadBooks());
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // Removed fixed background color – now adapts to theme
        title: const Text(
          'Book Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Keeps title centered and visible
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final isDark = themeProvider.themeMode != ThemeMode.dark;
              themeProvider.toggleTheme(isDark);
            },
          ),
        ],
      ),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookProvider.error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${bookProvider.error}'),
            ElevatedButton(
              onPressed: () => bookProvider.loadBooks(),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : bookProvider.books.isEmpty
          ? const Center(child: Text('No books yet. Add one!'))
          : ListView.builder(
        itemCount: bookProvider.books.length,
        itemBuilder: (context, index) {
          final book = bookProvider.books[index];
          return BookCard(book: book);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateBookScreen()),
                ).then((_) => bookProvider.loadBooks());
              },
              child: const Icon(Icons.add),
              elevation: 2,
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}