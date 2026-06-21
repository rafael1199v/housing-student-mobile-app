import 'package:householder_app/core/core.dart' show AppLocalizations;
import 'package:housing_core/housing_core.dart';

String roleLabel(AppLocalizations l10n, AppRole role) => switch (role) {
  AppRole.householder => l10n.roleHouseholder,
  AppRole.student => l10n.roleStudent,
  AppRole.admin => l10n.roleAdmin,
};

String roleErrorMessage(AppLocalizations l10n, Failure failure) {
  if (failure is BusinessFailure) {
    switch (failure.code) {
      case RoleErrorCodes.alreadyAssigned:
        return l10n.roleErrAlreadyAssigned;
      case RoleErrorCodes.notAssignable:
        return l10n.roleErrNotAssignable;
      case RoleErrorCodes.invalid:
        return l10n.roleErrInvalid;
      case RoleErrorCodes.assignmentFailed:
        return l10n.roleErrAssignmentFailed;
    }
  }
  if (failure is NetworkFailure) return l10n.errNetwork;
  return l10n.roleErrGeneric;
}
