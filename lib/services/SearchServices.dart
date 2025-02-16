import 'dart:convert';

import 'Storage.dart';

class SearchServices {
  // 设置 搜索历史
  static setHistoryData(keywords) async {
    /*
      1、获取本地存储里面的数据  (searchList)
      2、判断本地存储是否有数据
        2.1、如果有数据 
          1、读取本地存储的数据
          2、判断本地存储中有没有当前数据，
            如果有不做操作、
            如果没有当前数据,本地存储的数据和当前数据拼接后重新写入           
        2.2、如果没有数据
          直接把当前数据放在数组中写入到本地存储
    */
    try {
      List searchListData = [];
      var searchListDataString = await Storage.getString('searchList');
      if (searchListDataString != null) {
        searchListData = json.decode(searchListDataString);
      }
      var hasData = searchListData.any((v) {
        return v == keywords;
      });
      if (!hasData) {
        searchListData.add(keywords);
        await Storage.setString('searchList', json.encode(searchListData));
      }
    } catch (e) {
      List tempList = [];
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  // 获取 搜索历史
  static getHistoryList() async {
    try {
      List searchListData = [];
      var searchListDataString = await Storage.getString('searchList');
      if (searchListDataString != null) {
        searchListData = json.decode(searchListDataString);
      }
      return searchListData;
    } catch (e) {
      return [];
    }
  }

  // 清空 搜索历史
  static clearHistoryList() async {
    await Storage.remove('searchList');
  }

  // 删除 搜索历史
  static removeHistoryData(keywords) async {
    List searchListData = [];
    var searchListDataString = await Storage.getString('searchList');
    if (searchListDataString != null) {
      searchListData = json.decode(searchListDataString);
    }
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }
}
