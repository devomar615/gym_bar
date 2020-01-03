import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar/core/enums/viewstate.dart';
import 'package:gym_bar/core/view_models/category_model.dart';
import 'package:gym_bar/core/view_models/product_model.dart';
import 'package:gym_bar/ui/shared/text_styles.dart';
import 'package:gym_bar/ui/shared/ui_helpers.dart';
import 'package:gym_bar/ui/views/base_view.dart';
import 'package:gym_bar/ui/widgets/form_widgets.dart';

class AddPurchase extends StatefulWidget {
  final String branchName;

  AddPurchase({this.branchName});

  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  String _selectedPurchaseType;
  String _selectedCategory;
  List<String> _selectedProduct = ["", "", ""];
  int _selectedUnit;
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController notes = TextEditingController();
  var value2;

  @override
  Widget build(BuildContext context) {
    actions() {
      return Column(
        children: <Widget>[
          formButtonTemplate(
              context: context, onTab: () {}, text: "إتمام العملية"),
          UIHelper.verticalSpaceMedium(),
          formButtonTemplate(
              context: context,
              onTab: () {},
              text: "إلغاء",
              color: Colors.grey),
          UIHelper.verticalSpaceMedium(),
        ],
      );
    }

    dropDownPurchaseType() {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "اختر نوع الشراء",
              style: formLabelsStyle,
            ),
            value: _selectedPurchaseType,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _selectedPurchaseType = value;
                _selectedCategory = null;
                _selectedProduct = ["", "", ""];
                _selectedUnit = null;
                price.clear();
                quantity.clear();
              });
              print(value);
            },
            items: <String>["شراء عادي", "سحب شخصي"].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget handlePersonalWithdrawals() {
      return Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          formTextFieldTemplate(hint: "السعر المدفوع", controller: price),
          UIHelper.verticalSpaceMedium(),
          formTextFieldTemplate(hint: "ملاحظات", controller: notes),
          SizedBox(height: 300),
          actions(),
        ],
      );
    }

    dropDownCategory() {
      return BaseView<CategoryModel>(
          onModelReady: (model) => model.fetchCategories(),
          builder: (context, model, child) => model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            "اختر نوع المنتج",
                            style: formLabelsStyle,
                          ),
                          value: _selectedCategory,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                              _selectedProduct = ["", "", ""];
                              _selectedUnit = null;
                              quantity.clear();
                            });
                          },
                          items: model.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: "${category.name}",
                              child: Text(
                                "${category.name}",
                              ),
                            );
                          }).toList()))));
    }

    // ignore: missing_return
    handleDropDownCategory() {
      if (_selectedPurchaseType == null) {
        return Container();
      } else if (_selectedPurchaseType == "سحب شخصي") {
        return handlePersonalWithdrawals();
      } else if (_selectedPurchaseType == "شراء عادي" &&
          _selectedCategory == null) {
        return Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            dropDownCategory(),
          ],
        );
      } else if (_selectedPurchaseType != null && _selectedCategory != null) {
        return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_selectedCategory, style: dropDownLabelsStyle),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                        _selectedProduct = ["", "", ""];
                        _selectedUnit = null;
                        quantity.clear();
                      });
                    },
                    child: Icon(CupertinoIcons.clear_circled_solid)),
              ],
            ));
      }
    }

    dropDownProduct() {
      return BaseView<ProductModel>(
          onModelReady: (model) => model.fetchProducts(
              branchName: "${widget.branchName}",
              categoryName: _selectedCategory),
          builder: (context, model, child) => model.state == ViewState.Busy
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<List<String>>(
                    isExpanded: true,
                    hint: _selectedProduct[2].length < 1
                        ? Text(
                            "اختر المنتج",
                            style: dropDownLabelsStyle,
                          )
                        : Text(
                            _selectedProduct[2],
                            style: dropDownLabelsStyle,
                          ),
                    value: value2,
                    isDense: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedProduct = value;
                        _selectedUnit = null;
                        quantity.clear();
                      });
                    },
                    items: model.products.map((products) {
                      return DropdownMenuItem<List<String>>(
                        value: <String>[
                          products.unit,
                          products.wholesaleUnit,
                          products.name,
                        ],
                        child: Text(
                          "${products.name}",
                        ),
                      );
                    }).toList(),
                  ))));
    }

    setSelectedRadio(int val) {
      setState(() {
        _selectedUnit = val;
      });
    }

    radioUnit() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _selectedUnit,
                      onChanged: (value) {
                        setSelectedRadio(value);
                      },
                    ),
                    Text(_selectedProduct[0]),
                  ],
                )),
              ),
              Expanded(
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Radio(
                        value: 2,
                        groupValue: _selectedUnit,
                        onChanged: (value) {
                          setSelectedRadio(value);
                        }),
                    Text(_selectedProduct[1]),
                  ],
                )),
              ),
            ],
          )
        ],
      );
    }

    Widget forms() {
      return Card(
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            dropDownPurchaseType(),
            Column(
              children: <Widget>[
                handleDropDownCategory(),
                UIHelper.verticalSpaceMedium(),
              ],
            ),
            _selectedCategory == null || _selectedCategory.length < 1
                ? Container()
                : Column(
                    children: <Widget>[
                      dropDownProduct(),
                      UIHelper.verticalSpaceMedium(),
                    ],
                  ),
            _selectedProduct[1].length < 1
                ? Container()
                : Column(
                    children: <Widget>[
                      radioUnit(),
                      UIHelper.verticalSpaceMedium(),
                    ],
                  ),
            _selectedProduct[1].length < 1
                ? Container()
                : Column(
                    children: <Widget>[
                      formTextFieldTemplate(
                        controller: quantity,
                        hint: _selectedUnit == 1
                            ? "كمية ال ${_selectedProduct[0]}"
                            : "كمية ال ${_selectedProduct[1]}",
                      ),
                      UIHelper.verticalSpaceMedium(),
                    ],
                  ),
            _selectedProduct[1].length < 1
                ? Container()
                : Column(
                    children: <Widget>[
                      formTextFieldTemplate(
                        controller: price,
                        hint: "السعر المدفوع",
                      ),
                      SizedBox(
                        height: 160,
                      ),
                      actions(),
                    ],
                  ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("اضافة عملية شراء" + " (${widget.branchName})"),
        ),
        body: ListView(
          children: <Widget>[
            forms(),
          ],
        ));
  }
}
