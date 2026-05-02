import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optigo/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:optigo/providers/auth_provider.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = "";

  void _handleSignUp() async{
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    try{
      await authProvider.sendOtp(_completePhoneNumber);
      if (!mounted) return;
      if (authProvider.status == AuthStatus.codeSent){
        Navigator.pushNamed(context, Routes.otp);
      }
      print(_completePhoneNumber);
    }catch(e){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? e.toString())),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Get started',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
                child:IntlPhoneField(
                  disableLengthCheck: true,
                  decoration: InputDecoration(
                    hintText: '9 1234 5678',
                    hintStyle: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.withAlpha(128)),
                    border: const UnderlineInputBorder(),
                    counterText: '',
                  ),
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                  initialCountryCode: 'VN',
                  onChanged: (phone) {
                    String number = phone.number;
                    if (number.startsWith('0')) {
                      number = number.substring(1);
                    }
                    _completePhoneNumber = '${phone.countryCode}$number';
                    print('Số điện thoại cuối cùng: $_completePhoneNumber');
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
            )
          ),
          const Spacer(),
          Consumer<AuthProvider>(builder: (context, authProvider, child){
                return Container(
                  width: double.infinity,
                  height: 100.h,
                  padding: EdgeInsets.all(16.sp),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfffedd59),
                      foregroundColor: const Color(0xff176bac),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _handleSignUp,

                    child: Text('Sign Up', style: GoogleFonts.beVietnamPro(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                  ),
                ); // Hiển thị ô nhập liệu mặc định
          })
        ],
      ),
    );

  }
}
