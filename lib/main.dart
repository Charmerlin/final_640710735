import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'linkclass.dart';
import 'helpers/api_caller.dart';
import 'helpers/dialog_utils.dart';
import 'helpers/my_list_tile.dart';
import 'helpers/my_text_field.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Caller Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // เรียกใช้งานเมธอด get หรือ post จาก ApiCaller
              _getDataFromApi();
            },
            child: Text('Call API'),
          ),
        ),
      ),
    );
  }

  // เมธอดสำหรับเรียกใช้งาน API
  void _getDataFromApi() async {
    ApiCaller apiCaller = ApiCaller(); // สร้างอ็อบเจกต์ของคลาส ApiCaller
    try {
      String response = await apiCaller.get('your_endpoint_here'); // เรียกใช้งานเมธอด get โดยใส่ endpoint ของ API ที่ต้องการเรียก
      print(response); // แสดงผลลัพธ์การเรียก API ใน Console
    } catch (e) {
      print('Error: $e'); // แสดงข้อผิดพลาดในกรณีที่เกิดข้อผิดพลาดในการเรียก API
    }
  }
}


class _MyAppState extends State<MyApp> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<link_class> menu = [];
  String url = 'https://cpsu-api-49b593d4e146.herokuapp.com/api/2_2566/final/web_types';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<link_class> linkclass = jsonData.map((item) {
        return link_class(
          id: item['id'],
          title: item['title'],
          subtitle: item['subtitle'],
          image: 'https://cpsu-api-49b593d4e146.herokuapp.com${item['image']}',
        );
      }).toList();

      setState(() {
        menu = linkclass;
        print(menu.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                controller: urlController,
                hintText1: 'URL', // กำหนด hintText1 เป็น 'URL'
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: descriptionController,
                hintText1: 'รายละเอียด', // กำหนด hintText1 เป็น 'รายละเอียด'
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String url = urlController.text; // รับค่า URL จาก TextField
                  String description = descriptionController.text; // รับค่ารายละเอียดจาก TextField
                  sendReport(url, description); // เรียกใช้งานฟังก์ชันสำหรับส่งรายงาน
                },
                child: Text('Submit'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  return MyListTile(
                    title: menu[index].title,
                    subtitle: menu[index].subtitle,
                    imageUrl: menu[index].image,
                    onTap: () {
                      showOkDialog(
                        context: context,
                        title: menu[index].title,
                        message: menu[index].subtitle,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void sendReport(String url, String description) async {
  final apiUrl = 'https://cpsu-api-49b593d4e146.herokuapp.com/api/2_2566/final/report_web';

  final data = {
    "insertItem": {
      "id": 2,
      "url": url,
      "description": description,
      "type": "custom"
    }
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print("Report sent successfully!");
  } else {
    print("Failed to send report. Error code: ${response.statusCode}");
  }
}

void main() {
  runApp(const MyApp());
}

void sendsReport(String url, String description) async {
  final apiUrl = 'https://cpsu-api-49b593d4e146.herokuapp.com/api/2_2566/final/report_web';

  final data = {
    "insertItem": {
      "id": 2,
      "url": url,
      "description": description,
      "type": "gambling"
    },
    "summary": [
      {
        "title": "เว็บพนัน",
        "count": 1
      },
      {
        "title": "เว็บปลอมแปลง เลียนแบบ",
        "count": 1
      },
      {
        "title": "เว็บข่าวมั่ว",
        "count": 0
      },
      {
        "title": "เว็บแชร์ลูกโซ่",
        "count": 0
      }
    ]
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print("Report sent successfully!");
  } else {
    print("Failed to send report. Error code: ${response.statusCode}");
  }
}

