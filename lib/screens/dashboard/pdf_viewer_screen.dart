import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter/services.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String drawingNo;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.drawingNo,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _downloading = false;

  final PdfViewerController _pdfController = PdfViewerController();

  int _currentPage = 1;
  int _totalPages = 0;

  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();

    debugPrint("PdfViewerScreen initState");
    debugPrint("PDF URL: ${widget.pdfUrl}");
  }

  Future<void> _downloadPdf() async {
  if (widget.pdfUrl.isEmpty) return;

  setState(() {
    _downloading = true;
  });

  FileDownloader.downloadFile(
    url: widget.pdfUrl,
    name: "${widget.drawingNo}.pdf",

    onDownloadCompleted: (String path) {
      if (!mounted) return;

      setState(() {
        _downloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("PDF Downloaded"),
          action: SnackBarAction(
            label: "OPEN",
            onPressed: () {
              OpenFilex.open(path);
            },
          ),
        ),
      );
    },

    onDownloadError: (String error) {
      if (!mounted) return;

      setState(() {
        _downloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    debugPrint("PdfViewerScreen build");

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF202124),

        titleSpacing: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.drawingNo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              "$_currentPage / $_totalPages",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),

          ],
        ),

        actions: [

          IconButton(
            tooltip: "Download",
            onPressed: _downloading ? null : _downloadPdf,
            icon: _downloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download),
          ),

          IconButton(
            tooltip: "Fullscreen",
            onPressed: () {
              setState(() {
                _isFullscreen = !_isFullscreen;
              });

              if (_isFullscreen) {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                );
              } else {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.edgeToEdge,
                );
              }
            },
            icon: Icon(
              _isFullscreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == "download") {
                _downloadPdf();
              }
            },
            itemBuilder: (context) => const [

              PopupMenuItem(
                value: "download",
                child: Text("Download PDF"),
              ),

            ],
          ),

        ],
      ),
      body: widget.pdfUrl.isEmpty
          ? const Center(
              child: Text("PDF Not Available"),
            )
          : SfPdfViewer.network(
        widget.pdfUrl,
        controller: _pdfController,
        password: "J123@#",

        onDocumentLoaded: (details) {
          setState(() {
            _totalPages = details.document.pages.count;
          });
        },

        onPageChanged: (details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
      ),
    );
  }
}