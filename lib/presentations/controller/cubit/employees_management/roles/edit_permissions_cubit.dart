// edit_permissions_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_permissions_state.dart';

class EditPermissionsCubit extends Cubit<EditPermissionsState> {
  EditPermissionsCubit({
    required Set<int> initialSelectedIds,
  }) : super(EditPermissionsState(selectedIds: initialSelectedIds));

  void toggle(int permissionId) {
    final updated = Set<int>.from(state.selectedIds);

    if (updated.contains(permissionId)) {
      updated.remove(permissionId);
    } else {
      updated.add(permissionId);
    }

    emit(state.copyWith(selectedIds: updated));
  }
}
