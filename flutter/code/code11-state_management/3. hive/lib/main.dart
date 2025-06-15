// main.dart
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'util/dbhelper.dart';
import 'ui/showform.dart';
import 'ui/cardwidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('shopping_box');
  var name = 'shopping_box';
  await Hive.openBox(name);
  runApp(MyApp(dbname: name));
}

class MyApp extends StatelessWidget {
  String dbname;
  MyApp({Key? key, required this.dbname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASE285',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(dbname: dbname),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  String dbname;
  HomePage({Key? key, required this.dbname}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(dbname: dbname);
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> _items;
  late var db;
  late var show;
  String dbname;

  _HomePageState({required this.dbname}) {
    _items = [];
    db = Database(db: dbname);
    show = ShowForm(db: db, refreshItems: _refreshItems);
  }

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = db.toList();
    setState(
      () {
        _items = data.reversed.toList();
        show.updateItems(_items);
        // we use "reversed" to sort items in order from the latest to the oldest
      },
    );
  }

  void deleteItem(int key) {
    db.deleteItem(key);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASE456'),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return CardWidget(currentItem, show, deleteItem);
              },
            ),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await show.showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
