import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const AutoScrolling(),
    ),
  );
}

class AutoScrolling extends StatefulWidget {
  const AutoScrolling({super.key});

  @override
  State<AutoScrolling> createState() => _AutoScrollingState();
}

class _AutoScrollingState extends State<AutoScrolling> {
  DateTimeCategoryAxisController? _xAxisRenderer;
  late List<ChartData> chartData;

  String dropdownValue = 'Start';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeChartData();
  }

  void _initializeChartData() {
    chartData = [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Auto-scrolling behavior without using the autoScrollingDelta property in Flutter Chart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCartesianChart(
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextField(),
                _buildDropdown(),
                _buildApplyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Text input for the number of days
  Widget _buildTextField() {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: _textController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Enter Days',
        ),
      ),
    );
  }

  // Dropdown to select Start or End
  Widget _buildDropdown() {
    return DropdownButton<String>(
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
    );
  }

  // Button to apply the range
  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        int days = int.tryParse(_textController.text) ?? 1;
        days = days.clamp(1, chartData.length);
        if (dropdownValue == 'Start') {
          _xAxisRenderer?.visibleMinimum = chartData[0].x;
          _xAxisRenderer?.visibleMaximum = chartData[days - 1].x;
        } else {
          _xAxisRenderer?.visibleMinimum = chartData[chartData.length - days].x;
          _xAxisRenderer?.visibleMaximum = chartData.last.x;
        }
      },
      child: const Text('Apply'),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  DateTime x;
  int y;
}
