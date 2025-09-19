import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String output = "0";

  String replacePercentages(String expr) {
    final regex = RegExp(r'(\d+(\.\d+)?)%');
    return expr.replaceAllMapped(regex, (match) {
      double value = double.parse(match.group(1)!);
      return (value / 100).toString();
    });
  }

  void buttonPressed(String button) {
    setState(() {
      if (button == "AC") {
        expression = "";
        output = "0";
      } else if (button == "=") {
        try {
          String finalExp = expression.replaceAll("×", "*").replaceAll("÷", "/");
          finalExp = replacePercentages(finalExp);
          final parser = ShuntingYardParser();
          Expression exp = parser.parse(finalExp);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString();
          expression = output;
          if (eval.isInfinite || eval.isNaN) {
            output = "Error";
            expression = "";
          } else {
            output = eval.toString();
            expression = output;
          }
        } catch (e) {
          output = "Error";
        }
      } else if (button == "+/-") {
        if (expression.isNotEmpty) {
          if (expression.startsWith("-")) {
            expression = expression.substring(1);
          } else {
            expression = "-$expression";
          }
          output = expression;
        }
      } else if (button == "%") {
        if (expression.isNotEmpty) {
          expression += "%"; // append % symbol
          expression = replacePercentages(expression); // convert all % to decimals
          output = expression;
        }
      } else {
        expression += button;
        output = expression;
      }
    });
  }

  Widget buildButton(String text,
      {Color bgColor = Colors.grey, Color textColor = Colors.black, double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(vertical: 22),
            backgroundColor: bgColor,
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  output,
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.w200),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            
            Column(
              children: [
                Row(
                  children: [
                    buildButton("AC", bgColor: Colors.grey.shade300),
                    buildButton("+/-", bgColor: Colors.grey.shade300),
                    buildButton("%", bgColor: Colors.grey.shade300),
                    buildButton("÷", bgColor: Colors.orange, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("7", bgColor: Colors.grey.shade100),
                    buildButton("8", bgColor: Colors.grey.shade100),
                    buildButton("9", bgColor: Colors.grey.shade100),
                    buildButton("×", bgColor: Colors.orange, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("4", bgColor: Colors.grey.shade100),
                    buildButton("5", bgColor: Colors.grey.shade100),
                    buildButton("6", bgColor: Colors.grey.shade100),
                    buildButton("-", bgColor: Colors.orange, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("1", bgColor: Colors.grey.shade100),
                    buildButton("2", bgColor: Colors.grey.shade100),
                    buildButton("3", bgColor: Colors.grey.shade100),
                    buildButton("+", bgColor: Colors.orange, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    buildButton("0", bgColor: Colors.grey.shade100, flex: 2),
                    buildButton(".", bgColor: Colors.grey.shade100),
                    buildButton("=", bgColor: Colors.orange, textColor: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
