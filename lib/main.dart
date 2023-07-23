/*
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

  //int? deviceId = int.tryParse('105');
  String deviceId = '';
  String starttime = '';
  String endtime = '';
/*
  void _storeInputData() {
    setState(() {
      deviceId = deviceIdController.text;
    });
  }*/

  /*
  void _convertToInt() {
    int? inputValue = int.tryParse(deviceIdController.text);
    if (inputValue != null) {
      deviceId = inputValue.toString();
    } else {
      deviceId = 'Invalid input';
    }
  }

   */

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

//Fetch data in tabular format
  /*void fetchData() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)as List<dynamic>;

      final List<DataRow> dataRows = [];

      jsonData.forEach((item) {
        final dataRow = DataRow(cells: [
          DataCell(Text(item['Device ID'].toString())),
          DataCell(Text(item['Start Time'].toString())),
          DataCell(Text(item['End Time'].toString())),
        ]);
        dataRows.add(dataRow);
      });

      runApp(printTabular(dataRows: dataRows));
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//Fetch data 2
  /* void fetchData() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      final List<DataRow> dataRows = jsonData.map((item) {
        return DataRow(cells: [
          DataCell(Text(item['id'].toString())),
          DataCell(Text(item['id'].toString())),
          DataCell(Text(item['id'].toString())),
        ]);
      }).toList();

      print(jsonData); // Print the fetched data on the console

      runApp(printTabular(dataRows: dataRows));
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//fetch and download data
  /* void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      const fileName = 'cow_data.json'; // Specify the file name and extension

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonData);

      print('JSON data saved at: $filePath');
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//fetch data & downlaod 2
  /*void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      const fileName = 'cow_data.json'; // Specify the file name and extension
      print(jsonData);

      Directory? directory;
      try {
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        // Use getTemporaryDirectory as a fallback
        directory = await getTemporaryDirectory() as Directory?;
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsString(jsonData);

        print('JSON data saved at: $filePath');

      } else {
        print('Error: Unable to get the storage directory.');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

  void fetchDataAndPrint() async {
    print(deviceId);
    print(starttime);
    print(endtime);
    //final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=105&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime'); // Replace with your API endpoint
    //https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime
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
    print(deviceId);
    print(starttime);
    print(endtime);
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime'); // Replace with your API endpoint
    //final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=105&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint

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

//Tabular printing
  /* void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      final decodedData = json.decode(jsonData);
      print(jsonData);

      final List<TableRow> tableRows = [];
      if (decodedData is List) {
        // Assuming the JSON data is an array of objects
        if (decodedData.isNotEmpty) {
          final firstObject = decodedData.first;
          final List<TableCell> headers = firstObject.keys.map((key) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList();
          tableRows.add(TableRow(children: headers));

          for (var dataObject in decodedData) {
            final List<TableCell> cells = dataObject.values.map((value) {
              return TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value.toString()),
                ),
              );
            }).toList();
            tableRows.add(TableRow(children: cells));

            // Print the row data on the console
            cells.forEach((cell) {
              final textData = (cell.child as Padding).child as Text;
              print(textData.data);
            });
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  children: tableRows,
                ),
              ),
            ),
          );
        },
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//Fetch data in json format
/* void fetchData() async {
  final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = response.body;

    /*
    // Process the JSON data here
    final jsonData = {
      'DeviceID': deviceIdController.text,
      'StartTime': startTimeController.text,
      'EndTime': endTimeController.text,
    };

    final csvContent = convertToCsv([jsonData]);
    _saveCsvFile(csvContent);
    */

    print(jsonData);
  } else {
    print('Error: ${response.statusCode}');
  }

}*/

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
      final file = File('${directory.path}/cow_data.csv');

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
              onChanged: (value) {
                deviceId = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter Device ID',
              ),
            ),
            TextField(
              controller: startTimeController,
              onChanged: (value) {
                starttime = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter Start Time in EPOCH format',
              ),
            ),
            TextField(
              controller: endTimeController,
              onChanged: (value) {
                endtime = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter End Time in EPOCH format',
              ),
            ),

            //Change here to make the time and date selected by the user
            /*
            SizedBox(height: 16),
            InkWell(
              onTap: () => _showDatePicker(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  startTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(startTime!)
                      : 'Select start time',
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _showDatePicker(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  endTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(endTime!)
                      : 'Select end time',
                ),
              ),
            ),
            */

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
              //child: Text('Download'),
              /*
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70)),*/
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
*/

/*
def pre_process(data):
    
    if data >= 128:
        data -= 256
    sf = 6.4 # Scaling Factor

    return str(round(data/sf, 2))
*/

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

  //int? deviceId = int.tryParse('105');
  String deviceId = '';
  String starttime = '';
  String endtime = '';
/*
  void _storeInputData() {
    setState(() {
      deviceId = deviceIdController.text;
    });
  }*/

  /*
  void _convertToInt() {
    int? inputValue = int.tryParse(deviceIdController.text);
    if (inputValue != null) {
      deviceId = inputValue.toString();
    } else {
      deviceId = 'Invalid input';
    }
  }

   */

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

