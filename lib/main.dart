import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.light(), 
      darkTheme: ThemeData.dark(), 
      themeMode: ThemeMode.system, 
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = ""; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.nights_stay),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildButtonGrid(),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Expanded(
      flex: 2,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, 
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        padding: EdgeInsets.all(16.0),
        itemCount: buttons.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildButton(buttons[index]);
        },
      ),
    );
  }

  Widget _buildButton(String buttonText) {
  return ElevatedButton(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(16)),
      shape: MaterialStateProperty.all(CircleBorder()),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.orange; 
          } else if (buttonText == '=') {
            return Colors.orange; 
          } else {
            return Colors.grey[200]; 
          }
        },
      ),
    ),
    onPressed: () {
      _onButtonPressed(buttonText);
    },
    child: Text(
      buttonText,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = "";
        _output = "0";
      } else if (buttonText == '⌫') {
        _expression = _expression.isNotEmpty
            ? _expression.substring(0, _expression.length - 1)
            : "";
        _output = _expression;
      } else if (buttonText == '=') {
        try {
          _output = _evaluateExpression(_expression);
          _expression = _output;
        } catch (e) {
          _output = "Error";
        }
      } else {
        _expression += buttonText;
        _output = _expression;
      }
    });
  }

  String _evaluateExpression(String expression) {
  try {
    Parser p = Parser();
    Expression exp = p.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm).toString();
  } catch (e) {
    return "Error";
  }
}
  final List<String> buttons = [
    'AC', '⌫', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', 
  ];
}
