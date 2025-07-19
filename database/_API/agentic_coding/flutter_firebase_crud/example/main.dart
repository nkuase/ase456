import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_crud.dart';
import '../lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: FirebaseCrudDemo(),
    );
  }
}

class FirebaseCrudDemo extends StatefulWidget {
  @override
  _FirebaseCrudDemoState createState() => _FirebaseCrudDemoState();
}

class _FirebaseCrudDemoState extends State<FirebaseCrudDemo> {
  final ExampleService _exampleService = ExampleService();
  final TextEditingController _fooController = TextEditingController();
  final TextEditingController _barController = TextEditingController();
  List<ExampleModel> _items = [];
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _fooController.dispose();
    _barController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final result =
        await _exampleService.readAll(orderBy: 'createdAt', descending: true);

    result.fold(
      onSuccess: (items) {
        setState(() {
          _items = items;
          _status = 'Loaded ${items.length} items';
        });
      },
      onError: (error) {
        setState(() {
          _status = 'Error: $error';
        });
      },
    );
  }

  Future<void> _createItem() async {
    final foo = _fooController.text.trim();
    final barText = _barController.text.trim();

    if (foo.isEmpty || barText.isEmpty) {
      setState(() {
        _status = 'Please fill in both fields';
      });
      return;
    }

    final bar = int.tryParse(barText);
    if (bar == null) {
      setState(() {
        _status = 'Bar must be a valid integer';
      });
      return;
    }

    final newItem = ExampleModel(foo: foo, bar: bar);
    final result = await _exampleService.create(newItem);

    result.fold(
      onSuccess: (id) {
        setState(() {
          _status = 'Created item with ID: $id';
        });
        _fooController.clear();
        _barController.clear();
        _loadItems();
      },
      onError: (error) {
        setState(() {
          _status = 'Error creating item: $error';
        });
      },
    );
  }

  Future<void> _updateItem(ExampleModel item) async {
    final updatedItem = item.copyWith(
      foo: '${item.foo} (updated)',
      bar: item.bar + 1,
    );

    final result = await _exampleService.update(item.id!, updatedItem);

    result.fold(
      onSuccess: (_) {
        setState(() {
          _status = 'Updated item: ${item.id}';
        });
        _loadItems();
      },
      onError: (error) {
        setState(() {
          _status = 'Error updating item: $error';
        });
      },
    );
  }

  Future<void> _deleteItem(ExampleModel item) async {
    final result = await _exampleService.delete(item.id!);

    result.fold(
      onSuccess: (_) {
        setState(() {
          _status = 'Deleted item: ${item.id}';
        });
        _loadItems();
      },
      onError: (error) {
        setState(() {
          _status = 'Error deleting item: $error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase CRUD Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Create Item Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create New Item',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),
                    TextField(
                      controller: _fooController,
                      decoration: InputDecoration(
                        labelText: 'Foo (String)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _barController,
                      decoration: InputDecoration(
                        labelText: 'Bar (Integer)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _createItem,
                      child: Text('Create Item'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Status
            Text(
              _status,
              style: TextStyle(
                color: _status.startsWith('Error') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            // Items List
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text('Items',
                              style: Theme.of(context).textTheme.headlineSmall),
                          Spacer(),
                          IconButton(
                            onPressed: _loadItems,
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _items.isEmpty
                          ? Center(child: Text('No items found'))
                          : ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                return ListTile(
                                  title: Text('Foo: ${item.foo}'),
                                  subtitle:
                                      Text('Bar: ${item.bar} | ID: ${item.id}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _updateItem(item),
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                        onPressed: () => _deleteItem(item),
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
