import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

String inputFile = '../gal.txt';
String dbPath = '../gal.db';
String tableName = 'main';

void main() async {
  if (!await File(dbPath).exists()) {
    final db = sqlite3.open(dbPath);
    db.execute('''
     CREATE TABLE $tableName (
       id INTEGER NOT NULL PRIMARY KEY,
       t TEXT NOT NULL
     );
   ''');

    // Prepare a statement to run it multiple times:
    final stmt = db.prepare('INSERT INTO $tableName (t) VALUES (?)');

    if (await File(inputFile).exists()) {
      final fileAsString = await File(inputFile).readAsString();

      // Split the text by paragraph breaks (two or more newlines).
      final paragraphs = fileAsString.split(RegExp(r'(\n\s*){2,}'));

      for (final paragraph in paragraphs) {
        // Replace all whitespace sequences (including newlines) with a single space,
        // and trim leading/trailing whitespace.
        final t = paragraph.replaceAll(RegExp(r'\s+'), ' ').trim();

        if (t.isNotEmpty) {
          print(t);
          stmt.execute([t]);
        }
      }
    }
    stmt.close();
    db.close(); // Also good practice to close the database connection.
  } else {
    print("DATABASE EXISTS!");
  }
}
