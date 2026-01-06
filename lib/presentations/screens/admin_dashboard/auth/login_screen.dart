// lib/auth_admin/presentations/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/di.dart';
import '../../../controller/bloc/auth/auth_bloc.dart';
import '../../../controller/cubit/auth/login_cubit.dart';
import '../../../controller/cubit/auth/login_state.dart';
import '../../../controller/cubit/complaints/complaints_cubit.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../employee_dashboard/employee_dashboard_screen.dart';
import '../admin_panel_app.dart';



class LoginScreen extends StatefulWidget {
 const LoginScreen({super.key});

 @override
 State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 late final TextEditingController _emailCtrl;
 late final TextEditingController _pwdCtrl;
 late final ValueNotifier<bool> _obscurePassword;

 @override
 void initState() {
  super.initState();
  _emailCtrl = TextEditingController();
  _pwdCtrl = TextEditingController();
  _obscurePassword = ValueNotifier<bool>(true);
 }

 @override
 void dispose() {
  _emailCtrl.dispose();
  _pwdCtrl.dispose();
  _obscurePassword.dispose();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return Directionality(
   textDirection: TextDirection.rtl,
   child: Scaffold(
    body: Stack(
     children: [
      Container(
       decoration: BoxDecoration(
        gradient: LinearGradient(
         begin: Alignment.topRight,
         end: Alignment.bottomLeft,
         colors: [AppColors.c1, AppColors.c5, AppColors.c2],
        ),
       ),
      ),
      Center(
       child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;
        return SingleChildScrollView(
         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
         child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
           elevation: 12,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
           child: isMobile
               ? Column(children: [_buildLeftSide(), _buildRightSide()])
               : Row(children: [Expanded(child: _buildLeftSide()), Expanded(child: _buildRightSide())]),
          ),
         ),
        );
       }),
      ),
     ],
    ),
   ),
  );
 }

 Widget _buildLeftSide() {
  return Container(
   padding: const EdgeInsets.all(32),
   decoration: BoxDecoration(
    color: AppColors.c1,
    borderRadius: const BorderRadius.only(
     topLeft: Radius.circular(20),
     bottomLeft: Radius.circular(20),
    ),
   ),
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Image.asset('assets/authentication-65.png', height: 250, fit: BoxFit.contain),
     const SizedBox(height: 40),
     Text('أهلاً بعودتك',
         style: TextStyle(color: AppColors.c5, fontSize: 26, fontWeight: FontWeight.bold),
         textAlign: TextAlign.center),
     const SizedBox(height: 12),
     Text('سجل الدخول للوصول إلى لوحة التحكم',
         style: TextStyle(color: AppColors.c5, fontSize: 16), textAlign: TextAlign.center),
    ],
   ),
  );
 }

 Widget _buildRightSide() {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 36),
   child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text('تسجيل الدخول',
         style: GoogleFonts.amiri(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.c3),
         textAlign: TextAlign.right),
     const SizedBox(height: 32),

     BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
       if (previous is AuthCooldown && current is AuthCooldown) return false;
       return previous.runtimeType != current.runtimeType;
      },
      listener: (context, authState) {
       if (authState is AuthCooldown) {
        CustomSnackBar.show(context, title: 'تنبيه الأمان', message: authState.message, contentType: ContentType.warning);
       } else if (authState is AuthFailure) {
        CustomSnackBar.show(context, title: 'فشل الدخول', message: authState.message, contentType: ContentType.failure);
       } else if (authState is AuthAuthenticated) {
        CustomSnackBar.show(context, title: 'تم النجاح', message: 'مرحباً بك مجدداً', contentType: ContentType.success);
        _handleNavigation(authState);
       }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
       builder: (context, authState) {
        final inCooldown = authState is AuthCooldown;
        final seconds = inCooldown ? authState.secondsRemaining : 0;

        return BlocBuilder<LoginCubit, LoginState>(
         builder: (context, loginState) {
          return Column(
           children: [
            CustomTextField(
             focusedBorderColor: AppColors.c5,
             controller: _emailCtrl,
             hint: ' البريد الإلكتروني',
             keyboardType: TextInputType.emailAddress,
             prefixIcon: Icons.email_outlined,
             enabled: !inCooldown,
            ),
            if (loginState.fieldErrors.containsKey('email') && loginState.showErrors)
             _buildErrorText(loginState.fieldErrors['email']!),

            const SizedBox(height: 20),

            CustomTextField(
             focusedBorderColor: AppColors.c5,
             controller: _pwdCtrl,
             hint: 'كلمة السر',
             obscure: true,
             prefixIcon: Icons.lock_outline,
             obscureNotifier: _obscurePassword,
             enabled: !inCooldown,
            ),
            if (loginState.fieldErrors.containsKey('password') && loginState.showErrors)
             _buildErrorText(loginState.fieldErrors['password']!),

            const SizedBox(height: 32),

            AbsorbPointer(
             absorbing: inCooldown || authState is AuthLoading,
             child: Opacity(
              opacity: (inCooldown || authState is AuthLoading) ? 0.6 : 1.0,
              child: CustomButton(
               onPressed: () {
                final cubit = context.read<LoginCubit>();
                cubit.setEmail(_emailCtrl.text.trim());
                cubit.setPassword(_pwdCtrl.text);
                cubit.submit();
               },
               label: inCooldown ? 'الخدمة مقيدة مؤقتاً' : 'سجل الدخول',
               textColor: Colors.white,
               loading: authState is AuthLoading,
               color: inCooldown ? Colors.grey : AppColors.c5,
               height: 50,
               borderRadius: 12,
              ),
             ),
            ),

            if (inCooldown)
             Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
               children: [
                Text('محاولات كثيرة خاطئة',
                    style: GoogleFonts.notoSansArabic(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('يرجى الانتظار $seconds ثانية للمحاولة مجدداً',
                    style: GoogleFonts.notoSansArabic(color: Colors.orange, fontSize: 13),
                    textAlign: TextAlign.center),
               ],
              ),
             ),
           ],
          );
         },
        );
       },
      ),
     ),
     const SizedBox(height: 16),
    ],
   ),
  );
 }

 Widget _buildErrorText(String error) {
  return Padding(
   padding: const EdgeInsets.only(top: 8.0),
   child: Align(
    alignment: Alignment.centerRight,
    child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 13)),
   ),
  );
 }

 void _handleNavigation(AuthAuthenticated authState) {
  Future.microtask(() {
   final role = authState.admin.role;
   if (role == 1) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPanelApp()));
   } else {
    Navigator.pushReplacement(
     context,
     MaterialPageRoute(
      builder: (context) => BlocProvider<ComplaintsCubit>(
       create: (_) => ComplaintsCubit(useCase: AppDependencies.complaintsUseCase)..loadComplaints(),
       child: const EmployeeDashboardScreen(),
      ),
     ),
    );
   }
  });
 }
}