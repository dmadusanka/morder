import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Container(
                child: SfSignaturePad(
                  minimumStrokeWidth: 2,
                  maximumStrokeWidth: 5,
                  strokeColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text('Done'),
                  onPressed: () {},
                ),
              ))
        ],
      ),
    );
  }
}
