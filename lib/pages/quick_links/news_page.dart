import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/news/news_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/news/news_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

class NewsPage extends StatefulWidget {
  static String id = "/blogs";
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _BlogState();
}

class _BlogState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarGrey,
          leading: Container(),
          leadingWidth: 10,
          title: Text(
            'News and Updates',
            style: MyFonts.w500,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
          ],
        ),
        body: FutureBuilder(
          future: DataProvider.getNews(),
          builder:
              (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListShimmer(
                height: 100,
                count: 10,
              );
            }
            if (snapshot.data == null) {
              return Center(
                child: Text('No data found',
                    style: MyFonts.w500.setColor(kWhite).size(14)),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => NewsTile(
                      news: snapshot.data![index],
                    ));
          },
        ));
  }
}
