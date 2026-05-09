import 'package:flutter/material.dart';
import 'package:optigo/views/auth/widget/auth_form.dart';
import 'package:optigo/views/auth/widget/language_selector.dart';
import 'package:optigo/views/auth/widget/welcome_hero.dart';

 class LoginScreen extends StatelessWidget {
   const LoginScreen({super.key});

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
       body: SafeArea(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               // Top Bar
               const Align(
                 alignment: Alignment.centerRight,
                 child: LanguageSelector(),
               ),
               const SizedBox(height: 20),
               const Expanded(
                 child: WelcomeHero(),
               ),
               const AuthForm(),
             ],
           ),
         ),
       ),
     );
   }

 }
