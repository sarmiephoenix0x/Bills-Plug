import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> with TickerProviderStateMixin {
  String? profileImg;


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 70),
              decoration: const BoxDecoration(
                color: Color(0xFF02AA03),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (profileImg == null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(55),
                          child: Container(
                            width:
                            (60 / MediaQuery
                                .of(context)
                                .size
                                .width) *
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                            height:
                            (60 / MediaQuery
                                .of(context)
                                .size
                                .height) *
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                            color: Colors.grey,
                            child: Image.asset(
                              'images/ProfilePic.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        if (profileImg != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Container(
                              width:
                              (60 / MediaQuery
                                  .of(context)
                                  .size
                                  .width) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                              height:
                              (60 / MediaQuery
                                  .of(context)
                                  .size
                                  .height) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                              color: Colors.grey,
                              child: Image.network(
                                profileImg!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "William John",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'images/Notification.png',
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02),

                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}