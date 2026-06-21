import 'package:housing_core/housing_core.dart';

String roleLabel(AppRole role) => switch (role) {
  AppRole.householder => 'Propietario',
  AppRole.student => 'Estudiante',
  AppRole.admin => 'Administrador',
};

String roleErrorMessage(Failure failure) {
  if (failure is BusinessFailure) {
    switch (failure.code) {
      case RoleErrorCodes.alreadyAssigned:
        return 'Ya tienes ese rol.';
      case RoleErrorCodes.notAssignable:
        return 'No puedes adquirir ese rol.';
      case RoleErrorCodes.invalid:
        return 'Rol no válido.';
      case RoleErrorCodes.assignmentFailed:
        return 'No se pudo asignar el rol. Inténtalo de nuevo.';
    }
  }
  if (failure is NetworkFailure) return 'Sin conexión. Revisa tu red.';
  return 'Ocurrió un error. Inténtalo de nuevo.';
}
