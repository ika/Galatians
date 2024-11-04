import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

String filePath = './rev.txt';
String dbPath = './rev.db';
String tableName = 'rev';

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

    try {
      if (await File(filePath).exists()) {
        var file = File(filePath);
        // read whole file as string
        String contents = await file.readAsString();
        // split on paragraph breaks
        List<String> lines = contents.split('\n\n');
        // or
        //List<String> lines =await file.readAsLines();
        for (var line in lines) {
          // remove spaces
          var out = line.replaceAll(RegExp(r"\s+"), " ");
          stmt.execute([out]);
          // or
          //print(out);
        }
      }
      print('COMPLETE');
      stmt.dispose();
    } catch (e) {
      print('ERROR IN FILE: $e');
    }
  } else {
    print("DATABASE EXISTS!");
  }
}
