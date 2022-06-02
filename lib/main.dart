import 'package:chat_app/app_routes.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(appRoutes: AppRoutes()),
  );
}

class MyApp extends StatelessWidget {
  final AppRoutes? appRoutes;
  const MyApp({Key? key, this.appRoutes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatty',
      initialRoute: splashScreen,
      onGenerateRoute: appRoutes!.generateRoutes,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: mainColor),
      ),
    );
  }
}
