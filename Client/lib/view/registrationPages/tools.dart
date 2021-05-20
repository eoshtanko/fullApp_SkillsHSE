import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildIm() => Container( alignment: Alignment.bottomLeft,
  // child: Flexible(
  child:
  Image(
    image: AssetImage(
      'assets/images/22.png',
    ),
    height: 142.0,
    width: 142.0,
 // ),
),
);

Widget buildIm2() => Container( alignment: Alignment.bottomRight,
  //child: Flexible(
  child:  Image(
    image: AssetImage(
      'assets/images/222.png',
    ),
    height: 142.0,
    width: 142.0,
 // ),
),
);

Widget enterButtonArea(void submit()) => MaterialButton(
  onPressed: submit,
  child: Container(
    width: 400,
    margin: const EdgeInsets.only(
      left: 20,
      right: 20,
      top: 40,
    ),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 2,
          offset: Offset(1, 1),
        ),
      ],
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[100],
    ),
    child: Text(
      'Дальше',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
  ),
);

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Widget dropDownMenu(String dropdownValue,
    bool isCorrect, String txt, void onChange(String val), List<String> lst, double size){
  return Container(
      margin: const EdgeInsets.only(top: 40, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: isCorrect ? Colors.grey : Colors.red),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            hint: Text(txt),
            elevation: 16,
            itemHeight: size == 0? null: size,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: onChange,
            items: lst.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}