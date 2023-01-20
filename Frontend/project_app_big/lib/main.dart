// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_app_big/routers/route.dart';
import 'package:provider/provider.dart';


 void main() {
  //    WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(
    MyApp(),
     );
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      initialRoute: "/",
      // home: ,
    );
  }
}