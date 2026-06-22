import 'package:housing_core/housing_core.dart' hide Credentials;
import 'package:housing_design_system/housing_design_system.dart';

import '../../l10n/gen/auth_localizations.dart';

final List<AppRole> kSelectableRoles = <AppRole>[
  AppRole.householder,
  AppRole.student,
].where(RoleHierarchy.selfAssignable.contains).toList(growable: false);

final String kDefaultRoleValue = AppRole.householder.wire;

String roleOptionLabel(AuthLocalizations l10n, String wire) =>
    switch (AppRole.fromWire(wire)) {
      AppRole.student => l10n.roleStudent,
      AppRole.householder => l10n.roleHouseholder,
      AppRole.admin => l10n.roleAdmin,
      null => wire,
    };

List<AppDropdownItem<String>> roleOptions(AuthLocalizations l10n) => [
      for (final role in kSelectableRoles)
        AppDropdownItem(value: role.wire, label: roleOptionLabel(l10n, role.wire)),
    ];
