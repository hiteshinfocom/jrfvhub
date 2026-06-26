import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String drawingNo;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.drawingNo,
  });

  @override
  State<PdfViewerScreen> createState() =>
      _PdfViewerScreenState();
}

class _PdfViewerScreenState
    extends State<PdfViewerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.drawingNo,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: widget.pdfUrl.isEmpty
          ? const Center(
              child: Text(
                "PDF Not Available",
              ),
            )
          : SfPdfViewer.network(
              widget.pdfUrl,
              password: '123',
            ),
    );
  }
}