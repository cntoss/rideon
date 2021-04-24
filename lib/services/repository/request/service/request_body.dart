import 'package:rideon/models/googleModel/GeocodingModel.dart';

class RequestBody {
  var clientId =
      "eFveZhA1QyuVvpahxdYA2A:APA91bES6cL80hXS8lc1ZvGRVQOrNax2suAXLrPkHC5NYnZ7WUMHzvz-Wtg63emRiUT4M1IgeJmmMclT-CDoMVS4UBMAERkNr7vSAtXBBa6T8bB8SBjUjnVZl9Clca4LtoKVwvSkt0EW";

  firebaseBody() {
    return {
      "to": clientId,
      "notification": {
        "title": "Notification 2",
        "body": "This is body rideon ",
        "sound": "default"
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "message": "Our Data Message",
        "type": "news",
        "title": "Test Notification 2",
        "image":
            "https://i.pinimg.com/564x/29/c6/23/29c6231d5ad52439f171596b446fd0bf.jpg",
        "link": "http://www.hashtechnologies.net/",
        "id": "139"
      }
    };
  }

  driveRequestBody(
      {LocationDetail fromLocation,
      LocationDetail toLocation,
      String distance,
      String time}) {
    return {
      "to": clientId,
      "notification": {
        "title": "Ride Request",
        "body": "You got ride request from ${fromLocation.formattedAddress}",
        "sound": "default"
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "message": "Our Data Message",
        "type": "ride_request",
        "title": "Ride Request",
        "from_location": fromLocation.toJson(),
        "to_location": toLocation.toJson(),
        "time": "200",
        "distance": "5.4",
        "id": "139"
      }
    };
  }
}
