import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jingdong/services/Storage.dart';

class Cart with ChangeNotifier {
  // 购物车数据
  List<dynamic> _cartList = <dynamic>[];

  // 全选
  bool _isCheckedAll = false;

  // 总价
  double _allPrice = 0;

  List get cartList => _cartList;

  bool get isCheckedAll => _isCheckedAll;

  double get allPrice => _allPrice;

  Cart() {
    init();
  }

  // 初始化
  init() async {
    // Storage.remove('cartList');
    // 获取本地存储的数据
    try {
      List cartListData = json.decode(await Storage.getString('cartList') as String);
      _cartList = cartListData;
    } catch(e) {
      _cartList = [];
    }

    // 判断是否全选
    _isCheckedAll = isCheckAll();
  // 计算总价
    computeAllPrice();
    notifyListeners();
  }

  // 更新数据
  updateCartList() {
    // 重新获取数据
    init();
  }

  // 改变数量，重新保存
  changeItemCount() {
    Storage.setString('cartList', json.encode(_cartList));
    // 计算总价
    computeAllPrice();
    notifyListeners();
  }

  // 全选， 反选
  changeCheckAll(bool flag) {
    for (var i = 0; i < _cartList.length; i++) {
      _cartList[i]["checked"] = flag;
    }
    _isCheckedAll = flag;
    Storage.setString('cartList', json.encode(_cartList));
    // 计算总价
    computeAllPrice();
    notifyListeners();
  }

  // 判断是否全选
  isCheckAll() {
    if (_cartList.isNotEmpty) {
      for (var i = 0; i < _cartList.length; i++) {
        if (_cartList[i]["checked"] == false) {
          _isCheckedAll = false;
          break;
        } else {
          _isCheckedAll = true;
        }
      }
    } else {
      _isCheckedAll = true;
    }

    // 计算总价
    computeAllPrice();
    notifyListeners();

    return _isCheckedAll;
  }

  // 监听单个checkbox 改变
  itemChangeCheck(id, val) {
    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]['id'] == id) {
        _cartList[i]["checked"] = val;
      }
    }
    isCheckAll();
    // 计算总价
    computeAllPrice();
    notifyListeners();
    // if (isCheckAll()) {
    //   _isCheckedAll = true;
    // } else {
    //   _isCheckedAll = false;
    // }

    // // 计算总价
    // computeAllPrice();
    // Storage.setString("cartList", json.encode(_cartList));
    // notifyListeners();
  }

  // 删除单个
  removeItemById(id) {
    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]["_id"] == id) {
        _cartList.removeAt(i);
        break;
      }
    }
    Storage.setString("cartList", json.encode(_cartList));
    notifyListeners();
  }

  // 删除
  removeItem() {
    List tempList = [];
    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]["checked"] == false) {
        tempList.add(_cartList[i]);
      }
    }
    _cartList = tempList;
    Storage.setString("cartList", json.encode(_cartList));
    notifyListeners();
  }

  // 改变checkbox 状态
  changeCheckState() {
    Storage.setString("cartList", json.encode(_cartList));
    notifyListeners();
  }

  // 计算总价
  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]["checked"] == true) {
        tempAllPrice += _cartList[i]["price"] * _cartList[i]["count"];
      }
    }
    _allPrice = tempAllPrice;
    notifyListeners();
  }
}