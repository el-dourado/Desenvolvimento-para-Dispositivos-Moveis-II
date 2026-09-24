import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produto_model.dart';

class ProdutoBanco {
  static final ProdutoBanco instance = ProdutoBanco._init();
  static Database? _database;

  ProdutoBanco._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('produtos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        categoria TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');
  }

  Future<int> insertProduto(Produto produto) async {
    final db = await instance.database;
    return db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> getProdutos() async {
    final db = await instance.database;
    final result = await db.query('produtos');
    return result.map((json) => Produto.fromMap(json)).toList();
  }

  Future<int> deleteProduto(int id) async {
    final db = await instance.database;
    return db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }
}