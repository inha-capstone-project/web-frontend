import 'package:flutter/material.dart';
import '../../data/datas.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Build your own app'),
      ),
      // Draggable로 이동된 데이터를 받아주는 함수
      body: DragTarget(
        builder: (context, candidateData, rejectedData) {
          // 위젯을 이동할 수 있도록 하는 위젯
          return ReorderableListView.builder(
            itemBuilder: (context, index) {
              return widgetList[index];
            },
            itemCount: widgetList.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              setState(
                () {
                  final item = widgetList.removeAt(oldIndex);
                  widgetList.insert(newIndex, item);
                },
              );
            },
          );
        },
        // 받아온 데이터를 어떻게 처리할 것인가 부분
        onAccept: (int data) {
          setState(
            () {
              // 각 케이스로 0 ~ n 까지의 값들을 처리
              switch (data) {
                case 0:
                  widgetList.add(
                    containerTemplate(
                        index: key,
                        child: Image.network(
                            'https://scsgozneamae10236445.cdn.ntruss.com/data2/content/image/2021/08/29/.cache/512/202108291158953.jpg')),
                  );
              }
              key += 1;
            },
          );
        },
      ),
    );
  }
}