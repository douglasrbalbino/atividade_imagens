import 'package:atividade_images/pages/image_capture_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ImageCapturePage(title: 'localização dos guri'),
      debugShowCheckedModeBanner: false,
    );
  }
}
