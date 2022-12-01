import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DocumentViewer extends StatelessWidget {
  final pdf;

  const DocumentViewer({super.key, required this.pdf});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: true,
        ),
        body: LimitedBox(
            maxHeight: 1000,
            child: PdfPreview(
              useActions: false,
              onError: (context, error) => CircularProgressIndicator(),
              build: (format) => pdf,
            )));
  }
}
