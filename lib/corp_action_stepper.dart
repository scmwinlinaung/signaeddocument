import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signaturepad/signature_pad.dart';

import 'document_viewer.dart';

class CorpActionStepper extends StatefulWidget {
  const CorpActionStepper({Key? key}) : super(key: key);

  @override
  State<CorpActionStepper> createState() => _CorpActionStepperState();
}

class _CorpActionStepperState extends State<CorpActionStepper> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Text("HELLO"),
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: 0,
        steps: [
          Step(title: Text(""), content: SignaturePad()),
          Step(title: Text(""), content: Text("HI"))
        ],
        controlsBuilder: _controlButtonsInStepper,
      ),
    );
  }

  Widget _controlButtonsInStepper(
    BuildContext context,
    ControlsDetails details,
  ) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            height: 50.0,
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              onPressed: details.onStepCancel,
              child: const Text("Cancel"),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            height: 50.0,
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              child: const Text("Continue"),
            ),
          ),
        ),
      ],
    );
  }
}
