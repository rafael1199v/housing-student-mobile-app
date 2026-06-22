# Itersapiens — Student Housing Mobile App

Itersapiens is a cross-platform **Flutter** application (web + mobile from a single codebase)
for student housing. It is built as a **microapp architecture**: a neutral *shell* host owns the
single login, session and role switching, and mounts role-specific experiences — currently the
**householder** experience (this repo) and a **student** experience consumed from a separate repo.
The backend is an **ASP.NET Core** API (REST + SignalR for real-time chat).

---

## Repository structure

This repository is a **Dart pub workspace** (`itersapiens_mobile_app`), not a single package.

```
proyecto-final/
├── app/
│   ├── shell_app/          # Neutral host app — REAL entry point (single login,
│   │                       # shared session/DI, role switch, mounts experiences)
│   └── householder_app/    # Householder experience (also runnable standalone)
├── packages/
│   └── auth/               # housing_auth — role-neutral auth (login/register/Google)
├── pubspec.yaml            # Workspace root (members + dependency_overrides)
└── .env.example            # Names of the --dart-define secrets
```

### External (git-hosted) dependencies

| Package | Source | Purpose |
| --- | --- | --- |
| `housing_core` | [`rafael1199v/housing-core-mobile`](https://github.com/rafael1199v/housing-core-mobile) `@release/1.0.0` | Shared framework-agnostic plumbing: session, network, storage, roles, errors, config. |
| `housing_design_system` | [`rafael1199v/housing-design-system`](https://github.com/rafael1199v/housing-design-system) `@main` | Shared UI/design system (themes, components). |
| `student_lib` | [`DanyElAlgo/StudentHousingApp-Student`](https://github.com/DanyElAlgo/StudentHousingApp-Student) `@feature/microapp-surface` | The **student** microapp experience (Riverpod-based). |

> **Local development of shared packages:** the root `pubspec.yaml` declares
> `dependency_overrides` pointing `housing_design_system → ../proyecto-final-design-system`
> and `housing_core → ../housing-core`. Clone those repos as **siblings** of this one if you
> need to edit them locally; otherwise remove/comment the overrides to consume the git versions.

---

## Tech stack

| Area | Technology |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.11.5`), web + Android |
| State management | `flutter_bloc` (BLoCs/Cubits in shell + householder); `flutter_riverpod` (bridge for the student microapp) |
| Dependency injection | `get_it` (single shared global container) |
| Routing | `go_router` (auth-gated, role-aware route trees) |
| Networking | `dio` + `retrofit` + `json_serializable` (generated typed API clients) |
| Auth secrets | `pointycastle` / `basic_utils` (RSA password cipher), Google Sign-In |
| Storage | `flutter_secure_storage` (tokens), `shared_preferences` (prefs e.g. theme) |
| Real-time chat | `signalr_netcore` (SignalR client) + `sqflite` (mobile cache) / in-memory (web) |
| Maps & location | `google_maps_flutter`, `geolocator`, `geocoding` (geocoding is mobile-only) |
| Media & permissions | `image_picker`, `permission_handler`, `url_launcher` |
| Observability | `firebase_core` + `firebase_crashlytics` (Android-only) |
| Localization | `flutter gen-l10n` + `intl` (ARB files: `en` / `es` / `pt`) |

---

## Prerequisites

- Flutter SDK with Dart `^3.11.5` (Flutter 3.x).
- (Optional, for editing shared packages locally) sibling checkouts:
  - `../proyecto-final-design-system` (`housing_design_system`)
  - `../housing-core` (`housing_core`)

---

## Environment configuration

Secrets are **not** read from a runtime `.env` file — they are supplied at build/run time as
`--dart-define` and read through `AppConfig` (`String.fromEnvironment`). On web, the shell injects
the Maps SDK `<script>` and Google Sign-In `<meta>` tags at startup via `applyWebRuntimeConfig`
(`app/shell_app/lib/bootstrap.dart`). The variable names match `.env.example`:

| Variable | Description |
| --- | --- |
| `BASE_URL` | Base URL of the ASP.NET Core backend (e.g. `http://localhost:5065`). |
| `GOOGLE_WEB_CLIENT_ID` | Google OAuth web client id. |
| `GOOGLE_SERVER_CLIENT_ID` | Google OAuth server client id. |
| `MAPS_WEB_API_KEY` | Google Maps JS API key (web). |
| `MAPS_CLOUD_MAP_ID` | Google Maps Cloud-based map style id. |
| `PASSWORD_PUBLIC_KEY` | RSA SPKI public key; encrypts the password on login/register. |

---

## Development commands

The runnable application is **`app/shell_app`** (it mounts the experiences). Run Flutter commands
from inside the relevant package directory, not the repo root.

```bash
cd app/shell_app

flutter pub get

# Run the full app (shell host) on Chrome with all secrets:
flutter run -d chrome \
  --dart-define=BASE_URL=http://localhost:5065 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=... \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=... \
  --dart-define=MAPS_WEB_API_KEY=... \
  --dart-define=MAPS_CLOUD_MAP_ID=... \
  --dart-define=PASSWORD_PUBLIC_KEY=...

flutter analyze     # lint (flutter_lints)
flutter test        # run tests
```

> The householder experience can also be run **standalone** from `app/householder_app`
> (it has its own `lib/main.dart`), using the same `--dart-define` set.

---

## Code generation

Retrofit API clients (`*_api.g.dart`) and `json_serializable` models are generated with
`build_runner`. Re-run after editing any `*_api.dart` or a model annotated with `@JsonSerializable`.
Generation runs **per package** — both the householder app and the auth package have generated code:

```bash
# Householder app
cd app/householder_app && dart run build_runner build --delete-conflicting-outputs

# Auth package (housing_auth)
cd packages/auth && dart run build_runner build --delete-conflicting-outputs
```

**Localization** is generated with `flutter gen-l10n` (configured via `l10n.yaml`). ARB templates
live alongside each package's i18n folder (`app_en.arb` is the template; `es` / `pt` are translations).
Add new strings to the ARB files and regenerate.

---

## Architecture

### Microapp / shell pattern

`shell_app` is a **neutral host**: it owns the single login flow, the shared `SessionNotifier`,
the active-role state, and the app-wide theme/locale. It does **not** know the internals of each
experience — instead, each experience exports route builders that the shell composes at runtime.

- The shell router (`app/shell_app/lib/router/shell_router.dart`) selects the route tree from the
  active role: `householderExperienceRoutes()` or `student.studentExperienceRoutes()`. Auth gating
  is enforced with a `_publicRoutes` allowlist and `SessionNotifier` as the `refreshListenable`.
- `RoleCubit` (`app/shell_app/lib/role/role_cubit.dart`) derives the user's roles from the token
  (`CurrentUserService`) and tracks the active role. The theme switches between
  `AppTheme.householder` and `AppTheme.student` accordingly.
- The householder experience exposes its public surface through
  `app/householder_app/lib/householder_experience.dart`
  (`householderExperienceRoutes`, `householderInitialLocation`, `registerHouseholderDependencies`).

### Shared DI + Riverpod bridge

All experiences share a single `get_it` container (`configureDependencies()` runs in the shell's
`bootstrap()`). The shell then registers role-specific singletons (`RoleApi`, `RoleService`,
`RoleCubit`, `RoleSwitchController`).

The student microapp is **Riverpod-based**, so the shell wraps the app in a `ProviderScope` and
bridges shared services via provider overrides (`app/shell_app/lib/app.dart`):
`dioProvider`, `localeHookProvider`, `logoutHookProvider`, `changeRoleHookProvider`. This lets the
student microapp reuse the shared `Dio`, locale, logout and change-role behavior without depending
on the shell's structure.

### Clean architecture by feature (householder)

Inside `app/householder_app/lib/features/<feature>/` (`booking`, `chat`, `home`, `profile`, `rooms`):

- `data/` — `datasources/` (Retrofit `*_api.dart`), `models/` (DTOs), `repositories/` (impls)
- `domain/` — `entities/`, `repositories/` (abstract interfaces), `usecases/`
- `presentation/` — `blocs/`/`cubits/`, `pages/`, `widgets/`
- `di/<feature>_module.dart` and a `<feature>.dart` barrel

Dependency direction: presentation → domain ← data. BLoCs/Cubits are `registerFactory`;
services/repositories/use-cases are `registerLazySingleton`.

### Networking & token refresh

`housing_core` provides the shared `Dio` and `AuthInterceptor`, which attaches the access token and,
on `401`, refreshes via a separate client to avoid interceptor recursion. On refresh failure it
signs the session out (`SessionNotifier`), which triggers the router redirect back to login.
Tokens are persisted in `flutter_secure_storage`.

### Platform abstraction (web vs. mobile)

Cross-platform services use conditional imports: a `*_factory.dart` selects
`*_stub.dart` / `*_web.dart` / `*_mobile.dart` via `if (dart.library.js_interop)` /
`if (dart.library.io)`. This covers connectivity, Google Sign-In, location, and chat local storage
(sqflite on mobile, in-memory on web). Narrow cases (e.g. geocoding being mobile-only) are guarded
with `kIsWeb`.

### Real-time chat

Chat uses ASP.NET Core **SignalR** (`signalr_netcore`) for live messages, backed by a local cache
(sqflite on mobile / in-memory on web) for history and offline use.

### Localization

`flutter gen-l10n` generates `AppLocalizations` from ARB files (`en` / `es` / `pt`). A `LocaleCubit`
controls the active locale; `intl` handles formatting.

### Crash reporting

Firebase Crashlytics is initialized **once at the shell level** so uncaught errors from both mounted
microapps are captured. It is **Android-only** (no web SDK), so all Crashlytics calls are guarded
with `kIsWeb`.

---

## Integrations with other apps

- **Student microapp (`student_lib`)** — a separate repo, Riverpod-based, mounted by the shell via
  `ProviderScope` hook overrides. The shell provides the shared `Dio`, locale, logout and
  change-role behavior; the student app contributes its own routes and localization delegate.
- **`housing_core`** — shared plumbing (session, network, storage, roles, errors, config) consumed
  by both the shell and the householder app.
- **`housing_design_system`** — shared themes and UI components across experiences.
- **Backend** — ASP.NET Core API: REST endpoints (via Retrofit clients) + SignalR hub for chat.
