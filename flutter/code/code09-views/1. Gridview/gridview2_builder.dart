import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentGridView()
    );
  }
}

// Simple GridView example
class StudentGridView extends StatelessWidget {
  final List<String> students = [
    'Alice Johnson', 'Bob Smith', 'Carol Davis', 'David Wilson',
    'Emma Brown', 'Frank Miller', 'Grace Lee', 'Henry Taylor',
    'Ivy Chen', 'Jack Wilson', 'Kate Davis', 'Liam Garcia',
    'Maya Patel', 'Noah Kim', 'Olivia Wang', 'Paul Jones',
    'Quinn Adams', 'Ruby Clark', 'Sam White', 'Tara Singh',
    'Uma Sharma', 'Victor Lopez', 'Wendy Zhou', 'Xavier Hunt',
    'Yara Ali', 'Zoe Martin', 'Aaron Scott', 'Bella Reed',
    'Carlos Diaz', 'Diana Yu', 'Ethan Brooks', 'Fiona Grey',
    'Gabriel Ross', 'Hannah Cole', 'Ian Foster', 'Julia Bell',
    'Kevin Price', 'Luna Cruz', 'Mason Wells', 'Nora Hayes',
    // ... hundreds more students can be added here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Grid'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      students[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
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


