import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StudentGridView(),
    );
  }
}

// Simple GridView example
class StudentGridView extends StatelessWidget {
  final List<String> students = const [
    'Alice Johnson',
    'Bob Smith',
    'Carol Davis',
    'David Wilson',
    'Emma Brown',
    'Frank Miller',
    'Grace Lee',
    'Henry Taylor',
    'Ivy Chen',
    'Jack Wilson',
    'Kate Davis',
    'Liam Garcia',
    'Maya Patel',
    'Noah Kim',
    'Olivia Wang',
    'Paul Jones',
    'Quinn Adams',
    'Ruby Clark',
    'Sam White',
    'Tara Singh',
    'Uma Sharma',
    'Victor Lopez',
    'Wendy Zhou',
    'Xavier Hunt',
    'Yara Ali',
    'Zoe Martin',
    'Aaron Scott',
    'Bella Reed',
    'Carlos Diaz',
    'Diana Yu',
    'Ethan Brooks',
    'Fiona Grey',
    'Gabriel Ross',
    'Hannah Cole',
    'Ian Foster',
    'Julia Bell',
    'Kevin Price',
    'Luna Cruz',
    'Mason Wells',
    'Nora Hayes',
    // ... hundreds more students can be added here
  ];

  const StudentGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Grid'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items in each row
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
            childAspectRatio: 0.8, // Aspect ratio of each grid item
          ),
          itemCount: students.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      students[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${1000 + index}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}