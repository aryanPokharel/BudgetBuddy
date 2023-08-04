// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';





// class ShowBarChart extends StatefulWidget {
//   final List<double> dataPoints;

//   const ShowBarChart({Key key, @required this.dataPoints}) : super(key: key);

//   @override
//   State<ShowBarChart> createState() => _ShowBarChartState();
// }

// class _ShowBarChartState extends State<ShowBarChart> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Show Pie Chart'),
//       ),
//       body: Center(
//         child: BarChart(
//           BarChartData(
//             alignment: BarChartAlignment.center,
//             maxY: widget.dataPoints.reduce((a, b) => a > b ? a : b) * 1.2,
//             titlesData: FlTitlesData(
//               show: true,
//               bottomTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (value) => TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 margin: 16,
//                 getTitles: (double value) {
//                   // You can customize the bottom titles here, if needed.
//                   return '';
//                 },
//               ),
//               leftTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (value) => TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 margin: 16,
//                 reservedSize: 30,
//                 getTitles: (value) {
//                   if (value % 5 == 0) {
//                     return value.toString();
//                   }
//                   return '';
//                 },
//               ),
//             ),
//             borderData: FlBorderData(show: false),
//             barGroups: List.generate(
//               widget.dataPoints.length,
//               (index) => BarChartGroupData(
//                 x: index,
//                 barRods: [
//                   BarChartRodData(
//                     toY: widget.dataPoints[index],
//                     color: Colors.blue, // You can customize colors for each bar here.
//                     width: 16,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
