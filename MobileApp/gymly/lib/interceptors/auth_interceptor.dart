import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AuthInterceptor implements InterceptorContract {
  final Authentication authentication;
  final FlutterSecureStorage storage;

  const AuthInterceptor({required this.authentication, required this.storage});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String accessToken = "";

    if (await storage.containsKey(key: "accessToken")) {
      accessToken = (await storage.read(key: "accessToken")) ?? "";
      await storage.delete(key: "accessToken");
    } else if (authentication.accessToken != null) {
      accessToken = authentication.accessToken!;
    }

    data.headers["Authorization"] = "Bearer $accessToken";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  AuthenticationNotifier authNotifier;

  ExpiredTokenRetryPolicy(this.authNotifier);

  @override
  int get maxRetryAttempts {
    return 2;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      print("LOG: REFRESHING...");
      return await authNotifier.refresh(useStorage: true);
    }
    return false;
  }
}
