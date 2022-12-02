// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_signature_pad/flutter_signature_pad.dart';
//

// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/src/pdf/document_parser.dart';
// import 'package:signaturepad/document.dart';
// import 'package:signaturepad/signed_document.dart';
// import 'package:signaturepad/document_viewer.dart';
// import 'package:signaturepad/report.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await SystemChrome.setPreferredOrientations(
//   //     [DeviceOrientation.landscapeLeft]);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _WatermarkPaint extends CustomPainter {
//   final String price;
//   final String watermark;

//   _WatermarkPaint(this.price, this.watermark);

//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
//         Paint()..color = Colors.blue);
//   }

//   @override
//   bool shouldRepaint(_WatermarkPaint oldDelegate) {
//     return oldDelegate != this;
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is _WatermarkPaint &&
//           runtimeType == other.runtimeType &&
//           price == other.price &&
//           watermark == other.watermark;

//   @override
//   int get hashCode => price.hashCode ^ watermark.hashCode;
// }

// class _MyHomePageState extends State<MyHomePage> {
//   ByteData _img = ByteData(0);
//   Uint8List _pdf = Uint8List(0);
//   var color = Colors.red;
//   var strokeWidth = 2.0;
//   final _sign = GlobalKey<SignatureState>();

//   final pdf = pw.Document();
//   Future<String> getFilePath() async {
//     Directory appDocumentsDirectory =
//         await getApplicationDocumentsDirectory(); // 1
//     String appDocumentsPath = appDocumentsDirectory.path; // 2
//     String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

//     return filePath;
//   }

//   Future<Uint8List> readFile() async {
//     File tempFile = File(await getFilePath());
//     ByteData bd = await rootBundle.load('asset/pdf/signature.pdf');
//     File file =
//         await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);

//     // String fileContent = await file.readAsString(encoding: latin1); // 2

//     return await file.readAsBytes();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   // Document _generateDocument() {
//   //   final pdf = new PdfDocument(deflate: zlib.encode);
//   //   final page = new PdfPage(pdf, pageFormat: PDFPageFormat.A4);
//   //   final g = page.getGraphics();
//   //   final font = new PdfFont(pdf);
//   //   final top = page.pageFormat.height;

//   //   g.setColor(new PdfColor(0.0, 1.0, 1.0));
//   //   g.drawRect(50.0 * PdfPageFormat.cm, top - 80.0 * PdfPageFormat.cm,
//   //       100.0 * PdfPageFormat.cm, 50.0 * PdfPageFormat.cm);
//   //   g.fillPath();

//   //   g.setColor(new PdfColor(0.3, 0.3, 0.3));
//   //   g.drawString(font, 12.0, "Hello World!", 10.0 * PdfPageFormat.cm,
//   //       top - 10.0 * PdfPageFormat.cm);

//   //   return pdf;
//   // }
//   //   Future savePdf() async {
//   //   Directory documentDirectory = await getApplicationDocumentsDirectory();
//   //   String documentPath = documentDirectory.path;
//   //   File receiptFile = File("$documentPath/receipt.pdf");
//   //   receiptFile.writeAsBytesSync(List.from(await pdf.save()));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           FutureBuilder(
//               // future: generateDocument(PdfPageFormat.letter),
//               future: generateDocument(PdfPageFormat.letter),
//               builder: ((context, snapshot) {
//                 if (snapshot.hasData) {
//                   final data = snapshot.data as Uint8List;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       child: PdfPreview(
//                         useActions: false,
//                         // pdfPreviewPageDecoration: BoxDecoration(),
//                         onError: (context, error) =>
//                             CircularProgressIndicator(),
//                         build: (format) => data,
//                       ),
//                     ),
//                   );
//                 }
//                 return const CircularProgressIndicator();
//               })),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.25,
//             width: MediaQuery.of(context).size.width * 0.95,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Signature(
//                 color: color,
//                 key: _sign,
//                 onSign: () {
//                   final sign = _sign.currentState;
//                 },
//                 // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
//                 strokeWidth: strokeWidth,
//               ),
//             ),
//             color: Colors.black12,
//           ),
//           if (_pdf.buffer.lengthInBytes == 0)
//             Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MaterialButton(
//                         color: Colors.green,
//                         onPressed: () async {
//                           final sign = _sign.currentState;
//                           //retrieve image data, do whatever you want with it (send to server, save locally...)
//                           final image = await sign!.getData();
//                           var data = await image.toByteData(
//                               format: ui.ImageByteFormat.png);
//                           sign.clear();
//                           final encoded =
//                               base64.encode(data!.buffer.asUint8List());
//                           setState(() {
//                             _img = data;
//                           });
//                           // debugPrint("onPressed " + encoded);

//                           final signatureImage =
//                               pw.MemoryImage(data!.buffer.asUint8List());

