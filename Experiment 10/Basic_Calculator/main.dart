import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CalculatorApp());
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
      home: const CalculatorScreen(),
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
  Database? _database;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  // Initialize SQLite database
  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'calculator_history.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT,
            result TEXT
          )
        ''');
      },
    );
  }

  Future<void> _addToHistory(String exp, String res) async {
    await _database?.insert('history', {'expression': exp, 'result': res});
  }

  Future<List<Map<String, dynamic>>> _getHistory() async {
    return await _database?.query('history', orderBy: 'id DESC') ?? [];
  }

  Future<void> _clearHistory() async {
    await _database?.delete('history');
  }

  // Firestore write
  Future<void> _addToFirestoreHistory(String exp, String res) async {
    try {
      await _firestore.collection('history').add({
        'expression': exp,
        'result': res,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding to Firestore: $e');
    }
  }

  // Button press handler
  void buttonPressed(String button) {
    setState(() {
      if (button == "AC") {
        expression = "";
        output = "0";
      } else if (button == "=") {
        try {
          String finalExp = expression.replaceAll("×", "*").replaceAll("÷", "/");
          final parser = ShuntingYardParser();
          Expression exp = parser.parse(finalExp);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString();
          expression = output;
          _addToHistory(finalExp, output); // SQLite
          _addToFirestoreHistory(finalExp, output); // Firestore
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
      } else {
        expression += button;
        output = expression;
      }
    });
  }

  // Calculator button widget
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
            padding: const EdgeInsets.symmetric(vertical: 22),
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

  // Show history in bottom sheet popup
  Future<void> _showHistoryPopup() async {
    final history = await _getHistory();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.45,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calculation History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () async {
                        await _clearHistory();
                        Navigator.of(sheetContext).pop(); // dismiss modal
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: history.isEmpty
                    ? const Center(child: Text('No history yet'))
                    : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(history[index]['expression']),
                      subtitle: Text('= ${history[index]['result']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Display output
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      output,
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w200),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Buttons
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
            // History button at top-left
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.history, size: 28),
                onPressed: _showHistoryPopup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}