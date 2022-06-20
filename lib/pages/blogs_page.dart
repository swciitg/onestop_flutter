import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfeed/webfeed.dart';

class Blogs extends StatefulWidget {
  static String id = "/blogs";
  const Blogs({Key? key}) : super(key: key);

  @override
  _BlogState createState() => _BlogState();
}

class blogitem {
  late String title;
  late String pubdate;
  late String guid;

  blogitem({required this.title, required this.pubdate, required this.guid});
}

class MediumArticle {
  String title;
  String link;
  String datePublished;
  String image;
  String author;

  MediumArticle(
      {required this.title,
      required this.link,
      required this.datePublished,
      required this.image,
      required this.author});

  factory MediumArticle.fromJson(Map<String, dynamic> jsonData) {
    return MediumArticle(
        title: jsonData['title'],
        link: jsonData['link'],
        datePublished: jsonData['datePublished'],
        image: jsonData['image'],
        author: jsonData['author']);
  }

  static Map<String, dynamic> toMap(MediumArticle music) => {
        'title': music.title,
        'link': music.link,
        'datePublished': music.datePublished,
        'image': music.image,
        'author': music.author
      };

  static String encode(List<MediumArticle> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => MediumArticle.toMap(music))
            .toList(),
      );

  static List<MediumArticle> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<MediumArticle>((item) => MediumArticle.fromJson(item))
          .toList();
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
    } catch (e) {
      print(e);
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

            for (RssItem x in items!) {
              if (x.pubDate != null) {
                //print(x.content!.value);
                final text = x.content!.value;
                print(x.dc?.creator);
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
      child: ListShimmer(
        height: 170,
        count: 8,
      ),
    );
  }

  Widget _getHeading() {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
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
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext buildContext, int index) {
        String link;

        return InkWell(
          onTap: () {
            link = _mediumArticles[index].link;

            print(link);
            launchArticle(link.toString());
          },
          child: Card(
            color: Color(273141),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: _mediumArticles[index].image),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _mediumArticles[index].title,
                        style: TextStyle(
                            fontFamily: 'montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                      Text(
                          // _mediumArticles[index]
                          //     .title
                          //     .toString()
                          //     .split("|")[1]
                          //     .trim(),
                          _mediumArticles[index].author,
                          style: TextStyle(
                              fontFamily: 'montserrat',
                              color: Colors.white,
                              fontSize: 14))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_mediumArticles.length);
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
