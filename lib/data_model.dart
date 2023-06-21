import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class DataModel with ChangeNotifier {
  Map<String, dynamic> data = {};
  int cindex = 0;

  final LocalStorage _storage = LocalStorage("DB");

  void setIndex(int index) {
    cindex = index;
    _storage.setItem('cindex', index);
    // notifyListeners();
  }

  Future<bool> isReady() {
    return _storage.ready;
  }

  Stream<dynamic> dataStream() {
    return _storage.stream;
  }

  void setData(Map<String, dynamic> streamData) {
    data = streamData["Data"] ?? {};
    cindex = streamData["cindex"] ?? 0;
    // notifyListeners();
  }

  Future<bool> createNewKey(String key) async {
    if (data.containsKey(key.toString())) {
      // throw Exception('Duplicate Key');
      return false;
    }
    try {
      data[key] = [];
      await _storage.setItem("Data", data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setKeyData(String key, String newValue) async {
    try {
      data[key]?.add(newValue);
      await _storage.setItem("Data", data);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> deleteKeyData(String key, int index) async {
    try {
      data[key]?.removeAt(index);
      await _storage.setItem("Data", data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteKey(String key) async {
    data.remove(key);
    try {
      await _storage.setItem("Data", data);
      setIndex(0);

      return true;
    } catch (e) {
      return false;
    }
  }
}
