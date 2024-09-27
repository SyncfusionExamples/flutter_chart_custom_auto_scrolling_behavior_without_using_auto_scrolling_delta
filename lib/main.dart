import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTimeCategoryAxisController? _xAxisRenderer;

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableMouseWheelZooming: true,
    enablePanning: true,
  );

  final List<ChartData> chartData = [
    ChartData(DateTime(2023, 01, 01), 35),
    ChartData(DateTime(2023, 01, 02), 28),
    ChartData(DateTime(2023, 01, 03), 34),
    ChartData(DateTime(2023, 01, 04), 32),
    ChartData(DateTime(2023, 01, 05), 42),
    ChartData(DateTime(2023, 01, 06), 35),
    ChartData(DateTime(2023, 01, 07), 28),
    ChartData(DateTime(2023, 01, 08), 34),
    ChartData(DateTime(2023, 01, 09), 32),
    ChartData(DateTime(2023, 01, 10), 42),
    ChartData(DateTime(2023, 01, 11), 35),
    ChartData(DateTime(2023, 01, 12), 28),
    ChartData(DateTime(2023, 01, 13), 34),
    ChartData(DateTime(2023, 01, 14), 32),
    ChartData(DateTime(2023, 01, 15), 42),
    ChartData(DateTime(2023, 01, 16), 35),
    ChartData(DateTime(2023, 01, 17), 28),
    ChartData(DateTime(2023, 01, 18), 34),
    ChartData(DateTime(2023, 01, 19), 32),
    ChartData(DateTime(2023, 01, 20), 42),
  ];

  String dropdownValue = 'Start';
  final TextEditingController _textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTimeCategoryAxis'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
              primaryXAxis: DateTimeCategoryAxis(
                dateFormat: DateFormat.d(),
                onRendererCreated: (DateTimeCategoryAxisController controller) {
                  _xAxisRenderer = controller;
                },
                initialVisibleMinimum: DateTime(2023, 1, 1),
                initialVisibleMaximum: DateTime(2023, 1, 20),
              ),
              series: <LineSeries<ChartData, DateTime>>[
                LineSeries<ChartData, DateTime>(
                  animationDuration: 0,
                  dataSource: chartData,
                  xValueMapper: (ChartData chartData, int index) => chartData.x,
                  yValueMapper: (ChartData chartData, int index) => chartData.y,
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Text input for the number of days
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 30,
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter Days',
                      ),
                    ),
                  ),
                ),
              ),

              // Dropdown to select Start or End
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Start', 'End']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Button to apply the range
              ElevatedButton(
                onPressed: () {
                  int days = int.tryParse(_textController.text) ?? 1;
                  // Ensure valid range
                  days = days.clamp(1, chartData.length);
                  if (dropdownValue == 'Start') {
                    // Adjust for Start button
                    _xAxisRenderer?.visibleMinimum = chartData[0].x;
                    _xAxisRenderer?.visibleMaximum = chartData[days - 1].x;
                  } else {
                    // Adjust for End button
                    _xAxisRenderer?.visibleMinimum =
                        chartData[chartData.length - days].x;

                    _xAxisRenderer?.visibleMaximum = chartData.last.x;
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  DateTime x;
  int y;
}
