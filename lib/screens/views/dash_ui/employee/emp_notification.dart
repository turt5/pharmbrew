import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/_delete_notification.dart';
import '../../../../data/_update_notification_status.dart';
import '../../../../data/fetch_notification.dart';

class EmployeeNotifications extends StatefulWidget {
  const EmployeeNotifications({super.key});

  @override
  State<EmployeeNotifications> createState() => _EmployeeNotificationsState();
}

class _EmployeeNotificationsState extends State<EmployeeNotifications> {
  List<dynamic> notifications = [];
  // List<Map<String, dynamic>> employeeDatas = [];
  late String userId = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    initData();
    _fetchNotification();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => _fetchNotification());
  }

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('loggedInUserId');
    setState(() {
      userId = x ?? '';
    });
  }

  Future<void> _fetchNotification() async {
    final fetchedNotifications = await FetchNotification.fetch();


    print("Notifications: $fetchedNotifications");
    List<dynamic> notificationsLocal=[];


    for(var notification in fetchedNotifications){
      if(notification['receiver']=='employee' && notification['receiver_id']==userId ){
        notificationsLocal.add(notification);
      }
    }

    print("Notifications for liza: $notificationsLocal");

    setState(() {
      notifications = notificationsLocal;
    });
    // initEmpData();


    if(!isNotificationEmpty && notifications.isEmpty){
      setState(() {
        isNotificationEmpty=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return notifications.isNotEmpty ? Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 140,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        MouseRegion(
                          onEnter: (event) {
                            setState(() {
                              hoveredIndex = index;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              hoveredIndex = -1;
                            });
                          },
                          child: GestureDetector(
                            onTap: () async {
                              print('clicked: ${notifications[index]['notification_id']}');
                              await UpdateNotificationStatus.update(
                                  notifications[index]['notification_id']);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              color: notifications[index]['status']=='unread'?Colors.blue[200]:hoveredIndex==index? Colors.grey.shade300:Colors.white,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 60,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: AssetImage(
                                                'assets/images/admin.jpg'
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                notifications[index]['content'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: notifications[index]['status']=='unread'? FontWeight.bold:FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            child: Text(
                                              getTime(notifications[index]['created_at']),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: notifications[index]['status']=='unread'?Colors.black:Colors.grey,
                                                  fontWeight: notifications[index]['status']=='unread'? FontWeight.bold:FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),

                                      IconButton(onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: const Text('Delete Notification'),
                                                content: const Text('Are you sure you want to delete this notification?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await DeleteNotification.delete(notifications[index]['notification_id']);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Delete'))
                                                ],
                                              );
                                            });
                                      }, icon: const Icon(Icons.delete, color: Colors.red, size: 20,)),
                                      const SizedBox(width: 10),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    ) : isNotificationEmpty? Center(
      child: Text(
        'No notifications',
        style: const TextStyle(fontSize: 20),
      )
    ) : const Center(child: CircularProgressIndicator());
  }

  // String getEmployeeImage(String userId) {
  //   for (var employeeData in employeeDatas) {
  //     if (employeeData['userId'] == userId) {
  //       return "https://bcrypt.site/uploads/images/profile/picture/${employeeData['profile_pic']}";
  //     }
  //   }
  //   return '';
  // }
// 2024-04-15 10:07:35
  String getTime(String raw){
    var parts = raw.split(' ');
    String date = parts[0];
    String time = parts[1];

    DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    DateTime newTime = parsedTime.add(const Duration(hours: 6));
    String formattedTime = DateFormat('hh:mm a').format(newTime);

    return '$formattedTime, $date';
  }

  int hoveredIndex=-1;
  bool isNotificationEmpty = false;
}
