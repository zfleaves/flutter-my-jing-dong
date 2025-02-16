import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jingdong/components/JdButton.dart';
import 'package:flutter_jingdong/components/JdText.dart';
import 'package:flutter_jingdong/config/Config.dart';
import 'package:flutter_jingdong/services/ScreenAdapter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirstPage extends StatefulWidget {
  const RegisterFirstPage({super.key});

  @override
  State<RegisterFirstPage> createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  String tel = "";

  // 发送验证码
  sendCode() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (!reg.hasMatch(tel)) {
      return Fluttertoast.showToast(
        msg: '请输入正确的手机号码',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": tel});
    print(response); //演示期间服务器直接返回  给手机发送的验证码
    if (response.data['success']) {
      Navigator.pushNamed(context, '/registerSecond', arguments: {"tel": tel});
      return;
    }
    Fluttertoast.showToast(
      msg: '${response.data["message"]}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("用户注册-第一步"),
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenAdapter.width(20)),
          child: ListView(
            children: <Widget>[
              SizedBox(height: ScreenAdapter.height(50)),
              JdText(
                text: '请输入手机号',
                onChanged: (value) {
                  tel = value;
                },
              ),
              SizedBox(height: ScreenAdapter.height(20)),
              JdButton(
                text: '下一步',
                color: Colors.red,
                height: 74,
                cb: sendCode,
              ),
            ],
          ),
        ));
  }
}
