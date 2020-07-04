import 'package:kisankonnect/models/base_model.dart';

class ServiceableResponse implements BaseModel, ServerError {
  bool _isPincodeServiceable;

  @override
  String message;

  @override
  bool isSuccess;

  bool get isPincodeServiceable => this._isPincodeServiceable;

  @override
  fromJson(Map<String, dynamic> parsedJson, bool isSuccess) {
    this.isSuccess = isSuccess;
    this.message = parsedJson['message'];
    this._isPincodeServiceable = parsedJson['isServiceable'];
    return this;
  }
}

class ServiceableBody {
  String pincode;

  ServiceableBody(this.pincode);

  toMap() {
    return {
      "pincode": pincode,
    };
  }
}
