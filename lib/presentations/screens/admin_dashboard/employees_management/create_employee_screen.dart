import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../controller/bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../../controller/bloc/employees_managements/create_employee/create_email_state.dart';
import '../../../controller/bloc/government_agencies/gov_agencies_bloc.dart';
import '../../../controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import '../../../controller/cubit/employees_management/create_employees/create_email_state_cubit.dart';
import '../../../widgets/custom_snack_bar.dart';

class EmployeeFormCard extends StatefulWidget {
  const EmployeeFormCard({Key? key}) : super(key: key);

  @override
  State<EmployeeFormCard> createState() => _EmployeeFormCardState();
}

class _EmployeeFormCardState extends State<EmployeeFormCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    context.read<GovAgenciesBloc>().add(FetchGovAgenciesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    const bgCard = Color(0xFF203B37);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateEmailBloc, CreateEmailState>(
            listener: (context, state) {
              if (state is CreateEmailFailure) {
                CustomSnackBar.show(context, title: 'فشل العملية', message: state.message, contentType: ContentType.failure);
              } else if (state is Created) {
                CustomSnackBar.show(context, title: 'نجاح', message: 'تم إنشاء حساب للموظف ${state.admin.name}', contentType: ContentType.success);
                context.read<CreateEmailCubit>().clearAll();
              }
            },
          ),
        ],
        child: BlocBuilder<CreateEmailCubit, CreateEmailStateCubit>(
          builder: (context, cubitState) {
            _maybeUpdateController(_nameController, cubitState.name);
            _maybeUpdateController(_emailController, cubitState.email);
            _maybeUpdateController(_passwordController, cubitState.password);
            _maybeUpdateController(_passwordConfirmController, cubitState.passwordConfirmation);

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x805A8F76)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'إنشاء حساب موظف جديد',
                    style: TextStyle(
                      color: Color(0xFFEEE8B2),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يمكنك إنشاء الموظفين بعد ملئ جميع المعلومات اللازمة مع اختيار لأي وزارة تابع.',
                    style: TextStyle(
                      color: Color(0xFF96CD80),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildField('الاسم الكامل', _nameController, Icons.person, (v) => context.read<CreateEmailCubit>().setName(v), error: cubitState.fieldErrors['name'], showErr: cubitState.showErrors),
                  const SizedBox(height: 12),
                  _buildField('البريد الإلكتروني', _emailController, Icons.mail, (v) => context.read<CreateEmailCubit>().setEmail(v), email: true, error: cubitState.fieldErrors['email'], showErr: cubitState.showErrors),
                  const SizedBox(height: 12),

                  _buildGovDropdown(cubitState),

                  const SizedBox(height: 12),
                  _buildField('كلمة المرور', _passwordController, Icons.lock, (v) => context.read<CreateEmailCubit>().setPassword(v), obscure: cubitState.obscurePassword, toggle: () => context.read<CreateEmailCubit>().toggleObscurePassword(), error: cubitState.fieldErrors['password'], showErr: cubitState.showErrors),
                  const SizedBox(height: 12),
                  _buildField('تأكيد كلمة المرور', _passwordConfirmController, Icons.lock_outline, (v) => context.read<CreateEmailCubit>().setPasswordConfirmation(v), obscure: cubitState.obscureConfirmation, toggle: () => context.read<CreateEmailCubit>().toggleObscureConfirmation(), error: cubitState.fieldErrors['password_confirmation'], showErr: cubitState.showErrors),
                  const SizedBox(height: 20),

                  _buildSubmitButton(cubitState.submitting),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGovDropdown(CreateEmailStateCubit cubitState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // لضمان بقاء العنوان "الوزارة" في اليمين
      children: [
        const Text('الوزارة / الجهة الحكومية', style: TextStyle(color: Color(0xFF96CD80), fontSize: 13)),
        const SizedBox(height: 6),
        BlocBuilder<GovAgenciesBloc, GovAgenciesState>(
          builder: (context, state) {
            bool isLoading = state is GovAgenciesLoading;
            bool hasError = state is GovAgenciesError;
            var agencies = state is GovAgenciesLoaded ? state.agencies : [];

            return DropdownButtonFormField<int>(
              value: cubitState.governmentAgencyId,
              dropdownColor: const Color(0xFF081B1B), // لون خلفية القائمة المنسدلة
              isExpanded: true, // لضمان أخذ العرض الكامل وتوزيع العناصر بشكل صحيح
              alignment: AlignmentDirectional.centerStart, // 💡 محاذاة القائمة لتناسب الـ RTL
              icon: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.arrow_drop_down, color: Color(0xFF5A8F76)),
              style: const TextStyle(color: Color(0xFFEEE8B2), fontFamily: 'Cairo'), // تأكد من استخدام خط يدعم العربية
              onChanged: (val) => context.read<CreateEmailCubit>().setGovernmentAgencyId(val),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF081B1B),
                // 💡 نقل الأيقونة لتكون في المكان الصحيح (اليمين في حال الـ RTL)
                prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF5A8F76)),
                errorText: cubitState.showErrors ? cubitState.fieldErrors['government_agency_id'] : null,
                errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0x4D5A8F76))),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              hint: const Align(
                alignment: Alignment.centerRight, // 💡 محاذاة نص التلميح لليمين
                child: Text(
                  'اختر الوزارة',
                  style: TextStyle(color: Color(0xFF6E8F7F), fontSize: 12),
                ),
              ),
              items: agencies.map<DropdownMenuItem<int>>((agency) {
                return DropdownMenuItem<int>(
                  value: agency.id,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Text(
                      agency.name ?? '',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, Function(String) onChanged, {bool email = false, bool obscure = false, VoidCallback? toggle, TextInputType keyboardType = TextInputType.text, String? error, bool showErr = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF96CD80), fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          style: const TextStyle(color: Color(0xFFEEE8B2)),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF081B1B),
            hintText: 'أدخل $label',
            hintStyle: const TextStyle(color: Color(0xFF6E8F7F), fontSize: 12),
            prefixIcon: Icon(icon, color: const Color(0xFF5A8F76)),
            suffixIcon: toggle == null ? null : TextButton(onPressed: toggle, child: Text(obscure ? 'عرض' : 'إخفاء', style: const TextStyle(color: Color(0xFF5A8F76), fontSize: 12))),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            errorText: showErr ? error : null,
            errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0x4D5A8F76))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0x4D5A8F76))),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool submitting) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submitting ? null : () => context.read<CreateEmailCubit>().submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A8F76),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('إنشاء حساب الموظف', style: TextStyle(color: Color(0xFF081B1B), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}