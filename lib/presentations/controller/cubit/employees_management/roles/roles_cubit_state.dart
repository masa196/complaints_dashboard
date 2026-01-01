part of 'roles_cubit.dart';

class RolesCubitState extends Equatable {
  final List<String> selectedRoles;
  final bool isLoading;

  const RolesCubitState({required this.selectedRoles, this.isLoading = false});

  RolesCubitState copyWith({List<String>? selectedRoles, bool? isLoading}) {
    return RolesCubitState(
      selectedRoles: selectedRoles ?? this.selectedRoles,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedRoles, isLoading];
}
