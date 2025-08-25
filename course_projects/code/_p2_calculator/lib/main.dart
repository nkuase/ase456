import 'package:p2_calculator/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userQuestion = '';
  String userAnswer = '0';

  final List buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    '*',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  void calculateExpression() {
    try {
      if (userQuestion.isEmpty) return;

      // ✅ Updated to current math_expressions API
      ExpressionParser parser = GrammarParser();
      Expression expression = parser.parse(userQuestion);

      var context = ContextModel();

      double result = expression.evaluate(EvaluationType.REAL, context);

      setState(() {
        userAnswer = _formatResult(result);
      });
    } catch (e) {
      setState(() {
        userAnswer = 'Error';
      });
    }
  }

  String _formatResult(num result) {
    // Remove unnecessary decimals
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }

  void pressedButton(String button) {
    setState(() {
      if (button == 'C') {
        userQuestion = '';
        userAnswer = '0';
      } else if (button == 'DEL') {
        if (userQuestion.isNotEmpty) {
          userQuestion = userQuestion.substring(0, userQuestion.length - 1);
        }
      } else if (button == '=') {
        calculateExpression();
      } else if (button == 'ANS') {
        userQuestion += userAnswer;
      } else {
        userQuestion += button;
      }
    });
  }

  bool _isOperator(String button) {
    return ['+', '-', '*', '/', '%'].contains(button);
  }

  bool _isSpecial(String button) {
    return ['C', 'DEL', '=', 'ANS'].contains(button);
  }

  Color _getButtonColor(String button) {
    if (button == '=') {
      return Colors.deepPurple[400]!;
    } else if (_isOperator(button)) {
      return Colors.deepPurple[300]!;
    } else if (_isSpecial(button)) {
      return Colors.deepPurple[200]!;
    } else {
      return Colors.deepPurple[100]!;
    }
  }

  Color _getTextColor(String button) {
    if (button == '=' || _isOperator(button)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Column(
        children: [
          // Display Section - Enhanced
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Input Section with Underline
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.deepPurple[300]!,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      userQuestion.isEmpty
                          ? 'Enter expression...'
                          : userQuestion,
                      style: TextStyle(
                        color: userQuestion.isEmpty
                            ? Colors.grey[400]
                            : Colors.deepPurple[800],
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  // Output Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      userAnswer,
                      style: TextStyle(
                        color: Colors.deepPurple[900],
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons Section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: buttons.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: buttons[index],
                    buttonColor: _getButtonColor(buttons[index]),
                    textColor: _getTextColor(buttons[index]),
                    function: () {
                      pressedButton(buttons[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

