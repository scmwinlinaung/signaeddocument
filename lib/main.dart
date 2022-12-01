import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:printing/printing.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/src/pdf/document_parser.dart';
import 'package:signaturepad/document.dart';
import 'package:signaturepad/signed_document.dart';
import 'package:signaturepad/document_viewer.dart';
import 'package:signaturepad/report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.landscapeLeft]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _MyHomePageState extends State<MyHomePage> {
  ByteData _img = ByteData(0);
  Uint8List _pdf = Uint8List(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  final pdf = pw.Document();
  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

    return filePath;
  }

  // Future<Uint8List> readFile() async {
  //   File file = File(await getFilePath()); // 1
  //   debugPrint("FILLEEE");
  //   String fileContent = await file.readAsString(encoding: latin1); // 2

  //   return await file.readAsBytes();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder(
              future: generateDocument(PdfPageFormat.letter),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as Uint8List;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
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
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Signature(
                color: color,
                key: _sign,
                onSign: () {
                  final sign = _sign.currentState;
                },
                // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                strokeWidth: strokeWidth,
              ),
            ),
            color: Colors.black12,
          ),
          if (_pdf.buffer.lengthInBytes == 0)
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: Colors.green,
                        onPressed: () async {
                          final sign = _sign.currentState;
                          //retrieve image data, do whatever you want with it (send to server, save locally...)
                          final image = await sign!.getData();
                          var data = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          sign.clear();
                          final encoded =
                              base64.encode(data!.buffer.asUint8List());
                          setState(() {
                            _img = data;
                          });
                          // debugPrint("onPressed " + encoded);

                          final signatureImage =
                              pw.MemoryImage(data!.buffer.asUint8List());

                          // final samplePdf = await rootBundle
                          //     .loadString('asset/pdf/signature.pdf');
                          // final pdf = pw.Document.load(pw.);
                          // pdf.editPage(
                          //   0, // index 0 for the first page
                          //   pw.Page(
                          //       build: (context) => pw.Center(
                          //             child: pw.Image(signatureImage),
                          //           )),
                          // );
                          // pdf.addPage(pw.Page(build: (pw.Context context) {
                          //   return pw.Center(
                          //     child: pw.Image(signatureImage),
                          //   ); // Center
                          // })); // Page

                          // final file = File(await getFilePath());

                          // await file.writeAsBytes(await pdf.save());
                          Uint8List fie = await generateSignedDocument(
                              PdfPageFormat.letter, signatureImage);
                          // setState(() {
                          //   _pdf = fie;
                          // });
                          // readFile();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentViewer(
                                      pdf: fie,
                                    )),
                          );
                        },
                        child: Text("Save")),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            color = color == Colors.green
                                ? Colors.red
                                : Colors.green;
                          });
                          debugPrint("change color");
                        },
                        child: Text("Change color")),
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            int min = 1;
                            int max = 10;
                            int selection = min + (Random().nextInt(max - min));
                            strokeWidth = selection.roundToDouble();
                            debugPrint("change stroke width to $selection");
                          });
                        },
                        child: Text("Change stroke width")),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
