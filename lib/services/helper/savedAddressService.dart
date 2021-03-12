import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/services/helper/hiveService.dart';

class SavedAddressService {
  Box _box = HiveService().getHiveBox();

  void saveAddress({@required SavedAddressModel savedAddressModel}) {
    List<SavedAddressModel> _list = getSavedAddress();
    _list.add(savedAddressModel);
    _box.put(hkAddressType, _list);
  }

  void editAddress({@required SavedAddressModel savedAddressModel}) {
    List<SavedAddressModel> _list = getSavedAddress();
    _list.removeWhere((element) => element.id == savedAddressModel.id);
    _list.add(savedAddressModel);
    _box.put(hkAddressType, _list);
  }

  List<SavedAddressModel> getSavedAddress() {
    List<SavedAddressModel> _list = List<SavedAddressModel>();
    List<dynamic> result = _box.get(
      hkAddressType,
      defaultValue: List<SavedAddressModel>(),
    );
    _list = result.cast();
    return _list;
  }
}
