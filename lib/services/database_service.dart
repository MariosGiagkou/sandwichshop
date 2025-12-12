import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sandwich_shop/models/saved_order.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static Database? _database;
  static final List<SavedOrder> _memoryOrders = <SavedOrder>[];
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'sandwich_shop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            totalAmount REAL NOT NULL,
            itemCount INTEGER NOT NULL,
            orderDate INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(SavedOrder order) async {
    if (kIsWeb) {
      // Web fallback: store in memory to avoid unsupported sqflite on web
      final SavedOrder assigned = SavedOrder(
        id: _memoryOrders.isEmpty ? 1 : (_memoryOrders.last.id + 1),
        orderId: order.orderId,
        totalAmount: order.totalAmount,
        itemCount: order.itemCount,
        orderDate: order.orderDate,
      );
      _memoryOrders.add(assigned);
      return;
    }
    final Database db = await database;
    await db.insert('orders', order.toMap());
  }

  Future<List<SavedOrder>> getOrders() async {
    if (kIsWeb) {
      // Return a copy to avoid external mutation
      final List<SavedOrder> list = List<SavedOrder>.from(_memoryOrders);
      list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return list;
    }
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'orders',
      orderBy: 'orderDate DESC',
    );

    List<SavedOrder> orders = [];
    for (int i = 0; i < maps.length; i++) {
      orders.add(SavedOrder.fromMap(maps[i]));
    }
    return orders;
  }

  Future<void> deleteOrder(int id) async {
    if (kIsWeb) {
      _memoryOrders.removeWhere((o) => o.id == id);
      return;
    }
    final Database db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // // Save user profile (name & location) to Firestore.
  // // A generated profileId is used if none provided.
  // Future<String> saveUserProfile({
  //   String? profileId,
  //   required String name,
  //   required String location,
  // }) async {
  //   final String effectiveId = profileId ?? _generateProfileId(name, location);
  //   final DocumentReference<Map<String, dynamic>> doc =
  //       _firestore.collection('profiles').doc(effectiveId);
  //   await doc.set({
  //     'name': name,
  //     'location': location,
  //     'updatedAt': DateTime.now().toUtc().toIso8601String(),
  //   }, SetOptions(merge: true));
  //   return effectiveId;
  // }

  // String _generateProfileId(String name, String location) {
  //   final String base =
  //       '${name.trim().toLowerCase()}_${location.trim().toLowerCase()}';
  //   final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   return '${base}_$timestamp';
  // }
}
