// lib/core/utils/di.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/data/dataSource/complaints/complaints_remote_data_source.dart';
import 'package:untitled/data/repository/complaints/complaints_repository.dart';
import 'package:untitled/domain/use_cases/complaints/get_complaints_usecase.dart';
import '../../data/dataSource/auth/login_remote_data_source.dart';
import '../../data/dataSource/employees_management/create_email_data_source.dart';
import '../../data/dataSource/roles/roles_remote_data_source.dart';
import '../../data/repository/auth/login_repo.dart';
import '../../data/repository/employees_management/create_email_repo.dart';
import '../../data/repository/roles/roles_repository.dart';
import '../../domain/use_cases/auth/login_usecase.dart';
import '../../domain/use_cases/employees_managements/create_email_usecase.dart';
import '../../domain/use_cases/auth/logout_usecase.dart';
import '../../domain/use_cases/permissions/get_permissions.dart';
import '../../domain/use_cases/permissions/update_role_permissions_usecase.dart';
import '../../domain/use_cases/roles/create_role_usecase.dart';
import '../../domain/use_cases/roles/delete_role_usecase.dart';
import '../../domain/use_cases/roles/get_role_details.dart';
import '../../domain/use_cases/roles/get_roles_usecase.dart';
import '../../presentations/controller/bloc/auth/auth_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/roles/role_details_bloc.dart';
import '../../presentations/controller/bloc/employees_managements/roles/roles_bloc.dart';
import '../../presentations/controller/cubit/auth/login_cubit.dart';
import '../../presentations/controller/cubit/complaints/complaints_cubit.dart';
import '../../presentations/controller/cubit/employees_management/create_employees/create_email_cubit.dart';
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

  // Repositories
  static final loginRepo = LoginRepo(loginRemoteDataSource);
  static final createEmailRepo = CreateEmailRepo(createEmailDataSource);
  static final complaintsRepo = ComplaintsRepository(complaintsRemoteDateSource);
  static final rolesRepository = RolesRepository(rolesRemoteDataSource);

  // UseCases (domain layer)
  static final loginUseCase = LoginUseCase(loginRepo);
  static final createEmailUseCase = CreateEmailUseCase(createEmailRepo);
  static final logoutUseCase = LogoutUseCase(loginRepo);
  static final complaintsUseCase = GetComplaintsUseCase(complaintsRepo);

  // roles
  static final getRolesUseCase = GetRolesUseCase(rolesRepository);
  static final createRoleUseCase = CreateRoleUseCase(rolesRepository);
  static final deleteRoleUseCase = DeleteRoleUseCase(rolesRepository);
  static final getRoleDetailsUseCase = GetRoleDetailsUseCase(rolesRepository);

// permissions
  static final getPermissionsUseCase = GetPermissionsDetailsUseCase(rolesRepository);
  static final updateRolePermissionsUseCase = UpdateRolePermissionsUseCase(rolesRepository);

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
        )..add(FetchRolesEvent()),
      ),

      BlocProvider<RoleDetailsBloc>(
        create: (_) => RoleDetailsBloc(
          getRoleDetailsUseCase,
          getPermissionsUseCase,
          updateRolePermissionsUseCase,
        ),
      ),


    ];
  }
}
