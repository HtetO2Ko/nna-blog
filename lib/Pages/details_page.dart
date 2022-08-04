import 'package:blog/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List itemsList = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;
    itemsList = args.lis;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: itemsList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    width: 900,
                    margin: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemsList[index]["title"],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: ubuntuFont,
                                fontSize: 35,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 15,
                                    color: textColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(
                                        DateTime.parse(
                                            itemsList[index]["date"])),
                                    style: TextStyle(
                                      color: textColor,
                                      fontFamily: ubuntuFont,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              itemCount: itemsList[index]["blogList"].length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, i) {
                                var lis = itemsList[index]["blogList"];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    lis[i]["type"] == "Image"
                                        ? Center(
                                            child: Image.network(
                                              lis[i]["value"],
                                              height: 450,
                                              width: 450,
                                            ),
                                          )
                                        : Container(),
                                    lis[i]["type"] == "Text"
                                        ? Text(
                                            lis[i]["value"],
                                            style: TextStyle(
                                              color: textColor,
                                              fontFamily: ubuntuFont,
                                              fontSize: 20,
                                              height: 1.8,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1000,
                                          )
                                        : Container(),
                                    lis[i]["type"] == "Code"
                                        ? Text(
                                            lis[i]["value"],
                                            style: TextStyle(
                                              color: textColor,
                                              fontFamily: ubuntuFont,
                                              fontSize: 20,
                                              height: 1.8,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1000,
                                          )
                                        : Container(),
                                    lis[i]["type"] == "Video"
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 20),
                                            child: Center(
                                              child: Container(
                                                width: 600,
                                                height: 400,
                                                child: YoutubePlayerIFrame(
                                                  controller:
                                                      YoutubePlayerController(
                                                    initialVideoId: lis[i]
                                                        ["value"],
                                                    params:
                                                        const YoutubePlayerParams(
                                                      startAt: Duration(
                                                        minutes: 0,
                                                        seconds: 0,
                                                      ),
                                                      showControls: true,
                                                      showFullscreenButton:
                                                          true,
                                                      desktopMode: false,
                                                      privacyEnhanced: true,
                                                      useHybridComposition:
                                                          true,
                                                      color: "red",
                                                      autoPlay: false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Chip(
                                  labelPadding: const EdgeInsets.all(2.0),
                                  label: Text(
                                    itemsList[index]["category"],
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: ubuntuFont,
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                  backgroundColor: Colors.white,
                                  elevation: 2.0,
                                  shadowColor: Colors.grey[60],
                                  padding: const EdgeInsets.all(8.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
