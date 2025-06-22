import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingV2Page extends StatefulWidget {
  const SettingV2Page({super.key});

  @override
  State<SettingV2Page> createState() => _SettingV2PageState();
}

class _SettingV2PageState extends State<SettingV2Page> {
  String _selectedLanguage = 'en'; // 默认英文
  final List<FocusNode> _focusNodes = List.generate(2, (index) => FocusNode());
  final List<bool> _isFocused = List.generate(2, (index) => false);

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('设置'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            int? focusedIndex;
            // 遍历 _focusNodes 找出当前获得焦点的 Item 索引
            for (int i = 0; i < _focusNodes.length; i++) {
              if (_focusNodes[i].hasFocus) {
                focusedIndex = i;
                break;
              }
            }
            if (focusedIndex != null) {
              print('遥控器按键按下: ${event.logicalKey}，当前焦点在设置项 ${focusedIndex + 1}');
            } else {
              print('遥控器按键按下: ${event.logicalKey}，当前没有 Item 获得焦点');
            }
          }
        },
        child: GridView.builder(
          // 使用自定义的 SliverGridDelegate
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 一行显示 5 个 Item
            crossAxisSpacing: 10, // 水平方向间隔
            mainAxisSpacing: 10, // 垂直方向间隔
            childAspectRatio: (screenWidth / 5) / 80, // 计算宽高比
          ),
          padding: const EdgeInsets.all(16),
          itemCount: 2,
          itemBuilder: (context, index) {
            return FocusableActionDetector(
              focusNode: _focusNodes[index],
              onShowFocusHighlight: (isFocused) {
                setState(() {
                  _isFocused[index] = isFocused;
                });
              },
              child: GestureDetector(
                onTap: () {
                  // 处理点击事件
                  _handleTap(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isFocused[index] ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    // 根据焦点状态设置文字样式
                    child: Text(
                      '设置项 ${index + 1}',
                      style: TextStyle(
                        color: _isFocused[index] ? Colors.blue : Colors.black,
                        fontSize: _isFocused[index] ? 18 : 16,
                        fontWeight: _isFocused[index] ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTap(int index) {
    // 根据不同的 index 处理不同设置项的点击逻辑
    print('点击了设置项 ${index + 1}');
  }
}