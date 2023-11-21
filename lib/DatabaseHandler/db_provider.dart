import '../Model/UserModel.dart';
import 'package:path/path.dart';
import '../Model/StockModel.dart';

import '../Model/StockLineModel.dart';

// import '../Modelodel.dart';
import '../Model/CashModel.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DBProvider {
  DBProvider._privateConstructor();
  static const String DB_Name = 'odoo_etbf.db';

  static const int Version = 1;
// Table User
  static const String Table_User = 'res_users';
  static const String C_UserID = 'id';
  static const String C_UserName = 'name';
  static const String C_Login = 'login';
  static const String C_Password = 'password';

// Table Stock
  static const String Table_Stock = 'stock_picking';
  static const String C_StockId = 'id';
  static const String C_StockName = 'name';
  static const String C_StockDatePrevue = 'date_prevue';
  static const String C_StockDateEffective = 'date_effective';
  static const String C_StockDeliAgentID = 'delivery_agent_id';
  static const String C_StockDeliAgentName = 'delivery_agent_name';
  static const String C_StockCustomerId = 'customer_id';
  static const String C_StockCustomerName = 'customer_name';
  static const String C_StockZone = 'delivery_zone';
  static const String C_StockSaleOrderId = 'sale_order_id';
  static const String C_StockSaleOrderName = 'sale_order_name';
  static const String C_StockAmountTotal = 'amount_total';
  static const String C_StockAmountPaid = 'amount_paid';
  static const String C_StockState = 'state';
  static const String C_StockValidate = 'validate';

