// ignore_for_file: avoid_print

import 'dart:io'; //
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:path_provider/path_provider.dart'; // للحصول على مسارات التخزين
import 'package:image_gallery_saver/image_gallery_saver.dart'; // مكتبة لحفظ الصور في معرض الهاتف

class Drawing extends StatefulWidget {
  const Drawing({super.key});

  @override
  State<Drawing> createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {
  late DrawingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DrawingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//_---------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("DrawingBoard"),
            const SizedBox(
              width: 150,
            ),
            IconButton(onPressed: saveDrawing, icon: const Icon(Icons.save_alt))
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 137, 137, 136),
      ),
      body: DrawingBoard(
        controller: _controller,
        background: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          height: 600,
          width: 600,
        ),
        showDefaultActions: true,
        showDefaultTools: true,
//         showDefaultActions: true: يعرض الأزرار الافتراضية للإجراءات الشائعة مثل التراجع، إعادة، ومسح.
// showDefaultTools: true: يعرض الأدوات الافتراضية للرسم مثل القلم، الممحاة، والفرشاة.
      ),
    );
  }

//_____________________________________________________________________________________
//save png
  Future<void> saveDrawing() async {
    try {
      // print("Trying to get image data...");
      final imageData = await _controller.getImageData();
      if (imageData == null) {
        print("No image to save");
        return;
      }

      final directory = await getExternalStorageDirectory(); //بروفايدر
      if (directory == null) {
        print("Could not get the external storage directory");
        return;
      }
//imageData.buffer.asUint8List(): يقوم بتحويل بيانات الصورة إلى قائمة من البايتات (Uint8List).
//file.writeAsBytes(...): يقوم بكتابة البيانات كملف بايتات في الملف الذي يمثله الكائن file.
      final path = "${directory.path}/drawings.png";
      final file = File(path);
      await file.writeAsBytes(imageData.buffer.asUint8List());

      print("Drawing saved at $path");

      // استخدام مكتبة ImageGallerySaver لحفظ الصورة في معرض الهاتف
      final result = await ImageGallerySaver.saveFile(file.path);
      print("Image saved to gallery: $result");
    } catch (error) {
      print("Error saving: $error");
    }
  }
}

// ملخص:
// path: هو المسار الكامل للملف الذي سيتم حفظه.
// file: هو كائن يمثل هذا الملف.
// writeAsBytes: تقوم بكتابة بيانات الصورة كملف بايتات إلى الملف.
// print: تطبع رسالة تؤكد أن الرسم قد تم حفظه بنجاح مع عرض المسار.
// هذه العملية تأخذ بيانات الصورة، وتحدد أين سيتم حفظها (المسار)، ثم تكتب البيانات إلى هذا الملف، وأخيرًا تطبع رسالة تشير إلى أن العملية تمت بنجاح.


///_________________________________________________________
///هاي الاذونات لازم اضيفهة في ملف  AndroidManifest.xml
///
// <manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example.your_app_name">
//     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
//     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
//     <application
//         android:requestLegacyExternalStorage="true"
//         android:label="task"
//         android:name="${applicationName}"
//         android:icon="@mipmap/ic_launcher">