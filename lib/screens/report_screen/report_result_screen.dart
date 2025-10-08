import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/screens/report_screen/report_table/report_table_2.dart';

class ReportResultScreen extends StatefulWidget {
  final ReportsResponse reportResponse;
  const ReportResultScreen({super.key, required this.reportResponse});

  @override
  State<ReportResultScreen> createState() => _ReportResultScreenState();
}

class _ReportResultScreenState extends State<ReportResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shiftwise Production Report')),
      body: Column(
        children: [
          Divider(height: 1, thickness: 0.2),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReportTableWidget2(reportResponse: widget.reportResponse),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // MainBtn(
                //   label: 'Export',
                //   onTap: () {
                //     _generateCsv(widget.reportResponse);
                //   },
                // ),
                // SizedBox(width: 12),
                MainBtn(
                  label: 'PDF',
                  onTap: () {
                    _generatePdf(widget.reportResponse);
                  },
                ),
                SizedBox(width: 12),
                MainBtn(
                  label: 'Close',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  // --- EXPORT FUNCTIONS ---

  // Helper function to save file content to the user's device (Web/Desktop compatible)
  void _saveFile(List<int> bytes, String fileName, String mimeType) async {
    final PermissionStatus permissionGranted = await Permission.storage
        .request();

    if (!permissionGranted.isGranted) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Storage permission denied. Cannot save file.'),
        ),
      );
      return;
    }

    try {
      Directory? directory = await getDownloadsDirectory();
      if (directory == null) {
        // Fallback or error if Downloads directory is unavailable (rare, but possible)
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Could not access the public Downloads directory.'),
          ),
        );
        return;
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      log('Using directory path: ${directory.path}');
      final filePath = '${directory.path}/$fileName';
      log('Using directory path: $filePath');

      final file = File(filePath);
      await file.writeAsBytes(bytes);
      OpenFile.open(filePath).then(
        (value) => log('File opened successfully: $filePath'),
        onError: (e) {
          log('Error opening file: $e');
        },
      );
    } catch (e) {
      log('Mobile/Desktop File Save Error: $e');
      // print('Mobile/Desktop File Save Error: $e');
    }
  }

  // Generate CSV data and trigger download
  // Future<void> _generateCsv(ReportsResponse report) async {
  //   final exportData = ReportTableWidget2.getExportData(report.data);
  //   final csvString = const ListToCsvConverter().convert(exportData);
  //   final bytes = utf8.encode(csvString);
  //   log('CSV Data:\n$csvString');
  //   _openFile(bytes, 'production_report.csv', 'text/csv');
  //   _saveFile(bytes, 'production_report.csv', 'text/csv');
  // }

  // _openFile(List<int> bytes, String fileName, String mimeType) async {
  //   try {
  //     final tempDir = await getTemporaryDirectory();
  //     final filePath = '${tempDir.path}/$fileName';
  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes);
  //     var result = await OpenFile.open(filePath);
  //     if (result.type != ResultType.done) {
  //       log('Error opening file: ${result.message}');
  //     } else {
  //       log('File opened successfully: $filePath');
  //     }
  //   } catch (e) {
  //     log('Error opening file: $e');
  //   }
  // }

  // Generate PDF document and trigger download
  Future<void> _generatePdf(ReportsResponse report) async {
    final pdf = pw.Document();
    final exportData = ReportTableWidget2.getExportData(report.data);

    // Determine column widths for PDF (proportional)
    final List<double> columnWidths = [
      2.0, 1.5, 1.0, 1.2, 1.2, 0.8, 1.2, 1.0, // Main columns
      ...List.generate(12, (_) => 0.8), // Stop columns
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat:
            PdfPageFormat.a3.landscape, // Wide format for the many columns
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, text: 'Production Report'),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: exportData.first,
              data: exportData.sublist(1),
              border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
                fontSize: 8,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF1D5C93),
              ),
              cellStyle: const pw.TextStyle(fontSize: 7),
              columnWidths: Map.fromEntries(
                List.generate(
                  columnWidths.length,
                  (i) => MapEntry(i, pw.FlexColumnWidth(columnWidths[i])),
                ),
              ),
              cellAlignment: pw.Alignment.center,
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    _saveFile(bytes.toList(), 'production_report.pdf', 'application/pdf');
  }
}
