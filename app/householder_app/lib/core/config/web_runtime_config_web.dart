import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

const String _mapsScriptId = 'google-maps-js-sdk';
const Duration _mapsLoadTimeout = Duration(seconds: 10);

Future<void> applyWebRuntimeConfig({String? mapsKey, String? googleClientId}) async {
  if (googleClientId != null && googleClientId.isNotEmpty) {
    final meta = web.document.createElement('meta') as web.HTMLMetaElement
      ..name = 'google-signin-client_id'
      ..content = googleClientId;
    web.document.head!.appendChild(meta);
  }

  if (mapsKey == null || mapsKey.isEmpty) return;
  if (web.document.getElementById(_mapsScriptId) != null) return;

  final done = Completer<void>();
  void finish() {
    if (!done.isCompleted) done.complete();
  }

  final script = web.document.createElement('script') as web.HTMLScriptElement
    ..id = _mapsScriptId
    ..src = 'https://maps.googleapis.com/maps/api/js'
        '?key=$mapsKey&libraries=marker&loading=async'
    ..async = true;
  script.addEventListener('load', ((web.Event _) => finish()).toJS);
  script.addEventListener('error', ((web.Event _) => finish()).toJS);
  web.document.head!.appendChild(script);

  await done.future.timeout(_mapsLoadTimeout, onTimeout: finish);
}