import 'package:flutter/material.dart';
import 'package:truckminder/page/login.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TruckMinder",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 16, 21, 42)
      ),
      debugShowCheckedModeBanner: false
      ,
      routes: {
          '/': (context) => const Login(),
          },
    );
  }

  
}