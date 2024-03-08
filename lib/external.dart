import 'dart:convert';

import 'package:Smart_Theory_Test/responsive/size_config.dart';
import 'package:Smart_Theory_Test/style/global_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'Constants/app_colors.dart';

class External extends StatelessWidget {
  const External({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TypeAheadField(
        debounceDuration: const Duration(milliseconds: 0),
        animationDuration: const Duration(milliseconds: 0),
        //hideKeyboard: true,

        textFieldConfiguration: TextFieldConfiguration(
          cursorColor: Dark,
          onChanged: (value) {
            // if (debounce?.isActive ?? false) debounce?.cancel();
            // debounce = Timer(Duration(milliseconds: 1000), () {
            //   if (value.isNotEmpty) {
            //   } else {
            //     setState(() {});
            //   }
            // });
          },
          textAlign: TextAlign.left,
          //controller: _addressController,
          //style: inputTextStyle(SizeConfig.inputFontSize),
          decoration: InputDecoration(
            focusedBorder: inputFocusedBorderStyle(),
            enabledBorder: inputBorderStyle(),
            hintStyle: placeholderStyle(SizeConfig.labelFontSize),
            contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
          ),
        ),
        suggestionsBoxDecoration: const SuggestionsBoxDecoration(
            elevation: 5, constraints: BoxConstraints(maxHeight: 250)),
        suggestionsCallback: (pattern) {
          return [];
        },
        itemBuilder: (context, suggestion) {
          // AutocompletePrediction data = {};

          return Text("");
        },
        onSuggestionSelected: (suggestion) async {
          //AutocompletePrediction data = {};
          final detailsByPlaceID = "";
          final details = jsonDecode(detailsByPlaceID.toString());
          final fullAddressDetails = details["result"]["formatted_address"];
          List detailsAddressComponent =
              details["result"]["address_components"];
          final townDetails = detailsAddressComponent
              .where((x) => x["types"].contains("postal_town"))
              .toList();
          final postalDetails = detailsAddressComponent
              .where((x) => x["types"].contains("postal_code"))
              .toList();
          // Map<String, String> params = {
          //   "postcode": postalDetails[0]["long_name"],
          //   "car_type": carType,
          //   "vehicle_preference": vehicle_preference,
          //   "type": "2",
          //   "course_id": ""
          // };
          // getDynamicRateApiCall(params).then((dynamicRateResponse) {
          //   if (dynamicRateResponse['success'] == true) {
          //     setState(() {
          //       if (dynamicRateResponse['data']['max_adi_rate'] is double ||
          //           dynamicRateResponse['data']['max_adi_rate'] is int)
          //         this.cost.text =
          //             (dynamicRateResponse['data']['max_adi_rate']).toString();
          //       else
          //         this.cost.text = dynamicRateResponse['data']['max_adi_rate'];
          //       displayCost = this.cost.text;
          //       closeLoader();
          //     });
          //   } else {
          //     closeLoader();
          //     setState(() {
          //       addressSuggestion = "";
          //       this.address_line_1.text = "";
          //       this.address_line_2.text = "";
          //       this.town.text = "";
          //       postcode = "";
          //       this.country.text = "";
          //     });
          //     alertToShowAdiNotFound(context);
          //   }
          // });
          print("Address: $fullAddressDetails");
          print("Address Components: ${detailsAddressComponent}");
          print("Town Details: ${townDetails[0]["long_name"]}");
          print("PostCode Details: ${postalDetails}");

          // setState(() {
          //   town.text = townDetails[0]["long_name"];
          //   postcode = postalDetails[0]["long_name"];
          //   _addressController.text = fullAddressDetails;
          // });

          //setFocus(context, focusNode: town);
        },
      ),
    );
  }
}

dynamic loading(
    {@required bool? value, String? title, bool closeOverlays = false}) {
  if (value!) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..lineWidth = 1.8
      ..backgroundColor = Colors.white
      ..displayDuration = Duration(seconds: 2)
      ..maskColor = Colors.grey.withOpacity(.2)

      /// custom style
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorColor = Colors.black
      ..textColor = Colors.black
      ..contentPadding = EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 15,
      )

      ///
      ..userInteractions = false
      ..animationStyle = EasyLoadingAnimationStyle.offset;
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      status: "Loading..",
      dismissOnTap: true,
    );
  } else {
    EasyLoading.dismiss();
  }
}
