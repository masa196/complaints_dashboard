// lib/core/utils/di.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/data/dataSource/complaints/complaints_remote_data_source.dart';
import 'package:untitled/data/repository/complaints/complaints_repository.dart';
import 'package:untitled/domain/use_cases/complaints/get_complaints_usecase.dart';
import '../../data/dataSource/Statistic/statistic_reomte_data_source.dart';
import '../../data/dataSource/audit_logs/audit_remote_data_source.dart';
import '../../data/dataSource/auth/login_remote_data_source.dart';
import '../../data/dataSource/complaints/admin_complaints_remote_data_source.dart';
import '../../data/dataSource/employees_management/create_email_data_source.dart';
import '../../data/dataSource/employees_management/management_employees_data_source.dart';
import '../../data/dataSource/roles/roles_remote_data_source.dart';
import '../../data/repository/audit_logs/audit_repository.dart';
import '../../data/repository/auth/login_repo.dart';
import '../../data/repository/complaints/admin_complaints_repository_impl.dart';
import '../../data/repository/employees_management/create_email_repo.dart';
import '../../data/repository/employees_management/management_employee_repo.dart';
import '../../data/repository/roles/roles_repository.dart';
import '../../data/repository/statistic/statistic_repository.dart';
import '../../domain/use_cases/Statistic/download_report_usecase.dart';
import '../../domain/use_cases/Statistic/get_statistic_usecase.dart';
import '../../domain/use_cases/audit_logs/get_audit_logs_usecase.dart';
import '../../domain/use_cases/auth/login_usecase.dart';
import '../../domain/use_cases/complaints_for_admin/get_admin_complaints_usecase.dart';
import '../../domain/use_cases/employees_managements/assign_role_usecase.dart';
import '../../domain/use_cases/employees_managements/create_email_usecase.dart';
import '../../domain/use_cases/auth/logout_usecase.dart';
import '../../domain/use_cases/employees_managements/delete_employee_usecase.dart';
import '../../domain/use_cases/employees_managements/get_employees_usecase.dart';
import '../../domain/use_cases/employees_managements/get_government_agencies_usecase.dart';
import '../../domain/use_cases/employees_managements/remove_role_usecase.dart';
import '../../domain/use_cases/employees_managements/update_employess_usecase.dart';
import '../../domain/use_cases/permissions/get_permissions.dart';
import '../../domain/use_cases/permissions/update_role_permissions_usecase.dart';
import '../../domain/use_cases/roles/create_role_usecase.dart';
import '../../domain/use_cases/roles/delete_role_usecase.dart';
import '../../domain/use_cases/roles/get_role_details.dart';
import '../../domain/use_cases/roles/get_roles_usecase.dart';
import '../../presentations/controller/bloc/admin_complaints/admin_complaints_bloc.dart';
import '../../presentations/controller/bloc/audit_logs/audit_bloc.dart';
import '../../presentations/controller/bloc/auth/auth_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/employees/employees_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../presentations/controller/bloc/government_agencies/gov_agencies_bloc.dart';
import '../../presentations/controller/bloc/reports/reports_bloc.dart';
import '../../presentations/controller/bloc/statistics/statistics_bloc.dart';
import '../../presentations/controller/cubit/auth/login_cubit.dart';
import '../../presentations/controller/cubit/complaints/complaints_cubit.dart';
import '../../presentations/controller/cubit/employees_management/create_employees/create_email_cubit.dart';
import '../../presentations/controller/cubit/employees_management/update_employess/update_employee_cubit.dart';
import '../network/dio_client.dart';
import '../utils/token_service.dart';



/// Centralized dependency provider (lightweight).
/// You can later replace with get_it if you prefer.
class AppDependencies {
  // Shared singletons
  static final dio = DioClient.instance.dio;
  static final tokenService = TokenService();

  // DataSources
  static final loginRemoteDataSource = LoginRemoteDataSource(dio: dio);
  static final createEmailDataSource = CreateEmailDataSource(dio: dio);
  static final complaintsRemoteDateSource = ComplaintsRemoteDataSource(dio: dio);
  static final rolesRemoteDataSource = RolesRemoteDataSource(dio: dio);
  static final  employeesRemoteDataSource = ManagementEmployeesDataSource(dio: dio);
  static final statisticRemoteDataSource = StatisticReomteDataSource(dio: dio);
  static final auditRemoteDataSource = AuditRemoteDataSource(dio: dio);
  static final adminComplaintsRemoteDataSource = AdminComplaintsRemoteDataSource(dio: dio);