//                           // File tempFile = File(await getFilePath());
//                           // ByteData bd =
//                           //     await rootBundle.load('asset/pdf/signature.pdf');
//                           // await tempFile.writeAsBytes(bd.buffer.asUint8List(),
//                           //     flush: true);
//                           final fileData = await readFile();
//                           debugPrint("LENGTH");
//                           debugPrint(fileData.length.toString());

//                           final ByteData data1 =
//                               await rootBundle.load('asset/pdf/signature.pdf');
//                           final pdf = pw.Document.load(
//                             CustomPdf(data1.buffer.asUint8List(),
//                                 data1.lengthInBytes, data1.offsetInBytes),
//                           );

//                           pdf.addPage(pw.Page(
//                               pageFormat: PdfPageFormat.letter,
//                               build: (pw.Context context) {
//                                 return pw.Center(
//                                   child: pw.Image(signatureImage),
//                                 ); // Center
//                               }));

//                           pdf.editPage(
//                             0, // index 0 for the first page
//                             pw.Page(
//                                 pageFormat: PdfPageFormat.letter,
//                                 build: (context) => pw.Align(
//                                     alignment: pw.Alignment.centerRight,
//                                     child: pw.Container(
//                                       width: 200,
//                                       height: 200,
//                                       child: pw.Image(signatureImage),
//                                     ))),
//                           );

//                           // final file = File(await getFilePath());

//                           // await file.writeAsBytes(await pdf.save());

//                           Uint8List fie = await generateSignedDocument(
//                               PdfPageFormat.letter, signatureImage);

//                           // setState(() {
//                           //   _pdf = fie;
//                           // });
//                           // readFile();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DocumentViewer(
//                                       pdf: fie,
//                                     )),
//                           );
//                         },
//                         child: Text("Sign")),
//                     MaterialButton(
//                         color: Colors.grey,
//                         onPressed: () {
//                           final sign = _sign.currentState;
//                           sign!.clear();
//                           setState(() {
//                             _img = ByteData(0);
//                           });
//                           debugPrint("cleared");
//                         },
//                         child: Text("Clear")),
//                   ],
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: <Widget>[
//                 //     MaterialButton(
//                 //         onPressed: () {
//                 //           setState(() {
//                 //             color = color == Colors.green
//                 //                 ? Colors.red
//                 //                 : Colors.green;
//                 //           });
//                 //           debugPrint("change color");
//                 //         },
//                 //         child: Text("Change color")),
//                 //     MaterialButton(
//                 //         onPressed: () {
//                 //           setState(() {
//                 //             int min = 1;
//                 //             int max = 10;
//                 //             int selection = (Random().nextInt(max - min));
//                 //             strokeWidth = selection.roundToDouble();
//                 //             debugPrint("change stroke width to $selection");
//                 //           });
//                 //         },
//                 //         child: Text("Change stroke width")),
//                 //   ],
//                 // ),
//               ],
//             )
//         ],
//       ),
//     );
//   }
// }

// class CustomPdf extends PdfDocumentParserBase {
//   final int lengthInBytes;
//   final int offsetInBytes;
//   CustomPdf(super.bytes, this.lengthInBytes, this.offsetInBytes);

//   @override
//   void mergeDocument(PdfDocument pdfDocument) {
//     // TODO: implement mergeDocument
//   }

//   @override
//   // TODO: implement size
//   int get size => lengthInBytes;

//   @override
//   // TODO: implement xrefOffset
//   int get xrefOffset => offsetInBytes;
// }

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'document_viewer.dart';
import 'pdf_editor_service.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

//
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Edit Pdf Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List _pdf = Uint8List(0);
  bool edit = false;
  ByteData _img = ByteData(0);
  final _sign = GlobalKey<SignatureState>();
  // void _edit() async {
  // PdfMutableDocument doc =
  //     await PdfMutableDocument.asset("asset/pdf/company_registration.pdf");
  // _editDocument(doc);
  // await doc.save(filename: "modified.pdf");

  // print("PDF Edition Done");
  // }

  Future<Uint8List> _editDocument(
      PdfMutableDocument document, dynamic signatureImage) async {
    var page = document.getPage(await document.getPageCount(
            assetName: "asset/pdf/company_registration.pdf") -
        1);
    page.add(
        item: pdfWidget.Positioned(
            right: 0.0,
            bottom: 0.0,
            child: pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Container(
                  width: 220,
                  height: 220,
                  child: pw.Image(signatureImage),
                ))));
    return await document.save(filename: "modified.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          FutureBuilder(
              // future: generateDocument(PdfPageFormat.letter),
              future: PdfMutableDocument.readFile(
                  filename: "asset/pdf/company_registration.pdf"),
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

                    final signatureImage =
                        pw.MemoryImage(data!.buffer.asUint8List());

                    PdfMutableDocument doc = await PdfMutableDocument.asset(
                        "asset/pdf/company_registration.pdf");
                    var fie = await _editDocument(doc, signatureImage);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentViewer(
                                pdf: fie,
                              )),
                    );
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
      ),
    );
  }
}
