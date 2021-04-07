import 'package:flutter/material.dart';

class FunctionWidgets {
  static chooseImageProvider({BuildContext context, Function gallery, Function camera}){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallerie'),
                    onTap: () {
                      gallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    camera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}