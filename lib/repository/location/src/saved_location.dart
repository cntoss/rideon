  import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/repository/location/src/generaltResponse.dart';

class SavedLocationService {
/* Future<PlacesSearchResponse> searchNearbyWithRadius(
    SavedAddressModel savedAddress,
    ) async {   
    return _decodeGeneralResponse(await doGet(url, headers: apiHeaders));
  } */

 GeneralResponse _decodeGeneralResponse(Response res) =>
      GeneralResponse.fromJson(json.decode(res.data));
  }  