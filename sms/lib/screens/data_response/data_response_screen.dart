import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sms/models/data_response.dart';

import '../../common/constant.dart';

class DataResponseScreen extends StatefulWidget {
  const DataResponseScreen({Key? key}) : super(key: key);

  @override
  State<DataResponseScreen> createState() => _ListUserState();
}

class _ListUserState extends State<DataResponseScreen> {
  //hive
  Box<DataResponse>? dataBox;

  //animation
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // List<int> keys=[];
  int counter = 0;
  bool isExtended=true;

  @override
  void initState() {
    openBox();
    dataBox = Hive.box<DataResponse>(dataBoxNameResponse);
    super.initState();
  }
  openBox() async {
    await Hive.openBox<DataResponse>(dataBoxNameResponse);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body:  NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          if(notification.direction==ScrollDirection.forward){
            setState(() {
              isExtended=true;
            });
          }
          if(notification.direction==ScrollDirection.reverse){
            setState(() {
              isExtended=false;
            });
          }
          return true;
        },
        child: ValueListenableBuilder(
          valueListenable: dataBox!.listenable(),
          builder: (context, Box<DataResponse> items, _) {
            List<int> keys = items.keys.cast<int>().toList();
            return keys.isNotEmpty?AnimatedList(
              key: _listKey,
              initialItemCount: keys.length,
              itemBuilder: (context, index, animation) {
                if(keys.isNotEmpty){
                  final int key = keys[index];
                  final DataResponse? data = items.get(key);
                  return slideIt(context, index, animation, data!); // Refer step 3
                }
                return Container();
              },
            ):Padding(
              padding: const EdgeInsets.all(32.0),
              child: EmptyWidget(
                image: null,
                packageImage: PackageImage.Image_1,
                title: 'Thông báo',
                subTitle: 'Hiện không có dữ liệu',
                titleTextStyle: const TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         dataBox?.clear();
        },
        isExtended: isExtended,
        icon: const Icon(Icons.remove),
        label: const Text("Xóa tất cả"),
      ),
    );
  }

  Widget slideIt(
      BuildContext context, int index, animation, DataResponse data) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        color: Color(0xff604b9a),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 32),
                      child: Column(
                        children: [
                          Text(
                            '$index',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            '${data.time}',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.bank!.isEmpty
                              ? 'Không xác định'
                              : '${data.bank}',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.content!.isEmpty
                              ? 'Không xác định'
                              : 'N.dung:${data.content}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              height: 1.5),
                        ),
                        Text(
                          'Blance:${data.balance!.isEmpty ? '0' : '${data.balance}'}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                        Text(
                          data.error != null ? '${data.error}' : '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
