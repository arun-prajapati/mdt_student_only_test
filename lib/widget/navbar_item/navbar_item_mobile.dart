import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../datamodels/navbar_item_model.dart';

class NavBarItemMobile extends ViewModelWidget<NavBarItemModel> {
  final double? textWidth;
  NavBarItemMobile({this.textWidth});
  @override
  Widget build(BuildContext context, NavBarItemModel model) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        //color: Colors.red,
        margin: EdgeInsets.fromLTRB(
            constraints.maxWidth * 0.05, 0, constraints.maxWidth * 0.05, 0),

        child: Row(
          children: <Widget>[
            Container(
              width: constraints.maxWidth * 0.08,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    model.iconData,
                    size: 20,
                  )),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.05,
            ),
            LayoutBuilder(builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  model.title,
                  style: TextStyle(fontSize: 14),
                ),
              );
            })
          ],
        ),
      );
    });
  }
}
