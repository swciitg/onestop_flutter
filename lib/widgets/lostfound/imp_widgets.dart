import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
class ProgressBar extends StatelessWidget {
  final int blue;
  final int grey;
  const ProgressBar({Key? key,required this.blue,required this.grey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bars = [];
    if(blue!=0){
      bars.add(Expanded(
          child: Container(
            height: 4,
            color: lBlue2,
            margin: EdgeInsets.only(right: 2),
          )),);
    }
    for(int i=1;i<blue;i++){
      bars.add(Expanded(
          child: Container(
            height: 4,
            color: lBlue2,
            margin: EdgeInsets.symmetric(horizontal: 2),
          )),);
    }
    for(int i=0;i<grey-1;i++){
      bars.add(Expanded(
          child: Container(
            height: 4,
            color: kGrey,
            margin: EdgeInsets.symmetric(horizontal: 2),
          )),);
    }
    if(grey!=0){
      bars.add(Expanded(
          child: Container(
            height: 4,
            color: kGrey,
            margin: EdgeInsets.only(left: 2),
          )),);
    }
    return Row(
      children: bars,
    );
  }
}

class NewPageButton extends StatelessWidget {
  final String title;
  const NewPageButton({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 12,right: 12,bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: lBlue2,
          borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: MyFonts.w500.size(14),
          ),
        ],
      ),
    );
  }
}
class LostItemTile extends StatelessWidget {
  final currentLostModel;
  const LostItemTile({Key? key,required this.currentLostModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Duration passedDuration = DateTime.now().difference(currentLostModel.date);
    String timeagoString = timeago.format(DateTime.now().subtract(passedDuration));

    void detailsDialogBox(String imageURL, String description, String location, String contactnumber,DateTime date) {
      showDialog(context: context, builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21),),
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: kBlueGrey,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight*0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: kBlueGrey,
                  borderRadius: BorderRadius.circular(21)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: screenWidth-30,
                  // ), // to match listtile width
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(21),topRight: Radius.circular(21)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: screenHeight*0.3,maxWidth: screenWidth-30),
                      child: SingleChildScrollView(
                        child: FadeInImage(width: screenWidth-30,placeholder: AssetImage("assets/images/loading.gif"), image: NetworkImage(imageURL),fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12,right: 8,top: 10,bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            currentLostModel.title,
                            style: MyFonts.w600.size(16).setColor(kWhite),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await launch("tel:+91$contactnumber");
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: kGrey9,
                                  borderRadius: BorderRadius.circular(24)
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Icon(Icons.phone,size: 11,color: lBlue2,),
                                  Text(
                                    " Call",
                                    style: MyFonts.w500.size(11).setColor(lBlue2),
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Visibility(
                  //     visible: submitgory=="Found" ? true : false,
                  //     child: Text(
                  //       "Submitted at: " + submitted,
                  //       style: MyFonts.medium.size(14).setColor(kGrey6),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,bottom: 8),
                    child: Text(
                      "Lost at: " + location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyFonts.w500.size(14).setColor(kGrey6),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight*0.2,maxWidth: screenWidth-40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 13),
                        child: Text(
                          "Description: " + description,
                          style: MyFonts.w300.size(14).setColor(kGrey10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16,bottom: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      date.day.toString() + "-" + date.month.toString() + "-" + date.year.toString() + " | " + DateFormat.jm().format(date.toLocal()).toString(),
                      style: MyFonts.w300.size(13).setColor(kGrey7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    return GestureDetector(
      onTap: (){
        detailsDialogBox(currentLostModel.imageURL, currentLostModel.description, currentLostModel.location, currentLostModel.phonenumber,currentLostModel.date);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        decoration: BoxDecoration(
            color: kBlueGrey,
            borderRadius: BorderRadius.circular(21)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 194),
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16,bottom: 5),
                      child: Text(
                        currentLostModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w500.size(16).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Lost at: " + currentLostModel.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w300.size(14).setColor(kWhite),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13,vertical: 2.5),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: kGrey9,
                          borderRadius: BorderRadius.circular(41)
                      ),
                      child: Text(
                        timeagoString,
                        style: MyFonts.w500.size(12).setColor(lBlue2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 105,maxWidth: 135),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(21),bottomRight: Radius.circular(21)),
                child: CachedNetworkImage(
                  imageUrl: currentLostModel.compressedImageURL,
                  imageBuilder: (context, imageProvider) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    child: Text("Loading...",style: MyFonts.w500.size(14).setColor(kGrey9)),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class FoundItemTile extends StatelessWidget {
  final currentFoundModel;
  const FoundItemTile({Key? key,required this.currentFoundModel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Duration passedDuration = DateTime.now().difference(currentFoundModel.date);
    String timeagoString = timeago.format(DateTime.now().subtract(passedDuration));

    void detailsDialogBox(String imageURL, String description, String location,String submitted, DateTime date) {
      showDialog(context: context, builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21),),
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: kBlueGrey,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight*0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: kBlueGrey,
                  borderRadius: BorderRadius.circular(21)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: screenWidth-30,
                  // ), // to match listtile width
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(21),topRight: Radius.circular(21)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: screenHeight*0.3,maxWidth: screenWidth-30),
                      child: SingleChildScrollView(
                        child: FadeInImage(width: screenWidth-30,placeholder: AssetImage("assets/images/loading.gif"), image: NetworkImage(imageURL),fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12,right: 8,top: 10,bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            currentFoundModel.title,
                            style: MyFonts.w600.size(16).setColor(kWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Submitted at: " + submitted,
                      style: MyFonts.w500.size(14).setColor(kGrey6),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,bottom: 8),
                    child: Text(
                      "Found at: " + location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyFonts.w500.size(14).setColor(kGrey6),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight*0.2,maxWidth: screenWidth-40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 13),
                        child: Text(
                          "Description: " + description,
                          style: MyFonts.w300.size(14).setColor(kGrey10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16,bottom: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      date.day.toString() + "-" + date.month.toString() + "-" + date.year.toString() + " | " + DateFormat.jm().format(date.toLocal()).toString(),
                      style: MyFonts.w300.size(13).setColor(kGrey7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    return GestureDetector(
      onTap: (){
        detailsDialogBox(currentFoundModel.imageURL, currentFoundModel.description, currentFoundModel.location,currentFoundModel.submittedat,currentFoundModel.date);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        decoration: BoxDecoration(
            color: kBlueGrey,
            borderRadius: BorderRadius.circular(21)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 194),
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16,bottom: 5),
                      child: Text(
                        currentFoundModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w500.size(16).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Found at: " + currentFoundModel.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w300.size(14).setColor(kWhite),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13,vertical: 2.5),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: kGrey9,
                          borderRadius: BorderRadius.circular(41)
                      ),
                      child: Text(
                        timeagoString,
                        style: MyFonts.w500.size(12).setColor(lBlue2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 105,maxWidth: 135),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(21),bottomRight: Radius.circular(21)),
                child: CachedNetworkImage(
                  imageUrl: currentFoundModel.compressedImageURL,
                  imageBuilder: (context, imageProvider) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    child: Text("Loading...",style: MyFonts.w500.size(14).setColor(kGrey9)),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


