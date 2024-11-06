import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapmotion/routes/routes.dart';
import 'package:snapmotion/routes/routes_name.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "Poppins",
            primaryColor: Colors.deepOrange,
        ),
        initialRoute: RoutesName.homeView,
        onGenerateRoute: Routes.generatedRoutes,
      ),
    );
  }
}
