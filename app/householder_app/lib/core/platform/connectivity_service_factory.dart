import 'connectivity_service.dart';
import 'connectivity_service_stub.dart'
    if (dart.library.js_interop) 'connectivity_service_web.dart'
    if (dart.library.io) 'connectivity_service_mobile.dart';

ConnectivityService createConnectivityService() =>
    createConnectivityServiceImpl();
