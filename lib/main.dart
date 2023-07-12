import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cow WebAPP',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FieldPage(),
    );
  }
}

class FieldPage extends StatefulWidget {
  @override
  _FieldPageState createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;

  void _showDatePicker(BuildContext context, bool isStartTime) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          if (isStartTime) {
            startTime = combinedDateTime;
          } else {
            endTime = combinedDateTime;
          }
        });
      }
    }
  }

  //download data
  void _downloadData() {
    //if (startTime != null && endTime != null) {
    //final int startTimeEpoch = startTime!.millisecondsSinceEpoch ~/ 1000;
    //final int endTimeEpoch = endTime!.millisecondsSinceEpoch ~/ 1000;
    print('Device ID: ${deviceIdController.text}');
    print('Start Epoch Time: ${startTimeController.text}');
    print('End Epoch Time : ${endTimeController.text}');
    //print('Start Time Epoch: $startTimeEpoch');
    //print('End Time Epoch: $endTimeEpoch');

    final jsonData = {
      'DeviceID': deviceIdController.text,
      'StartTime': startTimeController.text,
      'EndTime': endTimeController.text,
    };

    final csvContent = convertToCsv([jsonData]);
    _saveCsvFile(csvContent);
    //}
  }

  void fetchDataAndPrint() async {
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      printData(jsonData);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void printData(dynamic jsonData) {
    final encodedData = json.encode(jsonData);
    final decodedData = json.decode(encodedData);

    if (decodedData is List) {
      for (var item in decodedData) {
        printRow(item);
      }
    } else if (decodedData is Map) {
      printRow(decodedData);
    } else {
      print('Invalid JSON data');
    }
  }

  void printRow(Map<dynamic, dynamic> data) {
    data.forEach((key, value) {
      print('$key: $value');
    });
    print('---------------------------------');
  }

//Fetch and download data 3 .json(working)
  void fetchDataAndDownload() async {
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      const fileName = 'cow_data.json'; // Specify the file name and extension

      //final decodedData = json.decode(jsonData);
      //final csvData = ListToCsvConverter().convert(decodedData);

      final anchor = html.AnchorElement(
          href:
              'data:text/plain;charset=utf-8,${Uri.encodeComponent(jsonData)}')
        ..setAttribute('download', fileName)
        ..click();

      fetchDataAndPrint();
      //jsonData.forEach((int jsonData) => print(jsonData));

      //print(jsonData);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  String convertToCsv(List<Map<String, dynamic>> dataList) {
    if (dataList.isEmpty) return '';

    final headers = dataList.first.keys.toList();
    final rows = dataList.map((data) => data.values.toList()).toList();

    final List<List<dynamic>> csvData = [];
    csvData.add(headers);
    csvData.addAll(rows);

    final csvContent = const ListToCsvConverter().convert(csvData);
    return csvContent;
  }

  Future<void> _saveCsvFile(String csvContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.csv');

      await file.writeAsString(csvContent);

      print('CSV file saved successfully');
    } catch (e) {
      print('Error saving CSV file: $e');
    }
  }

  @override
  void dispose() {
    deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: deviceIdController,
              decoration: InputDecoration(
                labelText: 'Enter Device ID',
              ),
            ),
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(
                labelText: 'Enter Start Time in EPOCH format',
              ),
            ),
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(
                labelText: 'Enter End Time in EPOCH format',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchDataAndDownload,
              child: Text('Download ',
                  style: (TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ))),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class printTabular extends StatelessWidget {
  final List<DataRow> dataRows;

  printTabular({required this.dataRows});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API ',
      home: Scaffold(
        appBar: AppBar(
          title: Text('API '),
        ),
        body: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Device ID')),
              DataColumn(label: Text('Start Time')),
              DataColumn(label: Text('End Time')),
            ],
            rows: dataRows,
          ),
        ),
      ),
    );
  }
}
