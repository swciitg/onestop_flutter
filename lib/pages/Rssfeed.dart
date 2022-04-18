// ignore_for_file: file_names, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  MediumArticle(
      {required this.title,
      required this.link,
      required this.datePublished,
      required this.image});

  factory MediumArticle.fromJson(Map<String, dynamic> jsonData) {
    return MediumArticle(
      title: jsonData['title'],
      link: jsonData['link'],
      datePublished: jsonData['datePublished'],
      image: jsonData['image'],
    );
  }

  static Map<String, dynamic> toMap(MediumArticle music) => {
        'title': music.title,
        'link': music.link,
        'datePublished': music.datePublished,
        'image': music.image,
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

  static const String MEDIUM_PROFILE_RSS_FEED_URL =
      'https://medium.com/feed/@cepstrumeeeiitg';

  List<MediumArticle> _mediumArticles = [];
  String title = "Wait until data is loading";
  String image =
      "https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.cyberark.com%2Fwp-content%2Fuploads%2F2019%2F11%2FDeveloper.jpg&imgrefurl=https%3A%2F%2Fwww.cyberark.com%2Fresources%2Fblog%2Fsecure-developer-workstations-without-slowing-them-down&tbnid=fJMc6OspVdPfgM&vet=12ahUKEwivmoytyOb1AhXlZWwGHZAPBZkQMygAegUIARDTAQ..i&docid=X2dX4HlN_niOsM&w=943&h=536&q=developer&ved=2ahUKEwivmoytyOb1AhXlZWwGHZAPBZkQMygAegUIARDTAQ";

  // Get the Medium RSSFeed data
  Future<RssFeed?> getMediumRSSFeedData() async {
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
    await launch(url);
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _mediumArticles.clear();
        getMediumRSSFeedData().then((feed) {
          updateFeed(feed);

          title = _rssFeed.title!;
          image = _rssFeed.image!.url!;
          var items = feed!.items;

          for (RssItem x in items!) {
            if (x.pubDate != null) {
              print(x.content!.value);
              final text = x.content!.value;
              String imagelink =
                  text.split("<img")[1].split("/>")[0].split(" src=")[1];
              RegExp regExp = new RegExp(
                r"(<p><em>)(.*)(</em></p>)",
              );
              //print(text.toString());
              var val = regExp.firstMatch(text)?.group(2).toString();
              // val = val?.replaceAll(RegExp(r'[(<p>)(<em>)(/)]'), '');
              //   print(val);
              //  print(image);
              int p = imagelink.length;
              String imagelink2 = imagelink.substring(1, p - 2);

              print(imagelink2);
              String pdate = x.pubDate.toString();
              MediumArticle res = MediumArticle(
                  title: x.title!,
                  link: x.guid!,
                  datePublished: pdate,
                  image: imagelink2);
              _mediumArticles.add(res);
            }
          }
        });

        // Encode and store data in SharedPreferences
        final String encodedData = MediumArticle.encode(_mediumArticles);

        prefs.setString('medium_data', encodedData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _mediumArticles.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext buildContext, int index) {
          String link;

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Container(
                  child: GestureDetector(
                    onTap: () {
                      link = _mediumArticles[index].link;

                      print(link);
                      launchArticle(link.toString());
                    },
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(_mediumArticles[index].image),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.5,
                  child: Container(
                    height: 50,
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text(
                      _mediumArticles[index].title.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
