import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfeed/webfeed.dart';
import 'package:onestop_dev/models/blogs/mediumArticle_model.dart';
import 'package:html/parser.dart';

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final elements = document.getElementsByTagName('p');
  String parsedString = "";
  for (var element in elements) {
    if (parsedString != "") {
      parsedString = parsedString + " " + element.text;
    } else {
      parsedString = element.text;
    }
  }

  // final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

class Blogs extends StatefulWidget {
  static String id = "/blogs";
  const Blogs({Key? key}) : super(key: key);

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blogs> {
  late RssFeed _rssFeed; // RSS Feed Object
  List<String> mediumLists = [
    'https://medium.com/feed/@cepstrumeeeiitg',
    'https://medium.com/feed/@csea.iitg'
  ];
  static String MEDIUM_PROFILE_RSS_FEED_URL =
      'https://medium.com/feed/@csea.iitg';
  List<MediumArticle> _mediumArticles = [];
  String title = "notnull";
  String image =
      "https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.cyberark.com%2Fwp-content%2Fuploads%2F2019%2F11%2FDeveloper.jpg&imgrefurl=https%3A%2F%2Fwww.cyberark.com%2Fresources%2Fblog%2Fsecure-developer-workstations-without-slowing-them-down&tbnid=fJMc6OspVdPfgM&vet=12ahUKEwivmoytyOb1AhXlZWwGHZAPBZkQMygAegUIARDTAQ..i&docid=X2dX4HlN_niOsM&w=943&h=536&q=developer&ved=2ahUKEwivmoytyOb1AhXlZWwGHZAPBZkQMygAegUIARDTAQ";

  // Get the Medium RSSFeed data
  Future<RssFeed?> getMediumRSSFeedData(MEDIUM_PROFILE_RSS_FEED_URL) async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(MEDIUM_PROFILE_RSS_FEED_URL));
      return RssFeed.parse(response.body);
    } catch (error) {
      print(error);
    }
    return null;
  }

  updateFeed(feed) {
    setState(() {
      _rssFeed = feed;
    });
  }

  Future<void> launchArticle(String url) async {
    await launchUrlString(url);
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _mediumArticles.clear();

        //  print(mediumLists[i]);
        for (int i = 0; i < mediumLists.length; i++) {
          getMediumRSSFeedData(mediumLists[i]).then((feed) {
            updateFeed(feed);

            title = _rssFeed.title!;
            image = _rssFeed.image!.url!;
            var items = feed!.items;

            // print(items![5]);
            for (RssItem x in items!) {
              if (x.pubDate != null) {
                final text = x.content!.value;
                final content = parseHtmlString(text);
                // print(x.dc?.creator);
                String imagelink =
                    text.split("<img")[1].split("/>")[0].split(" src=")[1];
                int p = imagelink.length;
                String imagelink2 = imagelink.substring(1, p - 2);

                // print(imagelink2);
                String pdate = x.pubDate.toString();
                MediumArticle res = MediumArticle(
                    title: x.title!,
                    link: x.guid!,
                    datePublished: pdate,
                    image: imagelink2,
                    content: content,
                    author: x.dc!.creator!);
                _mediumArticles.add(res);
              }
            }
          });

          // Encode and store data in SharedPreferences
          final String encodedData = MediumArticle.encode(_mediumArticles);

          prefs.setString('medium_data', encodedData);
        }
      }
    } on SocketException catch (_) {
      final String? musicsString = prefs.getString('medium_data');

      _mediumArticles = MediumArticle.decode(musicsString!);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDetails();

    // Fetch and decode data
  }

  Widget _getLoadingIndicator() {
    return Expanded(
      child: Shimmer.fromColors(
          child: Container(
            height: 400,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    // Divider(
                    //   thickness: 1.5,
                    //   color: kTabBar,
                    // ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          period: Duration(seconds: 1),
          baseColor: kHomeTile,
          highlightColor: lGrey),
    );
  }

  Widget _PageState(String title) {
    while (title == "notnull") {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 16),
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getLoadingIndicator(),
            // _getHeading(),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _mediumArticles.length,
      padding: const EdgeInsets.symmetric(
        vertical: 28.0,
        horizontal: 16.0,
      ),
      itemBuilder: (BuildContext buildContext, int index) {
        String link;

        return InkWell(
          onTap: () {
            link = _mediumArticles[index].link;

            // print(link);
            launchArticle(link.toString());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CachedNetworkImage(imageUrl: _mediumArticles[index].image),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mediumArticles[index]
                          .title
                          .toString()
                          .split("|")[0]
                          .trim(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kWhite,
                        letterSpacing: 0.1,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      _mediumArticles[index].content,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: kFontGrey,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ), // MyFonts.w500.size(11).setColor(kFontGrey)
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: FittedBox(
                                child:
                                    Image.network(_mediumArticles[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              _mediumArticles[index].author,
                              style: MyFonts.w700.size(11).setColor(lBlue4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1.5,
                color: kTabBar,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(_mediumArticles.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        leading: Container(),
        leadingWidth: 10,
        title: Text(
          'Blogs',
          style: MyFonts.w500,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)),
        ],
      ),
      body: _PageState(title),
    );
  }
}


// color: kBackground, // Color(273141),
//             // elevation: 5,
//             // shape: RoundedRectangleBorder(
//             // borderRadius: BorderRadius.all(Radius.circular(20))),
//             clipBehavior: Clip.antiAlias,