// import 'dart:async';
//
// class LocationService {
//   late UserLocation _currentLocation;
//   Location location = Location();
//
//   //PermissionStatus granted;
//   // StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();
//   //
//   // LocationService(){
//   //   location.requestPermission().then((granted) {
//   //     if(granted != null){
//   //       location.onLocationChanged.listen((locationData){
//   //         if(locationData != null){
//   //           _locationController.add(UserLocation(latitude: locationData.latitude,longitude: locationData.longitude));
//   //         }
//   //
//   //       });
//   //     }
//   //   });
//   // }
//
//   Future<UserLocation> getUserLocation() async {
//     try{
//       var userLocation = await location.getLocation();
//       //print(userLocation);
//       _currentLocation = UserLocation(latitude: userLocation.latitude.toString(), longitude: userLocation.longitude.toString());
//
//
//
//     }catch(e){
//       print('No location found!!');
//     }
//     return _currentLocation;
//   }
// }