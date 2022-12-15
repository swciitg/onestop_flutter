import 'package:cab_sharing/cab_sharing.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:provider/provider.dart';

class HomeLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  final String title;
  const HomeLinks({Key? key, required this.links, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    title,
                    style: MyFonts.w500.size(10).setColor(kWhite),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  links[0],
                  const SizedBox(
                    width: 5,
                  ),
                  links[1],
                  const SizedBox(
                    width: 5,
                  ),
                  links[2],
                  const SizedBox(
                    width: 5,
                  ),
                  links[3],
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}

class ServiceLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  const ServiceLinks({Key? key, required this.links}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 260,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: kHomeTile,
    //   ),
    //   child: Container(
    //     padding: const EdgeInsets.all(4),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         Expanded(
    //           child: FittedBox(
    //             fit: BoxFit.scaleDown,
    //             alignment: Alignment.centerLeft,
    //             child: Padding(
    //               padding: const EdgeInsets.all(5),
    //               child: Text(
    //                 'Services',
    //                 style: MyFonts.w500.size(10).setColor(kWhite),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child:
    //         ),
    //         const SizedBox(
    //           height: 5,
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Services',
              style: MyFonts.w500.size(20).setColor(kWhite),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  links[0],
                  const SizedBox(
                    width: 5,
                  ),
                  links[1],
                  const SizedBox(
                    width: 5,
                  ),
                  links[2],
                  const SizedBox(
                    width: 5,
                  ),
                  links[3],
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
      Expanded(
        child: FittedBox(
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context){
                  return CabSharingScreen(userData: {
                    'name': context.read<LoginStore>().userData["name"]!,
                    'email': context.read<LoginStore>().userData["email"]!,
                    'security-key': const String.fromEnvironment('SECURITY-KEY')
                  });
                })
              );
            },
            child: Container(
              //margin: EdgeInsets.all(4),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: lGrey),
              padding: const EdgeInsets.all(4.0),
              child: Column(
                // Replace with a Row for horizontal icon + text
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  const Expanded(
                    child: Icon(
                      Icons.directions_car_outlined,
                      size: 40,
                      color: lBlue,
                    ),
                  ),
                  Expanded(
                    child: Text('Cab Sharing',
                        style: MyFonts.w500.size(23).setColor(lBlue),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: FittedBox(
                    child: GestureDetector(
                      child: const SizedBox(
                        width: 150,
                        height: 150,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: FittedBox(
                    child: GestureDetector(
                      child: const SizedBox(
                        width: 150,
                        height: 150,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: FittedBox(
                    child: GestureDetector(
                      child: const SizedBox(
                        width: 150,
                        height: 150,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
