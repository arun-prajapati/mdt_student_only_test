import 'package:Smart_Theory_Test/datamodels/user_location.dart';
import 'package:url_launcher/url_launcher.dart';

const int delay = 15;
const String kGoogleApiKey = "AIzaSyBa4FdOlhksMcExaWa-z_EHeNppLz6c2ug";
// const String api = 'https://mdt.developersforflutter.com';
const String api = 'https://mockdrivingtest.com';
// const String api = 'https://mockdvsatest.co.uk';
// const String api = 'http://192.168.1.37';
const String imageBaseUrl = 'https://mockdrivingtest.com';
const String stripePublic = "pk_live_uvawPT4fmctau9Zh6fyHH3Rd00kcvCqEv9";

///tesing url
// const String api = 'https://mockdvsatest.co.uk';
// const String stripePublic = "pk_test_1Z6fcQ67ZMbJB35tlLE6VqtH00kqRc5995";
Future<void> launchSocialURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    // showToast("URL not found");
    throw Exception('Could not launch $url');
  }
}

class AppConstant {
  static String highwayCodeLink =
      "https://www.gov.uk/guidance/the-highway-code";
  static String theoryTestGuidance =
      "https://mockdrivingtest.com/static/theory-test-guidance";
  static String bookTheoryTest = "https://www.gov.uk/book-theory-test";

  static String trafficSigns = "https://assets.publishing.service.gov.uk/media/656ef4271104cf0013fa74ef/know-your-traffic-signs-dft.pdf";
  static UserModel? userModel;
}
