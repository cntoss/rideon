import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/notification/notification.dart';
import 'package:rideon/services/firebase/notification_service.dart';
import 'package:rideon/widgets/customCard.dart';
import 'package:rideon/widgets/error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NotificationScreen());
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<OfflineNotification> originalNotification = <OfflineNotification>[];
  @override
  void initState() {
    super.initState();
    originalNotification = NotificationService().getSavedNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body:  originalNotification == null
            ? ErrorEmptyWidget(message: "Failed to Fetch Notification")
            :  originalNotification.isEmpty
                ? ErrorEmptyWidget(message: "No Notification")
                : Container(child: _listView(originalNotification)

          /*  child: originalNotification.length > 0
              ? _listView(originalNotification)
              : _listView(notifications) */
          ),
    );
  }

  ListView _listView(var notifications) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return CustomCard(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.notifications_active,
                      size: 14,
                    ),
                  ),
                  shape: CircleBorder(),
                  color: Colors.tealAccent,
                  elevation: 1,
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    if (notifications[index].link != null) {
                      if (await canLaunch(notifications[index].link)) {
                        launch(notifications[index].link);
                      }
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications[index].title,
                        style: subTitle,
                      ),
                      Text(notifications[index].description),
                      Align(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: index,
                          child: OptimizedCacheImage(
                            imageUrl: notifications[index].image ?? ' ',
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60.0,
                              height: 60.0,
                              color: Colors.grey.shade400,
                              child: Center(
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.5),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                                /*  width: 60.0,
                                height: 60.0,
                                color: Colors.grey.shade400,
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ), */
                                ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(AppConfig().dateWithoutTime.format(
                              notifications[index].date ??
                                  DateTime.now().add(Duration(hours: index)))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(AppConfig().dateOnlyTime.format(
                              notifications[index].date ??
                                  DateTime.now().add(Duration(hours: index))))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ));
        });
  }
}