//Fetch data in tabular format
  /*void fetchData() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)as List<dynamic>;

      final List<DataRow> dataRows = [];

      jsonData.forEach((item) {
        final dataRow = DataRow(cells: [
          DataCell(Text(item['Device ID'].toString())),
          DataCell(Text(item['Start Time'].toString())),
          DataCell(Text(item['End Time'].toString())),
        ]);
        dataRows.add(dataRow);
      });

      runApp(printTabular(dataRows: dataRows));
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//Fetch data 2
  /* void fetchData() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      final List<DataRow> dataRows = jsonData.map((item) {
        return DataRow(cells: [
          DataCell(Text(item['id'].toString())),
          DataCell(Text(item['id'].toString())),
          DataCell(Text(item['id'].toString())),
        ]);
      }).toList();

      print(jsonData); // Print the fetched data on the console

      runApp(printTabular(dataRows: dataRows));
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//fetch and download data
  /* void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      const fileName = 'cow_data.json'; // Specify the file name and extension

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonData);

      print('JSON data saved at: $filePath');
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//fetch data & downlaod 2
  /*void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      const fileName = 'cow_data.json'; // Specify the file name and extension
      print(jsonData);

      Directory? directory;
      try {
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        // Use getTemporaryDirectory as a fallback
        directory = await getTemporaryDirectory() as Directory?;
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsString(jsonData);

        print('JSON data saved at: $filePath');

      } else {
        print('Error: Unable to get the storage directory.');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

  void fetchDataAndPrint() async {
    print(deviceId);
    print(starttime);
    print(endtime);
    //final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=105&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime'); // Replace with your API endpoint
    //https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime
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
    print(deviceId);
    print(starttime);
    print(endtime);
    //ENDTIME<STARTTIME
    final url = Uri.parse(
        'https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=$deviceId&starttime=$starttime&endtime=$endtime'); // Replace with your API endpoint
    //final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=105&starttime=1688132921&endtime=1688133222'); // Replace with your API endpoint

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

//Tabular printing
  /* void fetchDataAndDownload() async {
    final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      final decodedData = json.decode(jsonData);
      print(jsonData);

      final List<TableRow> tableRows = [];
      if (decodedData is List) {
        // Assuming the JSON data is an array of objects
        if (decodedData.isNotEmpty) {
          final firstObject = decodedData.first;
          final List<TableCell> headers = firstObject.keys.map((key) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList();
          tableRows.add(TableRow(children: headers));

          for (var dataObject in decodedData) {
            final List<TableCell> cells = dataObject.values.map((value) {
              return TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value.toString()),
                ),
              );
            }).toList();
            tableRows.add(TableRow(children: cells));

            // Print the row data on the console
            cells.forEach((cell) {
              final textData = (cell.child as Padding).child as Text;
              print(textData.data);
            });
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  children: tableRows,
                ),
              ),
            ),
          );
        },
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }*/

//Fetch data in json format
/* void fetchData() async {
  final url = Uri.parse('https://wcelyqvyi7.execute-api.us-east-1.amazonaws.com/deployment/cow?deviceId=120&starttime=1688132921&endtime=1688133222');  // Replace with your API endpoint

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = response.body;

    /*
    // Process the JSON data here
    final jsonData = {
      'DeviceID': deviceIdController.text,
      'StartTime': startTimeController.text,
      'EndTime': endTimeController.text,
    };

    final csvContent = convertToCsv([jsonData]);
    _saveCsvFile(csvContent);
    */

    print(jsonData);
  } else {
    print('Error: ${response.statusCode}');
  }

}*/

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
      final file = File('${directory.path}/cow_data.csv');

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
        title: Row(
          children: [



            /*Image.asset(
              'build/assets/images/awadh_logo2.jpeg',//change the logo image
              width: 150,
              height: 100,

            ),*/


            Text('Cow Monitor ', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Image.network(
              //'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Cow_%28Fleckvieh_breed%29_Oeschinensee_Slaunger_2009-07-07.jpg/1200px-Cow_%28Fleckvieh_breed%29_Oeschinensee_Slaunger_2009-07-07.jpg',
              'https://yt3.googleusercontent.com/5qoF2sM_UgWK8OSwgIZOZfV76-H2UmkSkwEO91UaEljPLlV3Yi76fe6G2A-RsKKjYS0GYh6kjQ=s900-c-k-c0x00ffffff-no-rj',
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: deviceIdController,
              onChanged: (value) {
                deviceId = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter Device ID',
              ),
            ),
            TextField(
              controller: startTimeController,
              onChanged: (value) {
                starttime = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter Start Time in EPOCH format',
              ),
            ),
            TextField(
              controller: endTimeController,
              onChanged: (value) {
                endtime = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter End Time in EPOCH format',
              ),
            ),

            //Change here to make the time and date selected by the user
            /*
            SizedBox(height: 16),
            InkWell(
              onTap: () => _showDatePicker(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  startTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(startTime!)
                      : 'Select start time',
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _showDatePicker(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  endTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(endTime!)
                      : 'Select end time',
                ),
              ),
            ),
            */

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
              //child: Text('Download'),
              /*
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70)),*/
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
