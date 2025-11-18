import 'package:flutter/material.dart';
import 'pin_entry_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  int _secretTapCount = 0;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        _num1 = double.tryParse(_output) ?? 0;
        _operation = buttonText;
        _currentInput = "";
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_currentInput) ?? 0;

        if (_operation == "+") {
          _output = (_num1 + _num2).toString();
        }
        if (_operation == "-") {
          _output = (_num1 - _num2).toString();
        }
        if (_operation == "×") {
          _output = (_num1 * _num2).toString();
        }
        if (_operation == "÷") {
          if (_num2 != 0) {
            _output = (_num1 / _num2).toString();
          } else {
            _output = "Error";
          }
        }

        _currentInput = _output;
        _operation = "";
        _num1 = 0;
        _num2 = 0;

        // Remove trailing .0 for whole numbers
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
      } else if (buttonText == "⌫") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? "0" : _currentInput;
        }
      } else {
        if (_currentInput == "0") {
          _currentInput = buttonText;
        } else {
          _currentInput += buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  void _onSecretTap() {
    setState(() {
      _secretTapCount++;
    });

    if (_secretTapCount >= 5) {
      _secretTapCount = 0;
      // Navigate to PIN entry screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PinEntryScreen()),
      );
    }

    // Reset counter after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _secretTapCount = 0;
        });
      }
    });
  }

  Widget _buildButton(
    String buttonText, {
    Color? color,
    Color? textColor,
    double? height,
  }) {
    return Expanded(
      child: Container(
        height: height ?? 70,
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Secret access button - tap 5 times quickly
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: _onSecretTap,
          ),
        ],
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Calculator buttons
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton(
                      "C",
                      color: Colors.grey[700],
                      textColor: Colors.white,
                    ),
                    _buildButton(
                      "⌫",
                      color: Colors.grey[700],
                      textColor: Colors.white,
                    ),
                    _buildButton(
                      "÷",
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton(
                      "×",
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton(
                      "-",
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton(
                      "+",
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton(
                      "=",
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
