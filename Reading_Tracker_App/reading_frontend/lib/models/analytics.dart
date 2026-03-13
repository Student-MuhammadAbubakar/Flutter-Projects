class Analytics {
  final int totalBooks;
  final int readingBooks;
  final int completedBooks;
  final int unreadBooks;

  Analytics({
    required this.totalBooks,
    required this.readingBooks,
    required this.completedBooks,
    required this.unreadBooks,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      totalBooks: json['total_books'],
      readingBooks: json['reading_books'],
      completedBooks: json['completed_books'],
      unreadBooks: json['unread_books'],
    );
  }
}