import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../common/constant.dart';
import '../../models/data_model.dart';
import '../chats/widget/custom_text_input.dart';


class ListUserTakeScreen extends StatefulWidget {
  const ListUserTakeScreen({Key? key}) : super(key: key);

  @override
  State<ListUserTakeScreen> createState() => _ListUserState();
}


class _ListUserState extends State<ListUserTakeScreen> {

  //controller
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _phoneController=TextEditingController();

  //hive
  Box<DataModel> ? dataBox;

  //animation
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  int counter=0;

  bool isExtended=true;

  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxNameTake);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
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
          builder: (context, Box<DataModel> items, _){
            List<int> keys= items.keys.cast<int>().toList();
            return keys.isNotEmpty?AnimatedList(
              key: _listKey,
              initialItemCount: keys.length,
              itemBuilder: (context, index, animation) {
                final int key = keys[index];
                final DataModel? data = items.get(key);
                return slideIt(context,index,animation,data!);
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
          _showMyDialog(textTitle: titleDialog,isUpdate: false);
        },
        isExtended: isExtended,
        icon: const Icon(Icons.add),
        label: const Text(add),
      ),
    );
  }

  Widget slideIt(BuildContext context, int index, animation,DataModel data) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name??'', style:const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          data.phone??'',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(edit),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Xóa'),
                  )
                ];
              },
              onSelected: (String value){
                if(value=='edit'){
                  _showMyDialog(textTitle: edit1,isUpdate: true,index: index,name: data.name,phone: data.phone);
                }
                else{
                  _deleteDialog(index: index,data: data);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog({String ? textTitle,String ? name,String ? phone,bool ? isUpdate,int ? index}) async {
    _nameController.text=name??'';
    _phoneController.text=phone??'';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title:  Text('$textTitle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomTextInput(
                textEditController: _nameController,
                hintTextString: nameUser,
                inputType: InputType.Default,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                maxLength: 24,
                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                errorMessage: 'Tên liên hệ không được để trống',
                labelText: 'Tên liên hệ',
              ),
              IntlPhoneField(
                decoration: InputDecoration(
                  counterText: '',
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                    gapPadding: 2,
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                    gapPadding: 2,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: 2, color:  Theme.of(context).primaryColor),
                    gapPadding: 2,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                    gapPadding: 2,
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                    gapPadding: 2,
                  ),
                  labelText: 'Số điện thoại',
                  labelStyle:  TextStyle(
                      color:  Theme.of(context).primaryColor),
                ),
                initialCountryCode: 'VN',
                invalidNumberMessage: '',
                controller: _phoneController,
                onChanged: (phone) {
                  _phoneController.text=phone.completeNumber;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(isUpdate==true?'Sửa':'Thêm'),
              onPressed: () {
                if(isUpdate==false){
                  final String name = _nameController.text;
                  final String phoneNumber = _phoneController.text;
                  _nameController.clear();
                  _phoneController.clear();
                  DataModel data = DataModel(name: name,phone: phoneNumber);
                  dataBox?.add(data);
                  _listKey.currentState?.insertItem(0,
                      duration: const Duration(milliseconds: 500));
                }
                else{
                  final String name = _nameController.text;
                  final String phoneNumber = _phoneController.text;
                  _nameController.clear();
                  _phoneController.clear();
                  DataModel data = DataModel(name: name,phone: phoneNumber);
                  dataBox?.putAt(index!,data);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hủy',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialog({int ? index,DataModel ?data}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title:  const Text('Bạn có muốn xóa liên hệ'),
          actions: <Widget>[
            TextButton(
              child:  const Text('Xóa'),
              onPressed: () {
                _listKey.currentState?.removeItem(
                    0, (_, animation) => slideIt(context, 0, animation,data!),
                    duration: const Duration(milliseconds: 500));
                dataBox?.deleteAt(index!);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hủy',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
