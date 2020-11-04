# sql_db

flutter에서 sqldb 사용법을 배운다.
예제는 구글링에서 찾은 [블로그](https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91)를 기본으로 한다.

## 의존성
sqflite와 path_provider가 필요하다.
sql이 아니고 sqf이다. 파일db라서 그런것인가??
path_provider는 문서 디렉토리를 찾기 위해 사용된다.
```
sqflite: ^1.2.0
path_provider: ^1.5.1
```

## 데이터베이스 헬퍼 클래스
우선 눈에 띄는 부분이 싱클톤 객체로 만드는 부분이다.
코드와 주석은 이해가 되는데, _privateConstructor();이게 공식적인 문법인지 애매하다.
구글링을 해봐도 명확하게 나오지는 않는데, 코드 실행상 이상이 없으니 맞겠죠??
```
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
```

실제 instance부분은 싱글톤 객체로 유일한 데이터접근 경로인것이고,
실제 데이터베이스 객체는 아래와 같이 선언되어 있다.

역시 static으로 선언되어 있고, get을 할때 최초 한번 초기화를 수행한다.
초기화에는 데이터베이스 생성을 위한 ddl도 포함되어 있다.
테이블 구조는 목적에 맞게 정의하되, app이기때문에 너무 복잡한 구조는 피하게 좋을듯 하다.
```
  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
  }
```

## 데이터베이스 CRUD
실제 sql과는 조금 다르다.
orm같은 느낌이 더 강하다.
간단한 코드저장/select 용도이기 때문에 크게 문제가 없을것 같다.
실제 SQL도 되는것 같지만, 코드 샘플상 sql보다는 프로그램코드를 권장하는 느낌이다.
(당연히 app개발 영역이니 복잡한 sql보다 심플한 코드가 선호되는게 맞다고 본다.)
```
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
```


## 데이터 베이스 사용
싱글턴객체를 통해서 일단 데이터베이스 객체를 구한다.
그리고, 선언된 crud 메소드를 통해 실제 database객체로 접근하도록 가이드 되고 있다.
```
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

...
...

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

```
