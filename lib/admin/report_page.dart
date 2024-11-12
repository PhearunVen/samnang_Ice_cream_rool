import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Page'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Apply the gradientCategory here
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height:
                          200, // Set the height to match the legend's total height
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200, // Same height as the container
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sections: _buildPieChartSections(),
                                    centerSpaceRadius: 60,
                                    sectionsSpace: 5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent),
                                      ),
                                      const Text(
                                        '\$2.4M', // Main amount text
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green[
                                              100], // Background color for percentage text
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          '+20%', // Percentage text
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width: 16), // Space between chart and legend
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(
                                  Colors.green, 'Completed', '\$200.8K', '41%'),
                              _buildLegendItem(
                                  Colors.orange, 'Returned', '\$101.2K', '25%'),
                              _buildLegendItem(
                                  Colors.red, 'Failed', '\$40K', '12%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReportItem("TOTAL", "\$2.4M", "+20%",
                      Colors.green[100]!, Colors.green),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildReportItem("COMPLETED", "\$200.8K", "-10%",
                      Colors.red[100]!, Colors.red),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildReportItem("RETURNED", "\$101.2K", "+31%",
                      Colors.green[100]!, Colors.green),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildReportItem(
                      "FAILED", "\$40K", "-4%", Colors.red[100]!, Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
        color: Colors.orange,
        value: 30,
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 80,
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 30,
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];
  }
}

Widget _buildLegendItem(
    Color color, String title, String amount, String percentage) {
  return SizedBox(
    height: 40,
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 20),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          ' ($percentage)',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

Widget _buildReportItem(String title, String amount, String percentage,
    Color bgColor, Color textColor) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        amount,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          percentage,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
