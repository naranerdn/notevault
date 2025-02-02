import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeChangeScreen extends StatefulWidget {
  @override
  _PinCodeChangeScreenState createState() => _PinCodeChangeScreenState();
}

class _PinCodeChangeScreenState extends State<PinCodeChangeScreen> {
  final List<String> _pin = [];
  String? storedPin;
  bool isConfirmingNewPin = false;
  bool isSettingNewPin = false;
  String newPin = "";

  @override
  void initState() {
    super.initState();
    _loadStoredPin();
  }

  Future<void> _loadStoredPin() async {
    final prefs = await SharedPreferences.getInstance();
    storedPin = prefs.getString('pin');
  }

  Future<void> _updatePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  void _onNumberPress(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(number);
      });
    }

    if (_pin.length == 4) {
      String enteredPin = _pin.join();

      if (!isSettingNewPin && !isConfirmingNewPin) {
        // Verify current PIN
        if (enteredPin == storedPin) {
          setState(() {
            isSettingNewPin = true;
            _pin.clear();
          });
        } else {
          _onPinFailure('Одоогийн PIN код буруу байна.');
          setState(() {
            _pin.clear();
          });
        }
      } else if (isSettingNewPin) {
        // Set new PIN
        setState(() {
          newPin = enteredPin;
          isSettingNewPin = false;
          isConfirmingNewPin = true;
          _pin.clear();
        });
      } else if (isConfirmingNewPin) {
        // Confirm new PIN
        if (enteredPin == newPin) {
          _updatePin(newPin);
          _onSuccess('PIN код амжилттай шинэчлэгдлээ.');
          Navigator.pop(context);
        } else {
          _onPinFailure('Шинэ PIN код таарахгүй байна.');
          setState(() {
            isConfirmingNewPin = false;
            _pin.clear();
          });
        }
      }
    }
  }

  void _onPinFailure(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onDeletePress() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              !isSettingNewPin && !isConfirmingNewPin
                  ? 'Одоогийн PIN кодоо оруулна уу'
                  : isSettingNewPin
                      ? 'Шинэ PIN кодоо оруулна уу'
                      : 'Шинэ PIN кодоо баталгаажуулна уу',
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    _pin.length > index ? Icons.circle : Icons.circle_outlined,
                    color: _pin.length > index ? Colors.black : Colors.black26,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildNumberPad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        for (var row in [1, 4, 7]) _buildNumberRow(row),
        _buildLastRow(),
      ],
    );
  }

  Widget _buildNumberRow(int start) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        int number = start + index;
        return _buildNumberButton(number.toString());
      }),
    );
  }

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
