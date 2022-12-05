import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'pdf_editor_service.dart';
import 'dart:ui' as ui;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignaturePad extends StatefulWidget {
  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  Uint8List _pdf = Uint8List(0);
  bool edit = false;
  ByteData _img = ByteData(0);
  final _sign = GlobalKey<SignatureState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            // future: generateDocument(PdfPageFormat.letter),
            future:
                PdfMutableDocument.readFile("asset/pdf/board-resolution.pdf"),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as Uint8List;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: PdfPreview(
                      useActions: false,
                      // pdfPreviewPageDecoration: BoxDecoration(),
                      onError: (context, error) => CircularProgressIndicator(),
                      build: (format) => data,
                    ),
                  ),
                );
              }
              return const CircularProgressIndicator();
            })),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Signature(
              color: Colors.black,
              key: _sign,
              onSign: () {
                final sign = _sign.currentState;
              },
              // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
              strokeWidth: 3,
            ),
          ),
          color: Colors.black12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                color: Colors.green,
                onPressed: () async {
                  final sign = _sign.currentState;
                  //retrieve image data, do whatever you want with it (send to server, save locally...)
                  final image = await sign!.getData();
                  var data =
                      await image.toByteData(format: ui.ImageByteFormat.png);
                  sign.clear();
                  // final encoded = base64.encode(data!.buffer.asUint8List());
                  setState(() {
                    _img = data!;
                  });
                  // debugPrint("onPressed " + encoded);

                  var fie = await PdfMutableDocument.sign(
                      "asset/pdf/board-resolution.pdf",
                      data!.buffer.asUint8List());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => CorpActionStepper(pdf: fie)),
                  // );
                },
                child: Text("Sign")),
            MaterialButton(
                color: Colors.grey,
                onPressed: () {
                  final sign = _sign.currentState;
                  sign!.clear();
                  setState(() {
                    _img = ByteData(0);
                  });
                  debugPrint("cleared");
                },
                child: Text("Clear")),
          ],
        ),
      ],
    );
  }
}
