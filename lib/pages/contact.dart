import 'package:flutter/material.dart';

import '../globals/my_colors.dart';
import '../globals/my_fonts.dart';

class ContactPage extends StatefulWidget {
  static String id = "/contact";
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          leading: Container(),
          leadingWidth: 0,
          title: Text(
              'Contacts',
              style: MyFonts.medium.size(20).setColor(kWhite)
          ),
          actions: [
            IconButton(
                onPressed: () {Navigator.of(context).pop();},
                icon: Icon(IconData(0xe16a, fontFamily: 'MaterialIcons')))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8,14,8,14),
              child: ContactSearchBar(),
            ),
            Row(
              children: [
                Expanded(
                  flex: 16,
                  child: Container(),
                ),
                Expanded(
                  flex: 106,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: lGrey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: kGrey8,),
                        Text('Emergency', style: MyFonts.medium.size(10).setColor(kWhite),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 106,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: lGrey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus, color: kGrey8,),
                        Text('Transport', style: MyFonts.medium.size(10).setColor(kWhite),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 106,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: lGrey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group, color: kGrey8,),
                        Text('Gymkhana', style: MyFonts.medium.size(10).setColor(kWhite),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: Container(),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3,8,3,8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('https://images.wallpapersden.com/image/wxl-loki-marvel-comics-show_78234.jpg'),
                        ),
                        title: Text('My Profile', style: MyFonts.bold.size(15).setColor(kWhite),),
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        )
    );
  }
}


class ContactSearchBar extends StatelessWidget {
  ContactSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (s) {
          /*context
              .read<RestaurantStore>()
              .setSearchHeader("Showing results for $s");
          context.read<RestaurantStore>().setSearchString(s);
          Navigator.pushNamed(context, SearchPage.id);*/
        },
        onChanged: (s) {
          /*context.read<RestaurantStore>().setSearchHeader("Showing results for $s");
          context.read<RestaurantStore>().setSearchString(s);*/
        },
        style: MyFonts.medium.setColor(kWhite),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(color: kBlueGrey, width: 1),
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              color: kWhite,
            ),
            hintStyle: MyFonts.medium.size(13).setColor(kGrey2),
            hintText: "Search keyword (name, position etc)",
            contentPadding: EdgeInsets.zero,
            fillColor: kBlueGrey),
      ),
    );
  }
}
