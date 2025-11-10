import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/screens/report_screen/report_table/report_table_2.dart';
import 'package:trackweaving/utils/app_colors.dart';

class ReportResultScreen extends StatefulWidget {
  final ReportsResponse reportResponse;
  const ReportResultScreen({super.key, required this.reportResponse});

  @override
  State<ReportResultScreen> createState() => _ReportResultScreenState();
}

class _ReportResultScreenState extends State<ReportResultScreen> {
  RxBool isPDFLoading = false.obs;
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Obx(
                  () => isPDFLoading.value
                      ? Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              foregroundColor: AppColors.whiteColor,
                              disabledBackgroundColor: AppColors.mainColor,
                            ),
                            onPressed: null,
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        )
                      : MainBtn(
                          label: 'PDF',
                          onTap: () {
                            _generatePdf(widget.reportResponse);
                          },
                        ),
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

    //final bytes = await pdf.save();

    try {
      isPDFLoading.value = true;
      final String fileName =
          'shift_report_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Get a suitable directory for the file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');

      // Write the PDF bytes to the file
      await file.writeAsBytes(await pdf.save());

      // Use the printing package to share/open the file
      await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);

      Get.snackbar(
        'Success',
        'PDF generated and ready to share/save.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate or save PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPDFLoading.value = false;
    }
  }
}
