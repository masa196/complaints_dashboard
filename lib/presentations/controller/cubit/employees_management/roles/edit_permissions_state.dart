// edit_permissions_state.dart
part of 'edit_permissions_cubit.dart';

class EditPermissionsState extends Equatable {
  final Set<int> selectedIds;

  const EditPermissionsState({required this.selectedIds});

  EditPermissionsState copyWith({
    Set<int>? selectedIds,
  }) {
    return EditPermissionsState(
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [selectedIds];
}
