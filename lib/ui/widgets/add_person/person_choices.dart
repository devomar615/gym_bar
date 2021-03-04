import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:gym_bar/core/services/add_person_services.dart';import 'package:gym_bar/ui/shared/dimensions.dart';import 'package:gym_bar/ui/shared/text_styles.dart';import 'package:gym_bar/ui/widgets/form_widgets.dart';import 'package:image_picker/image_picker.dart';import 'package:provider/provider.dart';import 'dart:io';File file;class PersonChoicesCard extends StatelessWidget {  final formKey;  const PersonChoicesCard({Key key, this.formKey}) : super(key: key);  @override  Widget build(BuildContext context) {    FormWidget _formWidget = FormWidget(context: context);    Dimensions _dimensions = Dimensions(context);    TextStyles _textStyles = TextStyles(context: context);    AddPersonServices addPersonServices = Provider.of<AddPersonServices>(context);    var selectedPersonType = addPersonServices.selectedPersonType;    Future getImage(String source) async {      ImagePicker imagePicker = ImagePicker();      PickedFile pickedFile;      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);      file = File(pickedFile.path);      return file;    }    Widget addPhoto() {      return GestureDetector(          onTap: () => getImage(""),          child: file == null              ? _formWidget.logo(imageContent: Image.asset("assets/images/add.jpg"))              : _formWidget.logo(imageContent: Image.file(file)));    }    List<Widget> personTypeChoices() {      return [        ChoiceChip(          padding: EdgeInsets.symmetric(              horizontal: _dimensions.widthPercent(5), vertical: _dimensions.heightPercent(0.4)),          labelStyle: _textStyles.chipLabelStyleLight(),          selectedColor: Colors.blue,          backgroundColor: Colors.white,          shape: StadiumBorder(            side: BorderSide(color: Colors.blue),          ),          label: Text("موظف"),          selected: selectedPersonType == "موظف",          onSelected: (_) => addPersonServices.selectedPersonType = "موظف",        ),        SizedBox(width: _dimensions.widthPercent(2)),        ChoiceChip(          padding: EdgeInsets.symmetric(              horizontal: _dimensions.widthPercent(5), vertical: _dimensions.heightPercent(0.4)),          labelStyle: _textStyles.chipLabelStyleLight(),          backgroundColor: Colors.white,          selectedColor: Colors.blue,          shape: StadiumBorder(side: BorderSide(color: Colors.blue)),          label: Text("عميل"),          selected: selectedPersonType == "عميل",          onSelected: (_) => addPersonServices.selectedPersonType = "عميل",        ),      ];    }    return Card(      elevation: 2,      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),      child: Center(        child: Form(            key: formKey,            child: Column(              mainAxisAlignment: MainAxisAlignment.spaceEvenly,              children: [                Text("اضف صوره"),                addPhoto(),                Text("اختر نوع الشخص"),                Row(                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,                  children: personTypeChoices(),                ),                if (addPersonServices.selectedPersonType == "موظف")                  _formWidget.formTextFieldTemplate(                    hint: "ايميل الموظف",                    controller: addPersonServices.email,                    maxLength: 500,                    validator: (value) {                      if (!RegExp(                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")                          .hasMatch(value)) {                        return "ادخل ايميل صحيح";                      }                      if (value.isEmpty) {                        return "برجاء ملأ جميع الخانات";                      }                      if (value.length > 500) {                        return "الاسم كبير جدا";                      }                    },                  ),                if (addPersonServices.selectedPersonType == "موظف")                  _formWidget.formTextFieldTemplate(                    hint: "كلمة السر",                    controller: addPersonServices.password,                    secure: true,                    validator: (value) {                      if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')                          .hasMatch(value)) {                        return "ادخل كلمة سر صحيحة";                      }                      if (value.isEmpty) {                        return "برجاء ملأ جميع الخانات";                      }                      if (value.length > 50) {                        return "الاسم كبير جدا";                      }                    },                  ),              ],            )),      ),    );  }}