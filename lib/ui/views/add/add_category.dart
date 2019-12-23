import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar/core/models/category.dart';
import 'package:gym_bar/core/view_models/category_model.dart';
import 'package:gym_bar/ui/shared/ui_helpers.dart';
import 'package:gym_bar/ui/views/base_view.dart';
import 'package:gym_bar/ui/widgets/form_widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var downURL;
  var file;

  final TextEditingController name = TextEditingController();

  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//الجمله, سعر القطعه
    Widget forms() {
      return Card(
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            logSignTextField(hint: "اسم نوع المنتج", controller: name),
            UIHelper.verticalSpaceMedium(),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 10),
      );
    }

    Future getImage(String source) async {
      // MyApp().checkPermissions();
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
      return file;
    }

    uploadImage() async {
      if (file != null) {
        int random = Random().nextInt(1000000000000);
        StorageReference ref =
            FirebaseStorage.instance.ref().child("image_$random.jpg");
        StorageUploadTask uploadTask = ref.putFile(file);
        downURL = await (await uploadTask.onComplete).ref.getDownloadURL();
        print(downURL.toString());
        return downURL;
      } else
        print("ds;klfjhsio;kr");
    }

    Widget addPhoto() {
      return GestureDetector(
          onTap: () => getImage(""),
          child: file == null
              ? logo(AssetImage("assets/images/add.jpg"))
              : logo(FileImage(file)));
    }

    return BaseView<CategoryModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("إضافة نوع المنتج"),
        ),
        body: ListView(
          children: <Widget>[
            addPhoto(),
            forms(),
            logSignButton(
                context: context,
                onTab: () {
                  print("dataaaaa2aaaaaah");
                  print("{name is: ${name.text} }");
                  model.addCategory(Category(
                    photo: "photo",
                    name: name.text,
                  ));
                  dispose();
                },
                text: "Add Category"),
            UIHelper.verticalSpaceMedium(),
          ],
        ),
      ),
    );
  }
}
