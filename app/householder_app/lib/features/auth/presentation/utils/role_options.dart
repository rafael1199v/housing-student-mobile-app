import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';

final List<AppRole> kSelectableRoles = <AppRole>[
  AppRole.householder,
  AppRole.student,
].where(RoleHierarchy.selfAssignable.contains).toList(growable: false);

final String kDefaultRoleValue = AppRole.householder.wire;

String roleOptionLabel(AppLocalizations l10n, String wire) =>
    switch (AppRole.fromWire(wire)) {
      AppRole.student => l10n.roleStudent,
      AppRole.householder => l10n.roleHouseholder,
      AppRole.admin => l10n.roleAdmin,
      null => wire,
    };

List<AppDropdownItem<String>> roleOptions(AppLocalizations l10n) => [
      for (final role in kSelectableRoles)
        AppDropdownItem(value: role.wire, label: roleOptionLabel(l10n, role.wire)),
    ];