// Table Stock Line
  static const String Table_StockLine = 'stock_move_line';
  static const String C_StockLineId = 'id';
  static const String C_StockLinePickingId = 'picking_id';
  static const String C_StockProduct = 'product';
  static const String C_StockLinePackQty = 'product_packaging_qty';
  static const String C_StockLinePackQtyDone = 'packaging_qty_done';
  static const String C_StockLinePricePack = 'product_packaging_price';
  static const String C_StockLineAmountTva = 'amount_tva';
  static const String C_StockLineAmountBic = 'amount_bic';
  static const String C_StockLineTotalAmountTva = 'total_tva';
  static const String C_StockLineTotalAmountBic = 'total_bic';
  static const String C_StockLinePriceSubtotal = 'price_subtotal';
  static const String C_StockLinePriceTotal = 'price_total';
  static const String C_StockLineState = 'state';
  static const String C_StockLineIsDone = 'is_done';

  // Table CASH
  static const String TableCash = 'cash';
  static const String CashId = 'id';
  static const String CashDate = 'date';
  static const String CashUser = 'user_id';
  static const String CashPartner = 'partner_id';
  static const String CashSale = 'sale_id';
  static const String CashPicking = 'picking_id';
  static const String CashAmount = 'amount';
  static const String CashReceiveAmount = 'receive_amount';
  static const String CashReceiveEspece = 'recveive_amount_espece';
  static const String CashReceiveCheque = 'recveive_amount_cheque';
  static const String CashReceiveMomo = 'receive_amount_momo';

  // static const String CashReceiveTimbre = 'recveive_amount_timbre';
  static const String CashAmountTva = 'amount_tva';
  static const String CashAmountBic = 'amount_bic';
  static const String Cashchange = 'change';
  static const String CashCreance = 'creance';
  static const String CashState = 'state';
  static const String CashIsDone = 'is_done';

  static final DBProvider instance = DBProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $C_UserID INTEGER, "
        " $C_UserName TEXT NOT NULL, "
        " $C_Login TEXT NOT NULL,"
        " $C_Password TEXT NOT NULL, "
        " PRIMARY KEY ($C_UserID)"
        ")");

    await db.execute("CREATE TABLE $Table_Stock ("
        " $C_StockId INTEGER PRIMARY KEY,"
        " $C_StockName TEXT NOT NULL,"
        " $C_StockDatePrevue TEXT NOT NULL,"
        " $C_StockDateEffective TEXT NOT NULL,"
        " $C_StockDeliAgentID INTEGER NOT NULL,"
        " $C_StockDeliAgentName TEXT NOT NULL,"
        " $C_StockCustomerId INTEGER NOT NULL,"
        " $C_StockCustomerName TEXT NOT NULL,"
        " $C_StockZone TEXT NOT NULL,"
        " $C_StockSaleOrderId INTEGER NOT NULL, "
        " $C_StockSaleOrderName TEXT NOT NULL, "
        " $C_StockAmountTotal REAL NOT NULL, "
        " $C_StockAmountPaid REAL NOT NULL, "
        " $C_StockState TEXT NOT NULL,"
        " $C_StockValidate TEXT NOT NULL,"
        " FOREIGN KEY ($C_StockDeliAgentID) REFERENCES $Table_User(id))");

    await db.execute("CREATE TABLE $Table_StockLine ("
        " $C_StockLineId INTEGER PRIMARY KEY, "
        " $C_StockLinePickingId INTEGER NOT NULL,"
        " $C_StockProduct TEXT NOT NULL, "
        " $C_StockLinePackQty REAL NOT NULL, "
        " $C_StockLinePackQtyDone REAL NOT NULL, "
        " $C_StockLinePricePack REAL NOT NULL, "
        " $C_StockLineAmountTva REAL NOT NULL, "
        " $C_StockLineAmountBic REAL NOT NULL,"
        " $C_StockLineTotalAmountTva REAL NOT NULL,"
        " $C_StockLineTotalAmountBic REAL NOT NULL,"
        " $C_StockLinePriceSubtotal REAL NOT NULL, "
        " $C_StockLinePriceTotal REAL NOT NULL, "
        " $C_StockLineState TEXT NOT NULL,"
        " $C_StockLineIsDone STRING NOT NULL,"
        " FOREIGN KEY ($C_StockLinePickingId) REFERENCES $Table_Stock(id))");

    await db.execute("CREATE TABLE $TableCash ("
        " $CashId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $CashDate STRING NOT NULL,"
        " $CashUser INTEGER NOT NULL, "
        " $CashPartner INTEGER NOT NULL, "
        " $CashSale INTEGER NOT NULL, "
        " $CashPicking INTEGER NOT NULL, "
        " $CashAmount REAL NOT NULL, "
        " $CashReceiveAmount REAL NOT NULL, "
        " $CashReceiveEspece REAL NOT NULL, "
        " $CashReceiveCheque REAL NOT NULL, "
        " $CashReceiveMomo REAL NOT NULL, "
        " $CashAmountTva REAL NOT NULL, "
        " $CashAmountBic REAL NOT NULL, "
        " $Cashchange REAL NOT NULL, "
        " $CashCreance REAL NOT NULL,"
        " $CashState TEXT NOT NULL,"
        " $CashIsDone STRING NOT NULL,"
        " FOREIGN KEY ($CashUser) REFERENCES $Table_User(id)"
        " FOREIGN KEY ($CashPicking) REFERENCES $Table_Stock(id))");
  }

  // Insert Cash database
  createCash(CashModel newCash) async {
    final db = await database;
    final res = await db.insert(TableCash, newCash.toJson());

    return res;
  }

  Future<CashModel?> getCash(int user_id, int sale_id, int partner_id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $TableCash WHERE "
        "$CashPartner = $partner_id AND $CashSale = $sale_id AND $CashUser = $user_id");

    if (res.length > 0) {
      return CashModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<Map>> getCashUser(int user_id) async {
    Database db = await instance.database;
    List<Map> res = await db.rawQuery('''
    SELECT DATE($CashDate) AS cash_date, SUM($CashAmount) AS total_receive_amount, SUM($CashReceiveEspece) AS total_receive_amount_espece 
    FROM $TableCash 
    WHERE $CashUser = $user_id
    GROUP BY cash_date
    ORDER BY cash_date DESC;
  ''');

    print("Le nombre d'enregistrement ${res.length}");
    return res.toList();
  }

  Future<Map<String, dynamic>> getCurrentDateTotals(int user_id) async {
    Database db = await instance.database;

    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT SUM($CashReceiveAmount) AS total_receive_amount, SUM($CashReceiveEspece) AS total_receive_amount_espece 
    FROM $TableCash 
    WHERE DATE($CashDate) = '$formattedDate' AND $CashUser = $user_id
  ''');

    if (res.isNotEmpty) {
      return res.first;
    }

    return {
      'total_receive_amount': 0,
      'total_receive_amount_espece': 0,
    };
  }

  // Insert employee on database

  Future<UserModel?> getUserId(int id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_UserID = '$id'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  createEmployee(UserModel newUser) async {
    final db = await database;
    final res = await db.insert(Table_User, newUser.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $Table_User');

    return res;
  }

  Future<UserModel?> getLoginUser(String userEmail, String password) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_Login = '$userEmail' AND "
        "$C_Password = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllEmployees() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM $Table_User");

    List<UserModel> list =
        res.isNotEmpty ? res.map((c) => UserModel.fromJson(c)).toList() : [];

    return list;
  }

  // Stock
  createstock(PickingModel newStock) async {
    final db = await database;
    final res = await db.insert(Table_Stock, newStock.toJson());

    return res;
  }

  saveStock(PickingModel stock) async {
    var dbStock = await instance.database;
    var res = await dbStock.insert(Table_Stock, stock.toMap());
    return res;
  }

  Future<PickingModel?> getAllStock() async {
    var db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM $Table_Stock");

    if (res.length > 0) {
      return PickingModel.fromJson(res.first);
    }
    return null;
  }

  Future<List<PickingModel>> getAllStockAll() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM $Table_Stock");

    List<PickingModel> list =
        res.isNotEmpty ? res.map((c) => PickingModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<Map>> queryAllRows() async {
    Database db = await instance.database;

    List<Map> res = await db.rawQuery('''
      SELECT $Table_Stock.$C_StockId as id, $Table_Stock.$C_StockCustomerName as namecustom, $Table_Stock.$C_StockName as namestock ,$Table_Stock.$C_StockDatePrevue as date_prevue, $Table_Stock.$C_StockDateEffective as date_effect, $Table_Stock.$C_StockState as state, $Table_Stock.$C_StockZone as zone
      FROM $Table_Stock
      
      ''');

    print("Le nombre d'enregistrement ${res.length}");
    return res.toList();
  }

  // Future<List<Map>> getStockByUser(int user_id) async {
  //   Database db = await instance.database;

  //   List<Map> res = await db.rawQuery('''
  //     SELECT $Table_Stock.$C_StockId as id,$Table_Stock.customer_id as id_cient_st,$Table_Customer.id as client_id, $TableSaleOrder.$SaleName as SaleName,$Table_Customer.$C_CustomerName as namecustom, $Table_Customer.$C_CustomerLieu as lieu, $Table_Stock.$C_StockName as namestock ,$Table_Stock.$C_StockDatePrevue as date_prevue, $Table_Stock.$C_StockDateEffective as date_effect, $Table_Stock.$C_StockState as state, $Table_Zone.$C_ZoneLieu as zone
  //     FROM $Table_Stock
  //     LEFT JOIN $Table_Customer ON $Table_Stock.customer_id = $Table_Customer.id
  //     LEFT JOIN $Table_Delivery_Stock ON $Table_Stock.$C_StockDeliveryId = $Table_Delivery_Stock.$C_StockDeliID
  //     LEFT JOIN $Table_Zone ON $Table_Stock.$C_StockZoneId = $Table_Zone.$C_ZoneId
  //     LEFT JOIN $TableSaleOrder ON $Table_Stock.$C_StockSaleId = $TableSaleOrder.$SaleId

  //     ORDER BY id DESC;

  //     ''');

  //   print("Le nombre d'enregistrement ${res.length}");
  //   return res.toList();
  // }

  Future<List<Map>> getStockByUser(int user_id) async {
    Database db = await instance.database;

    List<Map> res = await db.rawQuery('''
      SELECT $Table_Stock.$C_StockId as id, $Table_Stock.$C_StockCustomerName as namecustom,$Table_Stock.$C_StockDeliAgentID as id_user, $Table_Stock.$C_StockSaleOrderName as SaleName, $Table_Stock.$C_StockName as namestock ,$Table_Stock.$C_StockDatePrevue as date_prevue, $Table_Stock.$C_StockDateEffective as date_effect, $Table_Stock.$C_StockState as state, $Table_Stock.$C_StockZone as zone, $Table_Stock.$C_StockAmountTotal as amount_total, $Table_Stock.$C_StockAmountPaid as amount_paid
      FROM $Table_Stock
      WHERE ($Table_Stock.$C_StockDeliAgentID = $user_id)
      ORDER BY id DESC;

      ''');

    print("Le nombre d'enregistrement ${res.length}");
    return res.toList();
  }

//   Future<List<Map>> getStockByUser(int user_id) async {
//     final db = await database;
//     var res = await db.rawQuery('''
//       SELECT $Table_Stock.$C_StockId as id, $Table_Customer.$C_CustomerName as namecustom, $Table_Customer.$C_CustomerLieu as lieu, $Table_Stock.$C_StockName as namestock ,$Table_Stock.$C_StockDatePrevue as date_prevue, $Table_Stock.$C_StockDateEffective as date_effect, $Table_Stock.$C_StockState as state, $Table_Zone.$C_ZoneLieu as zone      FROM $Table_Stock
//       INNER JOIN $Table_Customer ON $Table_Stock.customer_id = $Table_Customer.id
//       INNER JOIN $Table_Delivery_Stock ON $Table_Stock.$C_StockDeliveryId = $Table_Delivery_Stock.$C_StockDeliID
//       INNER JOIN $Table_Zone ON $Table_Stock.$C_StockZoneId = $Table_Zone.$C_ZoneId
//       WHERE ($Table_Delivery_Stock.$C_StockDeliAgent = $user_id)

// ''');
//     // print("Le nombre d'enregistrement ${res.length}");
//     return res.toList();
//   }

  // PRODUIT

  // Stock Move Line

  createStockLine(StockLineModel newStockL) async {
    final db = await database;
    final res = await db.insert(
      Table_StockLine,
      newStockL.toJson(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Option pour l'insertion ou le remplacement
    );
    return res;
  }

  DetailStock(int stockid) async {
    var dbClient = await instance.database;
    var res_stock = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        "$C_StockId = $stockid");
    return res_stock.first;
  }

  Future<PickingModel?> detailStock(int stock_id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        "$C_StockId = $stock_id");

    if (res.length > 0) {
      return PickingModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> gettockLine(int stockid) async {
    final db = await database;
    var res = await db.rawQuery('''
      SELECT $Table_StockLine.$C_StockLineId as id,$Table_StockLine.$C_StockProduct as product, $Table_StockLine.$C_StockLineAmountTva as amount_tva, $Table_StockLine.$C_StockLineAmountBic as amount_bic, $Table_StockLine.$C_StockLineTotalAmountBic as total_bic, $Table_StockLine.$C_StockLineTotalAmountTva as total_tva, $Table_StockLine.$C_StockLinePackQty as pack_qty, $Table_StockLine.$C_StockLinePackQtyDone as pack_qty_done, $Table_StockLine.$C_StockLinePricePack as price_unit, $Table_StockLine.$C_StockLinePriceSubtotal as price_subtotal, $Table_StockLine.$C_StockLinePriceTotal as price_total,$Table_StockLine.$C_StockLineState as state , $Table_Stock.$C_StockDeliAgentID as user_id, $Table_Stock.$C_StockId as stock_id
      FROM $Table_StockLine
      INNER JOIN $Table_Stock
      ON $Table_StockLine.$C_StockLinePickingId = $Table_Stock.$C_StockId

      WHERE $Table_StockLine.$C_StockLinePickingId = $stockid

''');

    return res;
  }

  Future<List<Map<String, dynamic>>> gettockLineID(int id) async {
    final db = await database;
    var res = await db.rawQuery('''
      SELECT $Table_StockLine.$C_StockLineId as id,$Table_StockLine.$C_StockProduct as product,  $Table_StockLine.$C_StockLineAmountBic as amount_bic, $Table_StockLine.$C_StockLineAmountTva as amount_tva, $Table_StockLine.$C_StockLinePackQty as pack_qty, $Table_StockLine.$C_StockLinePackQtyDone as pack_qty_done, $Table_StockLine.$C_StockLinePricePack as price_pack, $Table_StockLine.$C_StockLinePriceSubtotal as price_subtotal,$Table_StockLine.$C_StockLineState as state , $Table_Stock.$C_StockDeliAgentID as user_id, $Table_Stock.$C_StockId as stock_id
      FROM $Table_StockLine
      INNER JOIN $Table_Stock 
      ON $Table_StockLine.$C_StockLinePickingId = $Table_Stock.$C_StockId

      WHERE $Table_StockLine.id = $id

''');

    return res;
  }

  Future<PickingModel?> getStockId(int id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        "$C_StockId = '$id'");

    if (res.length > 0) {
      return PickingModel.fromMap(res.first);
    }
    return null;
  }

  Future<int> updatestockid(PickingModel data) async {
    final db = await database;
    // var sql = '''
    //   UPDATE $Table_StockLine
    //   SET $C_StockLineQteFait = ?
    //   WHERE $C_StockLineId = ?
    // ''',[data.qte_fait, data.id];
    return await db.update(Table_Stock, data.toMap(),
        where: '$C_StockId = ?', whereArgs: [data.id]);
  }

  Future<Map<dynamic, dynamic>?> updateStock(int stock) async {
    final db = await database;
    List<Map> res = await db.rawQuery('''
      SELECT $Table_Stock.$C_StockId as id, $Table_Stock.$C_StockSaleOrderId as sale_order_id, $Table_Stock.$C_StockSaleOrderName as sale_order_name, $Table_Stock.$C_StockCustomerId as custom_id, $Table_Stock.$C_StockCustomerName as namecustom, $Table_Stock.$C_StockName as namestock ,$Table_Stock.$C_StockDatePrevue as date_prevue, $Table_Stock.$C_StockDateEffective as date_effect, $Table_Stock.$C_StockState as state, $Table_Stock.$C_StockZone as zone, $Table_Stock.$C_StockDeliAgentID as delivery_agent_id, $Table_Stock.$C_StockDeliAgentName as delivery_agent_name, $Table_Stock.$C_StockAmountTotal as amounttotal
      FROM $Table_Stock

      WHERE $Table_Stock.$C_StockId = $stock

''');

    if (res.length > 0) {
      return res.first;
    }
    return null;
  }

  Future<int> updatestoclines(StockLineModel data) async {
    final db = await database;
    return await db.update(Table_StockLine, data.toMap(),
        where: '$C_StockLineId = ?', whereArgs: [data.id]);
  }

  Future<int> updateStockLineWithNewId(StockLineModel data, int newId) async {
    final db = await database;

    // Set the new ID on the StockLineModel object
    data.id = newId;

    return await db.update(Table_StockLine, data.toMap(),
        where: '$C_StockProduct = ? and $C_StockLinePickingId = ?',
        whereArgs: [data.product, data.picking_id]);
  }

  Future<StockLineModel?> getStockLineId(int id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_StockLine WHERE "
        "$C_StockLineId = '$id'");

    if (res.length > 0) {
      return StockLineModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  Future<int> StockMoveLineSend(
    int id,
    String is_done,
  ) async {
    var dbClient = await database;
    return await dbClient.rawUpdate(
        "UPDATE $Table_StockLine SET $C_StockLineIsDone = ? WHERE id = ?",
        [id, is_done]);
  }

  Future<StockLineModel?> getStockLineStockId(int id) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_StockLine WHERE "
        "id = $id");

    if (res.length > 0) {
      return StockLineModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  Future<int> StockPickingSend(
    int id,
    String is_done,
  ) async {
    var dbClient = await database;
    return await dbClient.rawUpdate(
        'UPDATE $Table_Stock SET $C_StockValidate = ? WHERE $C_StockId = ?',
        [id, is_done]);
  }

  Future<Map<dynamic, dynamic>?> getInfoForCash(int stock) async {
    final db = await database;
    List<Map> res = await db.rawQuery('''
      SELECT $Table_Stock.$C_StockId as picking_id, $Table_Stock.$C_StockSaleOrderId as sale_id, $Table_Stock.$C_StockDeliAgentID as user_id, $Table_Stock.$C_StockZone as zone, $Table_Stock.customer_id as partner_id, $Table_Stock.$C_StockAmountTotal as amounttotal
      FROM $Table_Stock
      WHERE $Table_Stock.$C_StockId = $stock

''');

    if (res.length > 0) {
      return res.first;
    }
    return null;
  }

  Future<int> updateCashId(CashModel data) async {
    final db = await database;
    // var sql = '''
    //   UPDATE $Table_StockLine
    //   SET $C_StockLineQteFait = ?
    //   WHERE $C_StockLineId = ?
    // ''',[data.qte_fait, data.id];
    return await db.update(TableCash, data.toMap(),
        where: '$CashId = ?', whereArgs: [data.id]);
  }

  Future<int> updateCash(
    int id,
    double amount,
    double receive,
    double receveiveEspece,
    double receiveCheque,
    double change,
  ) async {
    var dbClient = await database;
    return await dbClient.rawUpdate(
        'UPDATE $TableCash SET $CashAmount = $amount, $CashReceiveAmount = $receive, $CashReceiveCheque = $receiveCheque,$CashReceiveEspece = $receveiveEspece,$Cashchange = $change, WHERE $CashId = $id');
  }

  Future<int> updateCashSend(
    int id,
    String is_done,
  ) async {
    var dbClient = await database;
    return await dbClient.rawUpdate(
        'UPDATE $TableCash SET $CashIsDone = $is_done, WHERE $CashId = $id');
  }

  Future<StockLineModel?> writingStockLine(int id, String state) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_StockLine WHERE "
        "$C_StockLineId = '$id' AND $C_StockLineState = '$state' ");

    if (res.length > 0) {
      return StockLineModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  Future<StockLineModel?> writingStockLineCancel(int id, String state) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_StockLine WHERE "
        "$C_StockLineId = '$id' AND $C_StockLineState = '$state' ");

    if (res.length > 0) {
      return StockLineModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  static Future<List<StockLineModel>> detailStocking(int PickingId) async {
    var dbClient = await instance.database;
    final commandList = await dbClient.query(Table_StockLine,
        where: " $C_StockLinePickingId = ?",
        whereArgs: [PickingId],
        orderBy: "id DESC ");
    return commandList.map((data) => StockLineModel.fromJson(data)).toList();
  }

  Future<PickingModel?> writingStock(int id, String state) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        "$C_StockId = '$id' AND $C_StockState = '$state' ");

    if (res.length > 0) {
      return PickingModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  Future<PickingModel?> writingStockCancel(int id, String state) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        "$C_StockId = '$id' AND $C_StockState = '$state' ");

    if (res.length > 0) {
      return PickingModel.fromMap(res.first);
    }
    return null;
    // return StockLineModel.fromMap(res.first);
  }

  Future<CashModel?> getCasDone(int user_id, int sale_id, int partner_id,
      int picking_id, String state) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $TableCash WHERE "
        "$CashPartner = $partner_id AND $CashSale = $sale_id AND $CashUser = $user_id AND $CashPicking = $picking_id AND $CashState = '$state'");

    if (res.length > 0) {
      return CashModel.fromMap(res.first);
    }
    return null;
  }

  Future CashAll() async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $TableCash WHERE "
        " $CashState = 'done' AND $CashIsDone = 'non' ");

    List<CashModel> list =
        res.isNotEmpty ? res.map((c) => CashModel.fromJson(c)).toList() : [];
    return list;
  }

  Future StockAll() async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Stock WHERE "
        " $C_StockState IN ('done','cancel') AND $C_StockValidate = 'non' ORDER BY $C_StockId DESC");

    List<PickingModel> list =
        res.isNotEmpty ? res.map((c) => PickingModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PickingModel>> StockAllLastThreeDays() async {
    var dbClient = await instance.database;

    // Obtenez la date d'il y a trois jours
    var now = DateTime.now();
    var threeDaysAgo = now.subtract(Duration(days: 3));

    // Formatez les dates pour les comparer dans la requête SQL
    var formattedNow = DateFormat('yyyy-MM-dd').format(now);
    var formattedThreeDaysAgo = DateFormat('yyyy-MM-dd').format(threeDaysAgo);

    // Utilisez la clause WHERE pour récupérer les enregistrements des trois derniers jours
    var res = await dbClient.rawQuery(
        "SELECT * FROM $Table_Stock WHERE $C_StockState IN ('done','cancel') AND "
        "$C_StockDatePrevue BETWEEN '$formattedThreeDaysAgo' AND '$formattedNow' "
        "ORDER BY $C_StockId DESC");

    List<PickingModel> list =
        res.isNotEmpty ? res.map((c) => PickingModel.fromJson(c)).toList() : [];
    return list;
  }

  Future StockLineAll() async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_StockLine WHERE "
        " $C_StockState = 'done' AND $C_StockLineIsDone = 'non' ORDER BY $C_StockLineId DESC ");

    List<StockLineModel> list = res.isNotEmpty
        ? res.map((c) => StockLineModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<StockLineModel>> StockLineAllLastThreeDays() async {
    var dbClient = await instance.database;
    // Utilisez la clause WHERE pour récupérer les enregistrements des trois derniers jours
    var res = await dbClient.rawQuery(
        "SELECT * FROM $Table_StockLine WHERE $C_StockLineState = 'done'"
        "ORDER BY $C_StockLineId DESC");

    List<StockLineModel> list = res.isNotEmpty
        ? res.map((c) => StockLineModel.fromJson(c)).toList()
        : [];
    return list;
  }
}
