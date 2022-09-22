import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../models/data_model.dart';
import '../chats/widget/custom_text_input.dart';
const String dataBoxName = "data";

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}


class _ListUserState extends State<ListUser> {

  //controller
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _phoneController=TextEditingController();

  //hive
  Box<DataModel> ? dataBox;

  //animation
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  // List<int> keys=[];
  int counter=0;

  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (context, Box<DataModel> items, _){
          List<int> keys= items.keys.cast<int>().toList();
          return AnimatedList(
            key: _listKey,
            initialItemCount: keys.length,
            itemBuilder: (context, index, animation) {
              final int key = keys[index];
              final DataModel? data = items.get(key);
              return slideIt(context,index,animation,data!); // Refer step 3
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMyDialog(textTitle: 'Thêm liên hệ nhận tin nhắn',isUpdate: false);
        },
        icon: const Icon(Icons.add),
        label: const Text("Thêm"),
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
                    child: Text('Sửa'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Xóa'),
                  )
                ];
              },
              onSelected: (String value){
                if(value=='edit'){
                  _showMyDialog(textTitle: 'Sửa liên hệ',isUpdate: true,index: index,name: data.name,phone: data.phone);
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
                hintTextString: 'Tên liên hệ',
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
