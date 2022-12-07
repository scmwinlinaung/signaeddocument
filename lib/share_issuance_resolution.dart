import 'package:flutter/material.dart';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'pdf_editor_service.dart';
import 'dart:ui' as ui;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class ShareIssuanceResolution extends StatefulWidget {
  const ShareIssuanceResolution({Key? key}) : super(key: key);

  @override
  State<ShareIssuanceResolution> createState() =>
      _ShareIssuanceResolutionState();
}

class _ShareIssuanceResolutionState extends State<ShareIssuanceResolution> {
  Uint8List _pdf = Uint8List(0);
  bool edit = false;
  ByteData _img = ByteData(0);
  final _sign = GlobalKey<SignatureState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_pdf.isEmpty)
          FutureBuilder(
              // future: generateDocument(PdfPageFormat.letter),
              future: PdfMutableDocument.readFile(
                  "asset/pdf/share-holder-agreement.pdf"),
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
                        onError: (context, error) =>
                            CircularProgressIndicator(),
                        build: (format) => data,
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              })),
        if (_pdf.isNotEmpty)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: PdfPreview(
                    useActions: false,
                    onError: (context, error) => CircularProgressIndicator(),
                    build: (format) {
                      debugPrint(format.toString());
                      return _pdf;
                    },
                  ))),
        if (!edit)
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
        if (!edit)
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
                      "asset/pdf/share-holder-agreement.pdf",
                      data!.buffer.asUint8List(),
                      left: 45,
                      bottom: 100,
                    );
                    setState(() {
                      _pdf = fie;
                      edit = !edit;
                    });
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
        // if (edit)
        //   Padding(
        //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         MaterialButton(
        //             color: Colors.green,
        //             minWidth: 150,
        //             onPressed: () {},
        //             child: Text(
        //               "Upload",
        //               style: TextStyle(fontSize: 16, color: Colors.white),
        //             )),
        //         MaterialButton(
        //             color: Colors.grey,
        //             minWidth: 150,
        //             onPressed: () {},
        //             child: Text("Cancel",
        //                 style: TextStyle(fontSize: 16, color: Colors.white))),
        //       ],
        //     ),
        //   )
      ],
    );
  }
}
