import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/news/news_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

class Blogs extends StatefulWidget {
  static String id = "/blogs";
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogState();
}

class _BlogState extends State<Blogs> {
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
          future: APIService.getNewsData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListShimmer(
                height: 200,
                count: 5,
              );
            }
            if (snapshot.data == null) {
              return Container();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => NewsTile(
                    title: snapshot.data![index]['title'],
                    body: snapshot.data![index]['body'],
                    author: snapshot.data![index]['userId'].toString()));
          },
        ));
  }
}
