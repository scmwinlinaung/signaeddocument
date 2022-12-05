import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;

class PdfRawImage extends pdfWidgets.ImageProvider {
  final Uint8List data;
  final Size size;
  late pdf.PdfDocument document;

  PdfRawImage({required this.data, required this.size})
      : super(size.width.toInt(), size.height.toInt(),
            pdf.PdfImageOrientation.topLeft, 72.0);

  @override
  pdf.PdfImage buildImage(pdfWidgets.Context context,
      {int? width, int? height}) {
    return pdf.PdfImage.file(
      document,
      bytes: data,
      orientation: orientation,
    );
  }
}

class _PdfFileHandler {
  static Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);
    final byteData = await rootBundle.load(filename);

    var name = filename.split(Platform.pathSeparator).last;
    // final dir = Platform.isIOS
    //     ? await getLibraryDirectory()
    //     : getApplicationDocumentsDirectory();
    var absoluteName =
        '${(await getApplicationDocumentsDirectory()).path}/$name';

    final file = File(absoluteName);

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  static Future<List<PdfRawImage>> loadPdf(String path) async {
    var file = pdfRender.PdfImageRendererPdf(path: path);
    await file.open();
    var count = await file.getPageCount();
    List<PdfRawImage> images = [];
    for (var i = 0; i < count; i++) {
      var size = await file.getPageSize(pageIndex: 0);
      var rawImage = await file.renderPage(
        background: Colors.transparent,
        x: 0,
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1.0,
        pageIndex: i,
      );
      images.add(PdfRawImage(
        data: rawImage,
        size: Size(size.width.toDouble(), size.height.toDouble()),
      ));
    }
    return images;
  }

  static Future<int> getPageCount(String path) async {
    var file = pdfRender.PdfImageRendererPdf(path: path);
    await file.open();
    var count = await file.getPageCount();
    return count;
  }

  static Future<Uint8List> save(pdfWidgets.Document document, String filename,
      {String? directory}) async {
    // final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    // final file = File('$dir${Platform.pathSeparator}$filename');
    return await document.save();
  }

  static Future<Uint8List> readFile(String assetName,
      {String? directory}) async {
    final byteData = await rootBundle.load(assetName);

    return byteData.buffer.asUint8List();
  }

  static Future<Uint8List> sign(
      String assetname, dynamic signatureImage) async {
    PdfMutableDocument document = await PdfMutableDocument.asset(assetname);
    var page = document.getPage(await document.getPageCount(assetname) - 1);
    page.add(
        item: pdfWidgets.Positioned(
            right: 0.0,
            bottom: 0.0,
            child: pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Container(
                  width: 220,
                  height: 220,
                  child: pw.Image(signatureImage),
                ))));

    return document.save("modified.pdf");
  }
}

class PdfMutablePage {
  final PdfRawImage _background;
  final List<pdfWidgets.Widget> _stackedItems;

  PdfMutablePage({required PdfRawImage background})
      : _background = background,
        _stackedItems = [];

  void add({required pdfWidgets.Widget item}) {
    _stackedItems.add(item);
  }

  Size get size => _background.size;

  pdfWidgets.Page build(pdfWidgets.Document document) {
    _background.document = document.document;
    final format =
        pdf.PdfPageFormat(_background.size.width, _background.size.height);
    return pdfWidgets.Page(
        pageFormat: format,
        orientation: pdfWidgets.PageOrientation.portrait,
        build: (context) {
          return pdfWidgets.Stack(
            children: [
              pdfWidgets.Image(_background),
              ..._stackedItems,
            ],
          );
        });
  }
}

// class PdfImageProvider extends ImageProvider {
//   @override
//   ImageStreamCompleter load(
//       Object key,
//       Future<Codec> Function(Uint8List bytes,
//               {bool allowUpscaling, int cacheHeight, int cacheWidth})
//           decode) {
//     // TODO: implement load
//     throw UnimplementedError();
//   }

//   @override
//   Future<Object> obtainKey(ImageConfiguration configuration) {
//     // TODO: implement obtainKey
//     throw UnimplementedError();
//   }
// }

class PdfMutableDocument {
  final List<PdfMutablePage> _pages;

  PdfMutableDocument._(
      {required List<PdfMutablePage> pages, required String filePath})
      : _pages = pages;

  static Future<PdfMutableDocument> asset(String assetName) async {
    var copy = await _PdfFileHandler.getFileFromAssets(assetName);
    final rawImages = await _PdfFileHandler.loadPdf(copy.path);

    final pages =
        rawImages.map((raw) => PdfMutablePage(background: raw)).toList();
    return PdfMutableDocument._(
        pages: pages, filePath: copy.uri.pathSegments.last);
  }

  void addPage(PdfMutablePage page) => _pages.add(page);

  PdfMutablePage getPage(int index) => _pages[index];

  pdfWidgets.Document build() {
    var doc = pdfWidgets.Document();
    for (var page in _pages) {
      doc.addPage(page.build(doc));
    }
    return doc;
  }

  Future<Uint8List> save(String filename) async {
    return _PdfFileHandler.save(build(), filename);
  }

  Future<int> getPageCount(String assetName) async {
    var copy = await _PdfFileHandler.getFileFromAssets(assetName);
    return _PdfFileHandler.getPageCount(copy.path);
  }

  static Future<Uint8List> readFile(String assetname) async {
    return _PdfFileHandler.readFile(assetname);
  }

  static Future<Uint8List> sign(
      String assetname, Uint8List signatureImage) async {
    return _PdfFileHandler.sign(assetname, pw.MemoryImage(signatureImage));
  }
}
