import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model-view/video_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: "Poppins",
            primaryColor: Colors.deepOrange,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              backgroundColor: Colors.deepOrange,
              centerTitle: true,
            )),
      ),
    );
  }
}
