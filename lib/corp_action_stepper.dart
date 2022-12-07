import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signaturepad/share_issuance_resolution.dart';
import 'package:signaturepad/share_issuance_enactment.dart';
import 'package:signaturepad/share_subscription_agreement.dart';
import 'package:signaturepad/share_transfer_agreement.dart';
import 'package:signaturepad/share_transfer_enactment.dart';
import 'package:signaturepad/signature_pad.dart';

import 'document_viewer.dart';

class CorpActionStepper extends StatefulWidget {
  const CorpActionStepper({Key? key}) : super(key: key);

  @override
  State<CorpActionStepper> createState() => _CorpActionStepperState();
}

class _CorpActionStepperState extends State<CorpActionStepper> {
  int currentStep = 0;
  List<Map<String, dynamic>> stepsList = [];

  @override
  void initState() {
    stepsList = [
      {'title': '', 'body': ShareTransferAgreement()},
      {'title': '', 'body': const ShareTransferEnactment()},
      {'title': '', 'body': ShareSubscriptionAgreement()},
      {'title': '', 'body': ShareIssuanceResolution()},
      {'title': '', 'body': ShareIssuanceEnactment()}
    ];
    super.initState();
  }

  void _onStepTap(int changedStep) {
    setState(() {
      currentStep = changedStep;
    });
  }

  void _onStepContinue() {
    setState(() {
      currentStep = ++currentStep;
    });
    // switch (currentStep) {
    //   case 0:
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Text("HELLO"),
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: currentStep,
        steps: stepsList
            .map((step) => Step(
                  isActive: currentStep == stepsList.indexOf(step),
                  // state: currentStep > stepsList.indexOf(step)
                  //     ? StepState.complete
                  //     : StepState.disabled,
                  title: const Text(''),
                  content: step["body"],
                ))
            .toList(),
        onStepTapped: _onStepTap,
        onStepContinue: _onStepContinue,
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
