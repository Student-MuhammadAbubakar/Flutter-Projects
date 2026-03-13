class Book {
  final int id;
  final String title;
  final String author;
  final int totalPages;
  final int pagesRead;
  final String status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.totalPages,
    required this.pagesRead,
    required this.status,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      totalPages: json['total_pages'],
      pagesRead: json['pages_read'],
      status: json['status'],
    );
  }
}