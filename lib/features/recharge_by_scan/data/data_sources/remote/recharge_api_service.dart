import 'package:recharge_by_scan/core/constants/constants.dart';
import "package:dio/dio.dart";

class RechargeApiService {
  late final Dio _dio;
  RechargeApiService(){
    _dio = Dio()
        ..options.baseUrl = rechargeApiBaseURL
        ..interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true
          ),
        );
  }
}