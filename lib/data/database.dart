import 'package:sqflite/sqflite.dart' as sql;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';


class AppDatabase {
  
  AppDatabase() {
    database();
  }

  Future<void> createDiaryEntry(Database db) async {
    //await db.execute("ALTER TABLE diaryentry ADD COLUMN dateupdated TEXT;");

    await db.execute('''CREATE TABLE IF NOT EXISTS diaryentry(
      id TEXT PRIMARY KEY,
      diaryid TEXT,
      entry TEXT,
      datecreated TEXT,
      dateupdated TEXT,
      FOREIGN KEY(diaryid) REFERENCES diary(id) ON DELETE CASCADE
    );''');
  }

  Future<void> createDiaryTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS diary(
        id TEXT PRIMARY KEY,
        name TEXT,
        datecreated TEXT
    );''');
  }

  Future<void> createTables(Database db) async {
    await createDiaryTable(db);
    await createDiaryEntry(db);
  }

  Future<Database> database() async {  
    final dbPath = await sql.getDatabasesPath();

    print('Database path $dbPath');
    
    return await sql.openDatabase(
      path.join(dbPath,'mydiary.db'),
      onCreate: (db, version) async {
        await createTables(db);
      },
      version: 1,
      onConfigure: _onConfigure
    );
  }

  //Enables foreign keys to work
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('PRAGMA auto_vacuum=FULL');
  }

  Future<void> addDiary({required String diaryName}) async {
    final db = await database();
    await createDiaryTable(db);

    DateTime currentDt = DateTime.now();
    String id = const Uuid().v4();

    await db.insert(
      "diary", 
      {
        'id' : id,
        'name' : diaryName,
        'datecreated' : currentDt.toIso8601String()
      },
      conflictAlgorithm: sql.ConflictAlgorithm.rollback  
    );
  }

  Future<DiaryEntry> addDiaryEntry({
      required String diaryId,
      required String entry,
    } 
  ) async {
    final db = await database();
    await createDiaryEntry(db);

    DateTime currentDt = DateTime.now();
    String id = const Uuid().v4();

    int rows = await db.insert(
      "diaryentry", 
      {
        'id' : id,
        'diaryid' : diaryId,
        'entry' : entry,
        'datecreated' : currentDt.toIso8601String()
      },
      conflictAlgorithm: sql.ConflictAlgorithm.rollback  
    );

    if(rows > 0) {
      return DiaryEntry(
        id: id, 
        entry: entry, 
        dateCreated: currentDt
      );
    } else {
      throw Exception("Unable to add diary entry");
    }

  }

  Future<List<Diary>> getDiaries() async {
    final db = await database();
    await createDiaryTable(db);

    String sql = "SELECT * FROM diary;"; 

    String sql2 = """
      SELECT diary.id as id, name, diary.datecreated as datecreated, diaryentry.id as entryid,
        entry, diaryentry.datecreated as entrydate FROM diary
        LEFT JOIN diaryentry ON diaryentry.diaryid = diary.id;
    """;

    List<Map<String, dynamic>> data2 = await db.rawQuery(sql2);

    print('SQL DATA $data2');

    final List<Diary> uniqueDiaries = []; // Set to ensure uniqueness
    final List<String> diaryIds = []; // For tracking

    //Build unique diaries
    for (final diary in data2) {
      if(!diaryIds.contains(diary['id'])) {
        diaryIds.add(diary['id']);
        Diary diaryObj = Diary(
          id: diary['id'],
          name: diary['name'],
          dateCreated: DateTime.parse(diary['datecreated']),
        );

        List<Map<String,dynamic>> diaryEntries = data2.where( (entry) => diaryObj.id == entry['id']).toList();
        for(Map<String,dynamic> diaryEntry in diaryEntries) {
          if(diaryEntry['entryid'] != null) {
            diaryObj.entries.add(
              DiaryEntry(
                id: diaryEntry['entryid'], 
                entry: diaryEntry['entry'], 
                dateCreated: DateTime.parse(diaryEntry['entrydate'])
              )
            );
          }
        }
        uniqueDiaries.add(diaryObj);
      }
    }

    //Build the diary entries
    // for (Diary diary in uniqueDiaries) {
    //   List<Map<String,dynamic>> diaryEntries = data2.where( (entry) => diary.id == entry['id']).toList();
    //   for(Map<String,dynamic> diaryEntry in diaryEntries) {
    //     if(diaryEntry['entryid'] != null) {
    //       diary.entries.add(
    //         DiaryEntry(
    //           id: diaryEntry['entryid'], 
    //           entry: diaryEntry['entry'], 
    //           dateCreated: DateTime.parse(diaryEntry['entrydate'])
    //         )
    //       );
    //     }
    //   }
    // }

    //print('UNIQUE DIARIES ${uniqueDiaries[0].entries}');

    List<Map<String, dynamic>> data = await db.rawQuery(sql);

    List<Diary> diaryList = [];

    for (var el in data) {
      diaryList.add(
        Diary(
          id: el['id'], 
          name: el['name'], 
          dateCreated: DateTime.parse(el['datecreated']),
        )
      );
    }

    print("UNIQUE DIARIES $uniqueDiaries");
    return uniqueDiaries; 
  }

  Future<DiaryEntry> updateDiaryEntry(String entryId, String updatedEntry) async {
    final db = await database();
    final DateTime updateDate =  DateTime.now();

    print("I WANT TO UPDATE $updatedEntry");

    int rows = await db.update(
      'diaryentry', 
      {
        'entry' : updatedEntry,
        'dateupdated' : updateDate.toIso8601String()
      },
      where: 'id = ?',
      whereArgs: [entryId]
    );

    if(rows > 0) {
      //Get the entry object
      List<Map<String,dynamic>> diaryEntry = await db.rawQuery('SELECT * FROM diaryentry WHERE id="$entryId";');
      if(diaryEntry.isEmpty) {
        throw Exception('Unable to locate updated entry');
      }
      

      return DiaryEntry(
        id: entryId, 
        entry: updatedEntry, 
        dateCreated: DateTime.parse(diaryEntry[0]['datecreated'])
      );
    } else {
      throw Exception('Failed to updated diary.');
    }

  }

}

class DiaryEntry {
  final String id;
  final String entry;
  final DateTime dateCreated;
  DateTime? dateUpdated;

  DiaryEntry ({
    required this.id,
    required this.entry,
    required this.dateCreated,
    this.dateUpdated
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entry': entry,
    'dateCreated': dateCreated.toIso8601String(),
    'dateUpdated' : dateUpdated?.toIso8601String()
  };

}

class Diary {
  final String id;
  final String name;
  final DateTime dateCreated;
  List<DiaryEntry> entries = [];

  Diary({
    required this.id,
    required this.name,
    required this.dateCreated,
    entries
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateCreated': dateCreated.toIso8601String(),
    'entries': entries.map((entry) => entry.toJson()).toList(),
  };
}