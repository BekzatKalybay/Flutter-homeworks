class Book {
  final String id;
  final String title;
  final String author;

  Book(this.id, this.title, this.author);

  @override
  String toString() {
    return '$title by $author';
  }
}

class Reader {
  final String name;
  final DateTime registrationDate;
  Set<Book> borrowedBooks = {};

  Reader(this.name, this.registrationDate);

  @override
  String toString() {
    return 'Reader: $name, Registered: $registrationDate';
  }
}

class Library {
  Map<String, Book> books = {};
  List<Reader> readers = [];
  Set<Book> borrowedBooks = {};

  void addBook(String id, String title, String author) {
    books[id] = Book(id, title, author);
  }

  void removeBook(String id) {
    books.remove(id);
  }

  void registerReader(String name) {
    readers.add(Reader(name, DateTime.now()));
  }

  void removeReader(String name) {
    readers.removeWhere((reader) => reader.name == name);
  }

  void lendBook(String bookId, String readerName) {
  Book? book = books[bookId];
  Reader? reader;

  try {
    reader = readers.firstWhere((reader) => reader.name == readerName);
  } catch (e) {
    reader = null;
  }

  if (book != null && reader != null && !borrowedBooks.contains(book)) {
    borrowedBooks.add(book);
    reader.borrowedBooks.add(book);
  }
}

void returnBook(String bookId, String readerName) {
  Book? book = books[bookId];
  Reader? reader;

  try {
    reader = readers.firstWhere((reader) => reader.name == readerName);
  } catch (e) {
    reader = null;
  }

  if (book != null && reader != null && borrowedBooks.contains(book)) {
    borrowedBooks.remove(book);
    reader.borrowedBooks.remove(book);
  }
}

  List<Book> searchBooks(String query) {
    return books.values.where((book) => book.title.contains(query) || book.author.contains(query)).toList();
  }

  List<Reader> filterReaders(bool Function(Reader) criteria) {
    return readers.where(criteria).toList();
  }
}

void main() {
  Library library = Library();

  library.addBook('1', 'The Hobbit', 'J.R.R. Tolkien');
  library.addBook('2', 'To Kill a Mockingbird', 'Harper Lee');

  library.registerReader('Alice');
  library.registerReader('Bob');

  library.lendBook('1', 'Alice');
  library.lendBook('2', 'Bob');

  print('Books in the library:');
  library.books.values.forEach((book) {
    print('${book.id}: ${book.title} by ${book.author}');
  });

  print('\nReaders:');
  library.readers.forEach((reader) {
    print(reader);
    print('  Borrowed books: ${reader.borrowedBooks}');
  });

  print('\nBooks returned:');
  library.returnBook('1', 'Alice');
  library.returnBook('2', 'Bob');

  library.books.remove('1');
  library.books.remove('2');

  print('\nBooks in the library after removal:');
  library.books.values.forEach((book) {
    print('${book.id}: ${book.title} by ${book.author}');
  });
}