  // Repositories
  static final loginRepo = LoginRepo(loginRemoteDataSource);
  static final createEmailRepo = CreateEmailRepo(createEmailDataSource);
  static final complaintsRepo = ComplaintsRepository(complaintsRemoteDateSource);
  static final rolesRepository = RolesRepository(rolesRemoteDataSource);
  static final employeesRepo = ManagementEmployeeRepo(employeesRemoteDataSource);
  static final statisticRepo = StatisticRepository(statisticRemoteDataSource);
  static final auditRepo = AuditRepository(auditRemoteDataSource);
  static final adminComplaintsRepo = AdminComplaintsRepositoryImpl(adminComplaintsRemoteDataSource);

  // UseCases (domain layer)
  static final loginUseCase = LoginUseCase(loginRepo);
  static final createEmailUseCase = CreateEmailUseCase(createEmailRepo);
  static final logoutUseCase = LogoutUseCase(loginRepo);
  static final complaintsUseCase = GetComplaintsUseCase(complaintsRepo);
  static final getAdminComplaintsUseCase = GetAdminComplaintsUseCase(adminComplaintsRepo);


  // roles
  static final getRolesUseCase = GetRolesUseCase(rolesRepository);
  static final createRoleUseCase = CreateRoleUseCase(rolesRepository);
  static final deleteRoleUseCase = DeleteRoleUseCase(rolesRepository);
  static final getRoleDetailsUseCase = GetRoleDetailsUseCase(rolesRepository);
  static final assignRoleToEmployee = AssignRoleUseCase(rolesRepository);
  static final removeRoleToEmployee = RemoveRoleUseCase(rolesRepository);

  //employee
  static final getEmployeesUseCase = GetEmployeesUseCase(employeesRepo);
  static final deleteEmployeeUseCase = DeleteEmployeeUseCase(employeesRepo);
  static final updateEmployeeUseCase= UpdateEmployeeUseCase(employeesRepo);
  static final getGovernmentAgenciesUseCase = GetGovernmentAgenciesUseCase(createEmailRepo);

// permissions
  static final getPermissionsUseCase = GetPermissionsDetailsUseCase(rolesRepository);
  static final updateRolePermissionsUseCase = UpdateRolePermissionsUseCase(rolesRepository);

  static final getStatisticUseCase = GetStatisticUseCase(statisticRepo);
  static final downloadReportUseCase = DownloadReportUseCase(statisticRepo);
  static final getAuditLogsUseCase = GetAuditLogsUseCase(auditRepo);



  // Bloc providers to be used in MultiBlocProvider
  static List<BlocProvider> blocProviders() {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(loginUseCase: loginUseCase, logoutUseCase: logoutUseCase)..add(AppStarted()),
      ),
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(authBloc: context.read<AuthBloc>()),
      ),
      BlocProvider<CreateEmailBloc>(
        create: (_) => CreateEmailBloc(createEmailUseCase: createEmailUseCase),
      ),
      BlocProvider<GovAgenciesBloc>(
        create: (_) => GovAgenciesBloc(getGovernmentAgenciesUseCase),
      ),
      BlocProvider<CreateEmailCubit>(
        create: (context) => CreateEmailCubit(createEmailBloc: context.read<CreateEmailBloc>()),
      ),

      BlocProvider(
        create: (_) => ComplaintsCubit( useCase:complaintsUseCase ),
      ),
      BlocProvider<RolesBloc>(
        create: (_) => RolesBloc(
          getRolesUseCase,
          createRoleUseCase,
          deleteRoleUseCase,
          assignRoleToEmployee,
          removeRoleToEmployee
        )..add(FetchRolesEvent()),
      ),

      BlocProvider<RoleDetailsBloc>(
        create: (_) => RoleDetailsBloc(
          getRoleDetailsUseCase,
          getPermissionsUseCase,
          updateRolePermissionsUseCase,
        ),
      ),

      BlocProvider<EmployeesBloc>(
        create: (_) => EmployeesBloc(
          getEmployeesUseCase,
           deleteEmployeeUseCase,
          updateEmployeeUseCase
        ),

      ),
      BlocProvider<StatisticsBloc>(
        create: (_) => StatisticsBloc(
            getStatisticUseCase
        )..add(FetchStatisticsEvent()),
      ),
      BlocProvider<ReportsBloc>(
        create: (_) => ReportsBloc(downloadReportUseCase),
      ),
      BlocProvider<AuditBloc>(
        create: (_) => AuditBloc(getAuditLogsUseCase)..add(const FetchAuditLogsEvent(1)),
      ),
      BlocProvider<AdminComplaintsBloc>(
        create: (_) => AdminComplaintsBloc(getAdminComplaintsUseCase)..add(const FetchAdminComplaintsEvent()),
      ),

    ];
  }
}
