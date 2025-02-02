import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final List<String> _pin = [];
  String? storedPin;
  bool _isPinSet = false;

  @override
  void initState() {
    super.initState();
    _checkIfPinSet();
  }

  Future<void> _checkIfPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    storedPin = prefs.getString('pin');
    setState(() {
      _isPinSet = storedPin != null;
    });
  }

  Future<void> _registerPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', _pin.join());
    _navigateToHomeScreen();
  }

  void _onNumberPress(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(number);
      });
    }
    if (_pin.length == 4) {
      if (!_isPinSet) {
        _registerPin();
      } else {
        String enteredPin = _pin.join();
        if (enteredPin == storedPin) {
          _navigateToHomeScreen();
        } else {
          _onPinFailure();
        }
        setState(() {
          _pin.clear();
        });
      }
    }
  }

  void _onPinFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pin Code Буруу байна.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Handle delete press
  void _onDeletePress() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  // Navigate to Home Screen
  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_pattern_1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.2),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Пин код',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: !_isPinSet
                      ? Text(
                          'Цаашид ашиглах нууц кодоо оруулна уу!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        )
                      : Text(
                          'Pin code-оо оруулж нэвтэрнэ үү!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        _pin.length > index
                            ? Icons.circle
                            : Icons.circle_outlined,
                        color:
                            _pin.length > index ? Colors.black : Colors.black26,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildNumberPad(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _pin.clear();
                        });
                      },
                      child: const Text(
                        'Болих',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the number pad
  Widget _buildNumberPad() {
    return Column(
      children: [
        for (var row in [1, 4, 7]) _buildNumberRow(row),
        _buildLastRow(),
      ],
    );
  }

  // Build a row of number buttons
  Widget _buildNumberRow(int start) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        int number = start + index;
        return _buildNumberButton(number.toString());
      }),
    );
  }

  // Build the last row with '0' and delete button
  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 40),
        _buildNumberButton('0'),
        IconButton(
          icon: const Icon(Icons.backspace_outlined),
          onPressed: _onDeletePress,
          color: Colors.black54,
        ),
      ],
    );
  }

  // Build the individual number button
  Widget _buildNumberButton(String number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _onNumberPress(number),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
