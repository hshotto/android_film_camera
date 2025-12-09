import 'package:film_camera/view_models/home_view_model.dart';
import 'package:film_camera/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() {
  runApp(const MainApp());
}
 
class MainApp extends StatelessWidget {
  const MainApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(),
          child: const HomeView(),
        ),
      ),
    );
  }
}