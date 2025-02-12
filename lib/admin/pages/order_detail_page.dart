import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final DateTime? timestamp = order['timestamp']?.toDate();
    final String formattedDate =
        timestamp != null ? DateFormat('yyyy-MM-dd').format(timestamp) : 'N/A';
    final String formattedTime =
        timestamp != null ? DateFormat('hh:mm:ss a').format(timestamp) : 'N/A';

    final String orderId = order['orderId'].toString();

    Future<pw.Document> generateOrderPdf(Map<String, dynamic> order) async {
      final pdf = pw.Document();

      // Define styles
      final headerStyle = pw.TextStyle(
        fontSize: 24,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue900,
      );

      final subtitleStyle = pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey800,
      );

      final bodyStyle = pw.TextStyle(
        fontSize: 14,
        color: PdfColors.grey700,
      );

      final totalStyle = pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.green800,
      );

      // Add a page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Order Receipt',
                        style: headerStyle,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Thank you for your purchase!',
                        style: bodyStyle.copyWith(
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Order Details
                pw.Text('Order ID: ${order['orderId']}', style: subtitleStyle),
                pw.SizedBox(height: 10),
                pw.Text('Date: $formattedDate', style: bodyStyle),
                pw.Text('Time: $formattedTime', style: bodyStyle),
                pw.SizedBox(height: 20),

                // Items Header
                pw.Text('Items:', style: subtitleStyle),
                pw.SizedBox(height: 10),

                // Items Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2), // Item Name
                    1: pw.FlexColumnWidth(1), // Quantity
                    2: pw.FlexColumnWidth(1), // Price
                    3: pw.FlexColumnWidth(1), // Total
                  },
                  children: [
                    // Table Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Item', style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Quantity', style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Price', style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Total', style: bodyStyle),
                        ),
                      ],
                    ),
                    // Table Rows
                    ...order['items']?.map<pw.TableRow>((item) {
                          final amount = item['quantity'] ?? 1;
                          final price = item['price']?.toDouble() ?? 0.0;
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child:
                                    pw.Text(item['itemName'], style: bodyStyle),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text('$amount', style: bodyStyle),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  '\$${price.toStringAsFixed(2)}',
                                  style: bodyStyle,
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  '\$${(price * amount).toStringAsFixed(2)}',
                                  style: bodyStyle,
                                ),
                              ),
                            ],
                          );
                        })?.toList() ??
                        [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text('No items found.',
                                    style: bodyStyle),
                              ),
                            ],
                          ),
                        ],
                  ],
                ),
                pw.SizedBox(height: 20),

                // Total
                pw.Center(
                  child: pw.Text(
                    'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: totalStyle,
                  ),
                ),

                // Footer
                pw.SizedBox(height: 30),
                pw.Center(
                  child: pw.Text(
                    'Contact us: support@example.com',
                    style: bodyStyle.copyWith(
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      return pdf;
    }

    Future<void> printOrderPdf(Map<String, dynamic> order) async {
      final pdf = await generateOrderPdf(order);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details for ID: $orderId',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time: $formattedTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Store: ${order['storeName'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...order['items']?.map<Widget>((item) {
                  final amount = item['quantity'] ?? 1;
                  final price = item['price']?.toDouble() ?? 0.0;
                  final imagePath = item['image'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: imagePath != null && imagePath.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(imagePath),
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.image),
                            ),
                      title: Text(
                        '$amount x ${item['itemName']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Price: \$${price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        'Total: \$${(price * amount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                })?.toList() ??
                [const Text('No items found.')],
            const SizedBox(height: 20),
            const Text(
              'Additional Information:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...order.entries.map<Widget>((entry) {
              if (entry.key == 'items' ||
                  entry.key == 'timestamp' ||
                  entry.key == 'documentId') {
                return const SizedBox.shrink();
              }
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await printOrderPdf(order);
        },
        child: const Icon(Icons.print),
      ),
    );
  }
}
