import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../controller/bloc/employees_managements/create_employee/create_email_state.dart';
import '../../controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import '../../controller/cubit/employees_management/create_employees/create_email_state_cubit.dart';


class EmployeeFormCard extends StatefulWidget {
  const EmployeeFormCard({Key? key}) : super(key: key);

  @override
  State<EmployeeFormCard> createState() => _EmployeeFormCardState();
}

class _EmployeeFormCardState extends State<EmployeeFormCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _govController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _govController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _govController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _maybeUpdateController(TextEditingController c, String newText) {
    if (c.text != newText) {
      c.text = newText;
      c.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
    }
  }

  InputDecoration fieldDecoration({required IconData prefix, required String hint, Widget? suffix}) {
    const fieldBg = Color(0xFF081B1B);
    const accent = Color(0xFF5A8F76);
    return InputDecoration(
      filled: true,
      fillColor: fieldBg,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF6E8F7F)),
      prefixIcon: Icon(prefix, color: accent),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x4D5A8F76)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x4D5A8F76)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgCard = Color(0xFF203B37);
    const textPrimary = Color(0xFFEEE8B2);
    const textSecondary = Color(0xFF96CD80);

    return BlocListener<CreateEmailBloc, CreateEmailState>(
      listener: (context, state) {
        if (state is CreateEmailFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ),
          );
        } else if (state is Created) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إنشاء الحساب للمستخدم ${state.admin.name}')),
          );
          context.read<CreateEmailCubit>().clearAll();
        }
      },
      child: BlocBuilder<CreateEmailCubit, CreateEmailStateCubit>(
        builder: (context, cubitState) {
          _maybeUpdateController(_nameController, cubitState.name);
          _maybeUpdateController(_emailController, cubitState.email);
          _maybeUpdateController(_govController, cubitState.governmentAgencyId?.toString() ?? '');
          _maybeUpdateController(_passwordController, cubitState.password);
          _maybeUpdateController(_passwordConfirmController, cubitState.passwordConfirmation);

          final submitting = cubitState.submitting;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x805A8F76)),
            ),
            child: Form(
              autovalidateMode: cubitState.showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField('الاسم الكامل', _nameController, Icons.person, (v) => context.read<CreateEmailCubit>().setName(v)),
                  const SizedBox(height: 12),
                  _buildTextField('البريد الإلكتروني', _emailController, Icons.mail, (v) => context.read<CreateEmailCubit>().setEmail(v), email: true),
                  const SizedBox(height: 12),
                  _buildTextField('رقم الموظف التابع للوزارة', _govController, Icons.person, (v) => context.read<CreateEmailCubit>().setGovernmentAgencyId(int.tryParse(v))),
                  const SizedBox(height: 12),
                  _buildTextField('كلمة المرور', _passwordController, Icons.lock, (v) => context.read<CreateEmailCubit>().setPassword(v), obscure: cubitState.obscurePassword, toggle: () => context.read<CreateEmailCubit>().toggleObscurePassword()),
                  const SizedBox(height: 12),
                  _buildTextField('تأكيد كلمة المرور', _passwordConfirmController, Icons.lock_outline, (v) => context.read<CreateEmailCubit>().setPasswordConfirmation(v), obscure: cubitState.obscureConfirmation, toggle: () => context.read<CreateEmailCubit>().toggleObscureConfirmation()),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: submitting ? null : () => context.read<CreateEmailCubit>().submit(),
                      icon: submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.person_add),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(submitting ? 'جاري الإنشاء...' : 'إنشاء حساب الموظف', style: const TextStyle(color: Color(0xFF081B1B))),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF081B1B),
                        backgroundColor: const Color(0xFF5A8F76),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, Function(String) onChanged, {bool email = false, bool obscure = false, VoidCallback? toggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF96CD80), fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF081B1B),
            hintText: 'أدخل $label',
            hintStyle: const TextStyle(color: Color(0xFF6E8F7F)),
            prefixIcon: Icon(icon, color: const Color(0xFF5A8F76)),
            suffixIcon: toggle == null ? null : TextButton(onPressed: toggle, child: Text(obscure ? 'عرض' : 'إخفاء', style: const TextStyle(color: Color(0xFF5A8F76)))),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0x4D5A8F76))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0x4D5A8F76))),
          ),
          style: const TextStyle(color: Color(0xFFEEE8B2)),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
