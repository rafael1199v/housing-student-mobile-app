import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/dashboard_summary_dto.dart';

part 'dashboard_api.g.dart';

@RestApi()
abstract class DashboardApi {
  factory DashboardApi(Dio dio, {String baseUrl}) = _DashboardApi;

  @GET('/api/dashboard/summary')
  Future<DashboardSummaryDto> getDashboardSummary();
}
