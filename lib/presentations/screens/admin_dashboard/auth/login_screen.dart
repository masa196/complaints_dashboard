// lib/auth_admin/presentations/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/di.dart';
import '../../../controller/bloc/auth/auth_bloc.dart';
import '../../../controller/cubit/auth/login_cubit.dart';
import '../../../controller/cubit/auth/login_state.dart';
import '../../../controller/cubit/complaints/complaints_cubit.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../employee_dashboard/employee_dashboard_screen.dart';
import '../admin_panel_app.dart';



class LoginScreen extends StatelessWidget {
 LoginScreen({super.key});

 final TextEditingController _emailCtrl = TextEditingController();
 final TextEditingController _pwdCtrl = TextEditingController();
 final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

 @override
 Widget build(BuildContext context) {
  return  Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
     body: Stack(
      children: [
       Container(
        decoration: BoxDecoration(
         gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [AppColors.c1, AppColors.c5, AppColors.c2]),
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
            child: isMobile ? Column(children: [_buildLeftSide(), _buildRightSide(context)]) : Row(children: [Expanded(child: _buildLeftSide()), Expanded(child: _buildRightSide(context))]),
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
   decoration: BoxDecoration(color: AppColors.c1, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Image.asset('assets/authentication-65.png', height: 250, fit: BoxFit.contain),
     const SizedBox(height: 40),
     Text('أهلا بعودتك', style: TextStyle(color: AppColors.c5, fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
     const SizedBox(height: 12),
     Text('سجل الدخول للوصول إلى لوحة التحكم ', style: TextStyle(color: AppColors.c5, fontSize: 16), textAlign: TextAlign.center),
    ],
   ),
  );
 }

 Widget _buildRightSide(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 36),
   child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text('تسجيل الدخول للموظفين/ مدير النظام', style: GoogleFonts.amiri(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.c3), textAlign: TextAlign.right),
     const SizedBox(height: 32),
     BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
       final inCooldown = authState is AuthCooldown;
       final seconds = authState is AuthCooldown ? authState.secondsRemaining : 0;

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
            Padding(
             padding: const EdgeInsets.only(top: 8.0),
             child: Align(
              alignment: Alignment.centerRight,
              child: Text(loginState.fieldErrors['email']!, style: const TextStyle(color: Colors.red, fontSize: 13), textDirection: TextDirection.ltr),
             ),
            ),
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
            Padding(
             padding: const EdgeInsets.only(top: 8.0),
             child: Align(
              alignment: Alignment.centerRight,
              child: Text(loginState.fieldErrors['password']!,
                  style: const TextStyle(color: Colors.red, fontSize: 13), textDirection: TextDirection.ltr),
             ),
            ),
           const SizedBox(height: 32),
           BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
             if (previous is AuthCooldown && current is AuthCooldown) {
              return false;
             }
             return previous.runtimeType != current.runtimeType;
            },
            listener: (context, authState) {
             ScaffoldMessenger.of(context).hideCurrentSnackBar();

             if (authState is AuthCooldown) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message), backgroundColor: Colors.orange, duration: const Duration(seconds: 3)));
             } else if (authState is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
             } else if (authState is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول بنجاح'), backgroundColor: Colors.green, duration: Duration(milliseconds: 700)));

              Future.microtask(() {
               final role = authState.admin.role;
               print("DEBUG: User Role Value = ${authState.admin.role}");
               print("DEBUG: User Role Type = ${authState.admin.role.runtimeType}");
               if (role == 1) {
                Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (_) => const AdminPanelApp()),
                );

               } else {
                Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                  builder: (context) => BlocProvider<ComplaintsCubit>(
                   create: (_) => ComplaintsCubit(useCase: AppDependencies.complaintsUseCase)
                    ..loadComplaints(),
                   child: const EmployeeDashboardScreen(),
                  ),
                 ),
                );

               }

              });
             }
            },
            child: Builder(
             builder: (context) {
              return Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                BlocBuilder<AuthBloc, AuthState>(
                 builder: (context, aState) {
                  final isLoading = aState is AuthLoading;
                  final disableAll = isLoading || inCooldown;
                  return CustomButton(
                   onPressed: disableAll
                       ? () {}
                       : () {
                    final cubit = context.read<LoginCubit>();
                    cubit.setEmail(_emailCtrl.text.trim());
                    cubit.setPassword(_pwdCtrl.text);
                    cubit.submit();
                   },
                   label: inCooldown ? 'انتظر ($seconds)' : 'سجل الدخول',
                   textColor: Colors.white,
                   loading: isLoading,
                   color: AppColors.c5,
                   height: 50,
                   borderRadius: 12,
                  );
                 },
                ),
                if (inCooldown)
                 Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('محاولات كثيرة — يرجى الانتظار ${seconds} ثانية', style:GoogleFonts.notoSansArabic(color: Colors.orange), textAlign: TextAlign.center),

                 ),
               ],
              );
             },
            ),
           ),
          ],
         );
        },
       );
      },
     ),
     const SizedBox(height: 16),
    ],
   ),
  );
 }
}
