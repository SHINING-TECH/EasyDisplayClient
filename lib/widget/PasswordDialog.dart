import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../database/database_manager.dart';
import '../l10n/localization.dart';

// 抽象出密码输入对话框类
class PasswordDialog {
  static Future<void> show(BuildContext context,String psw,Function onPasswordCorrect) async {
    String inputPassword = '';
    bool showAsterisks = true; // 控制是否显示 * 号
    Timer? countdownTimer;
    int remainingSeconds = 30;


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须交互才能关闭对话框
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // 启动倒计时
            if (countdownTimer == null) {
              countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() {
                  if (remainingSeconds > 0) {
                    remainingSeconds--;
                  } else {
                    timer.cancel();
                    Navigator.of(context).pop();
                  }
                });
              });
            }
            return AlertDialog(
              // 设置形状为直角
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${L10n.getString(context, 'psw_dialog_title')}'),
                  Text('($remainingSeconds)'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    showAsterisks ? '*' * inputPassword.length : inputPassword,
                    style: const TextStyle(fontSize: 24),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAsterisks = !showAsterisks;
                      });
                    },
                    child: Text(showAsterisks ? '${L10n.getString(context, 'psw_dialog_show_psw')}' : '${L10n.getString(context, 'psw_dialog_hide_psw')}'),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      buildNumberRow([1, 2, 3], inputPassword, (newPassword) {
                        setState(() {
                          inputPassword = newPassword;
                        });
                      }),
                      buildNumberRow([4, 5, 6], inputPassword, (newPassword) {
                        setState(() {
                          inputPassword = newPassword;
                        });
                      }),
                      buildNumberRow([7, 8, 9], inputPassword, (newPassword) {
                        setState(() {
                          inputPassword = newPassword;
                        });
                      }),
                      buildNumberRow([0, null], inputPassword, (newPassword) {
                        setState(() {
                          inputPassword = newPassword;
                        });
                      }),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('${L10n.getString(context, 'cancel')}'),
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('${L10n.getString(context, 'confirm')}'),
                  onPressed: () {
                    if (inputPassword == psw) {
                      countdownTimer?.cancel();
                      Navigator.of(context).pop();
                      onPasswordCorrect();
                    } else {
                      print("输入密码错误");
                      CherryToast.error(
                          title:  Text('${L10n.getString(context, 'password_error')}', style: TextStyle(color: Colors.black))
                      ).show(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget buildNumberRow(List<int?> numbers, String currentPassword, Function(String) onUpdate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number != null) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  onUpdate(currentPassword + number.toString());
                },
                child: Text(number.toString()),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  if (currentPassword.isNotEmpty) {
                    onUpdate(currentPassword.substring(0, currentPassword.length - 1));
                  }
                },
                child: const Text('⌫'),
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}