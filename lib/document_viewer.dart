import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DocumentViewer extends StatelessWidget {
  final Uint8List pdf;

  DocumentViewer({key, required this.pdf});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LimitedBox(
            maxHeight: 1000,
            child: PdfPreview(
              useActions: false,
              onError: (context, error) => CircularProgressIndicator(),
              build: (format) {
                debugPrint(format.toString());
                return pdf;
              },
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                  color: Colors.green,
                  minWidth: 150,
                  onPressed: () {},
                  child: Text(
                    "Upload",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
              MaterialButton(
                  color: Colors.grey,
                  minWidth: 150,
                  onPressed: () {},
                  child: Text("Cancel",
                      style: TextStyle(fontSize: 16, color: Colors.white))),
            ],
          ),
        )
      ],
    );
  }
}
