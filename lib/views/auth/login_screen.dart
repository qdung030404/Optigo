import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:optigo/views/auth/widget/auth_form.dart';
import 'package:optigo/views/auth/widget/language_selector.dart';
import 'package:optigo/views/auth/widget/welcome_hero.dart';

 class LoginScreen extends StatelessWidget {
   const LoginScreen({super.key});

   @override
   Widget build(BuildContext context) {
     final bottomInset = MediaQuery.of(context).viewInsets.bottom;
     final isKeyboardVisible = bottomInset > 0;

     return Scaffold(
       backgroundColor: Colors.white,
       body: SafeArea(
         child: Stack(
           children: [
             // Background Hero: Fixed position and size
             Positioned(
               top: 20,
               left: 0,
               right: 0,
               height: 400,
               child: AnimatedOpacity(
                 duration: const Duration(milliseconds: 300),
                 opacity: isKeyboardVisible ? 0.3 : 1.0,
                 child: ClipRect(
                   child: ImageFiltered(
                     imageFilter: ImageFilter.blur(
                       sigmaX: isKeyboardVisible ? 5.0 : 0.0,
                       sigmaY: isKeyboardVisible ? 5.0 : 0.0,
                     ),
                     child: Column(
                       children: const [
                         Align(
                           
                           alignment: Alignment.centerRight,
                           child: Padding(padding: EdgeInsets.only(right: 16), child: LanguageSelector(),),
                         ),
                         SizedBox(height: 20),
                         Expanded(child: WelcomeHero()),
                       ],
                     )
                   ),
                 ),
               ),
             ),
             // Scrollable Content
             Positioned.fill(
               child: LayoutBuilder(
                 builder: (context, constraints) {
                   return SingleChildScrollView(
                     physics: const BouncingScrollPhysics(),
                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                     child: ConstrainedBox(
                       constraints: BoxConstraints(
                         minHeight: constraints.maxHeight - 32,
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: [
                           const AuthForm(),
                           
                           // Extra bottom padding to ensure AuthForm isn't cut off when keyboard is hidden
                           const SizedBox(height: 20),
                         ],
                       ),
                     ),
                   );
                 },
               ),
             ),
           ],
         ),
       ),
     );
   }

 }
