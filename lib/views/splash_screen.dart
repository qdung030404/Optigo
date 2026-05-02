import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optigo/providers/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Truy cập Provider
      context.read<SplashProvider>().initSplash((nextRoute) {
        // Thực hiện điều hướng dựa trên kết quả từ Provider
        Navigator.pushReplacementNamed(context, nextRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfffedd59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image(image: AssetImage('assets/images/splash_logo.png'))),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
