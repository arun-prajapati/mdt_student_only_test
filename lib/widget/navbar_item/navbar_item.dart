import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datamodels/navbar_item_model.dart';
import '../../locater.dart';
import '../../responsive/screen_type_layout.dart';
import '../../services/navigation_service.dart';
import 'navbar_item_mobile.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;
  final IconData? icon;
  final BuildContext context_;
  const NavBarItem(this.title, this.navigationPath, this.context_, {this.icon});

  @override
  Widget build(BuildContext context) {
    var model = NavBarItemModel(
      title: title,
      navigationPath: navigationPath,
      iconData: icon!,
    );
    return GestureDetector(
      onTap: () {
        print('Push/Pop');
        // DON'T EVER USE A SERVICE DIRECTLY IN THE UI TO CHANGE ANY KIND OF STATE
        // SERVICES SHOULD ONLY BE USED FROM A VIEW MODEL
        // Navigator.pop(context);
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => TheoryTab()));
        locator<NavigationService>().navigateTo(navigationPath);
      },
      child: Provider.value(
        value: model,
        child: ScreenTypeLayout(
            mobile: NavBarItemMobile(),
            key: null,
            tablet: NavBarItemMobile(),
            desktop: NavBarItemMobile()),
      ),
    );
  }
}
