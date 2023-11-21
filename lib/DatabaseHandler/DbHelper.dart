// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import 'dart:io' as io;
// import 'package:odoo_rpc/odoo_rpc.dart';

// import '../Model/CustomerModel.dart';
// import '../Model/UserModel.dart';
// import '../Model/ProductModel.dart';
// import '../Model/StockModel.dart';
// import '../Model/StockLineModel.dart';

// class DbHelper {
//   DbHelper._privateConstructor();
//   static const String DB_Name = 'model_odoo';

//   static const int Version = 1;
// // Table User
//   static const String Table_User = 'res_user';
//   static const String C_UserID = 'id';
//   static const String C_UserName = 'name';
//   static const String C_Email = 'email';
//   static const String C_Password = 'password';
// // Table Product
//   static const String Table_Produit = 'product_product';
//   static const String C_ProductId = 'id';
//   static const String C_ProductName = 'name';

// // Table Customer
//   static const String Table_Customer = 'res_partner';
//   static const String C_CustmerId = 'id';
//   static const String C_CustomerName = 'name';

// // Table Stock
//   static const String Table_Stock = 'stock_move';
//   static const String C_StockId = 'id';
//   static const String C_StockName = 'name';
//   static const String C_StockDatePrevue = 'date_prevue';
//   static const String C_StockDateEffective = 'date_effective';
//   static const String C_StockUserId = 'user_id';
//   static const String C_StockCustomerId = 'customer_id';
//   static const String C_StockValide = 'validate';

// // Table Stock Line
//   static const String Table_StockLine = 'stock_move_line';
//   static const String C_StockLineId = 'id';
//   static const String C_StockLineName = 'name';
//   static const String C_StockLineDate = 'date_create';
//   static const String C_StockProductId = 'product_id';
//   static const String C_StockLineStockId = 'stock_id';
//   static const String C_StockLineQteCmd = 'qte_cmd';
//   static const String C_StockLineQteFait = 'qte_fait';
//   static const String C_StockLineValidate = 'validate';

//   static final DbHelper instance = DbHelper._privateConstructor();

//   static Database? _database;

//   Future<Database> get database async => _database ??= await _initDatabase();

//   Future<Database> _initDatabase() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, DB_Name);
//     return await openDatabase(path, version: 1, onCreate: _onCreate);
//   }

//   _onCreate(Database db, int version) async {
//     await db.execute("CREATE TABLE $Table_User ("
//         " $C_UserID INTEGER, "
//         " $C_UserName TEXT, "
//         " $C_Email TEXT,"
//         " $C_Password TEXT, "
//         " PRIMARY KEY ($C_UserID)"
//         ")");

//     await db.execute("CREATE TABLE $Table_Customer ("
//         " $C_CustmerId INTEGER, "
//         " $C_CustomerName STRING NOT NULL, "
//         " PRIMARY KEY ($C_CustmerId)"
//         ")");
//     await db.execute("CREATE TABLE $Table_Produit ("
//         " $C_ProductId INTEGER, "
//         " $C_ProductName STRING NOT NULL, "
//         " PRIMARY KEY ($C_ProductId)"
//         ")");
//     await db.execute("CREATE TABLE $Table_Stock ("
//         " $C_StockId INTEGER, "
//         " $C_StockName STRING NOT NULL, "
//         " $C_StockDatePrevue DATETIME DEFAULT CURRENT_TIMESTAMP, "
//         " $C_StockDateEffective DATETIME DEFAULT CURRENT_TIMESTAMP, "
//         " $C_StockUserId INT NOT NULL, "
//         " $C_StockCustomerId INT NOT NULL, "
//         " $C_StockValide NUMBER(1),"
//         " PRIMARY KEY ($C_StockId),"
//         "FOREIGN KEY ($C_StockUserId) REFERENCES $Table_User(id),"
//         "FOREIGN KEY ($C_StockCustomerId) REFERENCES $Table_Customer(id),"
//         "CONSTRAINT ck_$C_StockValide CHECK ($C_StockValide IN (1,0))"
//         ")");

//     await db.execute("CREATE TABLE $Table_StockLine ("
//         " $C_StockLineId INTEGER, "
//         " $C_StockLineName STRING NOT NULL, "
//         " $C_StockLineDate DATETIME DEFAULT CURRENT_TIMESTAMP, "
//         " $C_StockLineQteCmd INT NOT NULL, "
//         " $C_StockLineQteFait INT NOT NULL, "
//         " $C_StockProductId INT NOT NULL, "
//         " $C_StockLineStockId INT NOT NULL, "
//         " $C_StockLineValidate NUMBER(1),"
//         " PRIMARY KEY ($C_StockId),"
//         "FOREIGN KEY ($C_StockProductId) REFERENCES $Table_Produit(id),"
//         "FOREIGN KEY ($C_StockLineStockId) REFERENCES $Table_Stock(id),"
//         "CONSTRAINT ck_$C_StockLineValidate CHECK ($C_StockLineValidate IN (1,0))"
//         ")");
//   }

//   Future<int> saveData(UserModel user) async {
//     var dbClient = await instance.database;
//     var res = await dbClient.insert(Table_User, user.toMap());
//     return res;
//   }

//   Future<int> saveCustomer(CustomerModel customer) async {
//     var dbCustomer = await instance.database;
//     var res = await dbCustomer.insert(Table_Customer, customer.toMap());
//     return res;
//   }

//   Future<int> saveProduct(ProductModel product) async {
//     var dbProduct = await instance.database;
//     var res = await dbProduct.insert(Table_Produit, product.toMap());
//     return res;
//   }

//   Future<int> saveStock(StockModel stock) async {
//     var dbStock = await instance.database;
//     var res = await dbStock.insert(Table_Stock, stock.toMap());
//     return res;
//   }

//   Future<int> saveStockLine(StockLineModel stockline) async {
//     var dbStockline = await instance.database;
//     var res = await dbStockline.insert(Table_StockLine, stockline.toMap());
//     return res;
//   }

//   Future<UserModel?> getLoginUser(String userEmail, String password) async {
//     var dbClient = await instance.database;
//     var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
//         "$C_Email = '$userEmail' AND "
//         "$C_Password = '$password'");

//     if (res.length > 0) {
//       return UserModel.fromMap(res.first);
//     }
//     return null;
//   }

//   Future<int> updateUser(UserModel user) async {
//     var dbClient = await instance.database;
//     var res = await dbClient.update(Table_User, user.toMap(),
//         where: '$C_UserID = ?', whereArgs: [user.id]);
//     return res;
//   }

//   Future<List<StockModel>> getStockByUser(int stock_user_id) async {
//     final dbClient = await instance.database;
//     List<Map<String, dynamic>> allRows = await dbClient.query('$Table_Stock',
//         where: '$C_StockUserId LIKE ?', whereArgs: ['%$stock_user_id%']);
//     List<StockModel> stok_moves =
//         allRows.map((stock) => StockModel.fromMap(stock)).toList();

//     return stok_moves;
//   }

//   // Future<UserModel> allUsers() async {
//   //   var dbClient = await instance.database;
//   //   final Users = await dbClient.rawQuery("SELECT * FROM $Table_User");

//   //   var users = Users.map((stock) => UserModel.fromMap(stock)).toList();

//   //   return users;
//   // }
// }
