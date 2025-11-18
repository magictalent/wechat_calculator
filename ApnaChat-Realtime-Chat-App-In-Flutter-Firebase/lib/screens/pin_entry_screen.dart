import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/apis.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';
import 'calculator_screen.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = "";
  bool _isSettingPin = false;
  String _confirmPin = "";
  bool _isConfirmingPin = false;

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('app_pin');

    setState(() {
      _isSettingPin = savedPin == null;
    });
  }

  Future<void> _onPinComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('app_pin');

    if (_isSettingPin) {
      if (!_isConfirmingPin) {
        // First PIN entry, ask for confirmation
        setState(() {
          _confirmPin = _pin;
          _isConfirmingPin = true;
          _pin = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please confirm your PIN')),
        );
      } else {
        // Confirming PIN
        if (_pin == _confirmPin) {
          await prefs.setString('app_pin', _pin);
          _navigateToApp();
        } else {
          setState(() {
            _pin = "";
            _confirmPin = "";
            _isConfirmingPin = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PINs do not match. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Verifying existing PIN
      if (_pin == savedPin) {
        _navigateToApp();
      } else {
        setState(() {
          _pin = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect PIN. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToApp() {
    // Check if user is logged in
    if (APIs.auth.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onNumberPressed(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == 4) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _onPinComplete();
        });
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onBackToCalculator() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CalculatorScreen()),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinDot(bool filled) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.blue : Colors.transparent,
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _onBackToCalculator,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Title
            Text(
              _isSettingPin
                  ? (_isConfirmingPin ? 'Confirm PIN' : 'Set Your PIN')
                  : 'Enter PIN',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              _isSettingPin
                  ? 'Create a 4-digit PIN to secure your chats'
                  : 'Enter your 4-digit PIN to continue',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),

            const SizedBox(height: 50),

            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPinDot(_pin.isNotEmpty),
                _buildPinDot(_pin.length >= 2),
                _buildPinDot(_pin.length >= 3),
                _buildPinDot(_pin.length >= 4),
              ],
            ),

            const SizedBox(height: 50),

            // Number pad
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton("1"),
                    _buildNumberButton("2"),
                    _buildNumberButton("3"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton("4"),
                    _buildNumberButton("5"),
                    _buildNumberButton("6"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton("7"),
                    _buildNumberButton("8"),
                    _buildNumberButton("9"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 86), // Empty space
                    _buildNumberButton("0"),
                    GestureDetector(
                      onTap: _onBackspacePressed,
                      child: Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.all(8),
                        child: const Center(
                          child: Icon(
                            Icons.backspace_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
