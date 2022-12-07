import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:signaturepad/document/share_transfer_agreement_document.dart';

import '../document/share_subscription_document.dart';
import '../pdf_editor_service.dart';

import 'ec_textfield_widget.dart';
import 'dart:ui' as ui;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:printing/printing.dart';

class ShareTransferAgreementForm extends StatefulWidget {
  @override
  State<ShareTransferAgreementForm> createState() =>
      _ShareTransferAgreementFormState();
}

class _ShareTransferAgreementFormState
    extends State<ShareTransferAgreementForm> {
  final nameCtrl = TextEditingController();

  final gmailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final _sign = GlobalKey<SignatureState>();
  Uint8List _signDoc = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ECTextfieldWidget(
            controller: nameCtrl,
            title: 'name',
            hint: '',
            textInputType: TextInputType.number,
            maxLength: 20,
            maxLines: 1,
            validator: null),
        ECTextfieldWidget(
            controller: gmailCtrl,
            title: 'gmail',
            hint: '',
            textInputType: TextInputType.number,
            maxLength: 20,
            maxLines: 1,
            validator: null),
        ECTextfieldWidget(
            controller: phoneCtrl,
            title: 'phone',
            hint: '',
            textInputType: TextInputType.number,
            maxLength: 20,
            maxLines: 1,
            validator: null),
        const Text(
          "Investor's sign",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Signature(
              color: Color.fromRGBO(0, 0, 0, 1),
              key: _sign,
              onSign: () {
                final sign = _sign.currentState;
              },
              strokeWidth: 3,
            ),
          ),
          color: Colors.black12,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     MaterialButton(
        //         color: Colors.green,
        //         onPressed: () async {},
        //         child: Text("Sign")),
        //     MaterialButton(
        //         color: Colors.grey, onPressed: () {}, child: Text("Clear")),
        //   ],
        // ),
        MaterialButton(
            color: Colors.green,
            child: Text("Generate"),
            onPressed: () async {
              final sign = _sign.currentState;
              //retrieve image data, do whatever you want with it (send to server, save locally...)
              final image = await sign!.getData();
              var data = await image.toByteData(format: ui.ImageByteFormat.png);
              sign.clear();
              // final encoded = base64.encode(data!.buffer.asUint8List());

              // debugPrint("onPressed " + encoded);
              var signedDocument = await generateShareTransferSignedDocument(
                PdfPageFormat.letter,
                pw.MemoryImage(data!.buffer.asUint8List()),
                nameCtrl.text,
                gmailCtrl.text,
                phoneCtrl.text,
              );
              setState(() {
                _signDoc = signedDocument;
              });
            }),
        if (_signDoc.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: PdfPreview(
                useActions: false,
                // pdfPreviewPageDecoration: BoxDecoration(),
                onError: (context, error) => CircularProgressIndicator(),
                build: (format) => _signDoc,
              ),
            ),
          )
      ],
    );
  }
}
