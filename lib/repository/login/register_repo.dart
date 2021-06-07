import 'package:dio/dio.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/user/userModel.dart';

class RegisterRequest {
  registerRequest(User user) async {
    print(user.toJson());
    try {
      var response = await Dio().post(baseUrl + '/register',
          options: Options(
            contentType: "application/json",
          ),
          data: user.toJson());
      return (response.data)['token'];
    } on DioError catch (error) {
      if (error.response != null) {
        print((error.response!.data));
        return null;
      } else {
        return null;
      }
    }
  }
}
