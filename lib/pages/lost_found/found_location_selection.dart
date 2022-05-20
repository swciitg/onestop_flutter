import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/lost_found/imp_widgets.dart';
import 'package:onestop_dev/pages/lost_found/lnf_form.dart';
class LostFoundLocationForm extends StatefulWidget {
  final String imageString;
  LostFoundLocationForm({Key? key,required this.imageString}) : super(key: key);

  @override
  State<LostFoundLocationForm> createState() => _LostFoundLocationFormState();
}

class _LostFoundLocationFormState extends State<LostFoundLocationForm> {
  String? selectedLocation;
  bool checkBox=false;

  List<String> hostels = ["Brahmaputra","Dihing","Manas","Lohit","Dhansiri","Subansiri","Disang","Kameng","Umiam","Barak"];
  List<String> sac = ["Old SAC","New SAC"];
  List<String> cores = ["Core 1","Core 2","Core 3","Core 4"];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
          "2. Submit at desk",
          style: MyFonts.medium.size(20).setColor(kWhite),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(blue: 2, grey: 1),
          Container(
            margin: EdgeInsets.only(top: 40,left: 5,right: 5,bottom: 15),
            child: Text(
                "Please submit the found item at your nearest security desk.",
              style: MyFonts.medium.size(16).setColor(kWhite),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 50),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: kGrey2,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "I have submitted it",
                        style: MyFonts.medium.size(17).setColor(kWhite),
                      ),
                      Checkbox(
                        checkColor: kBlack,
                        activeColor: kWhite,
                        value: checkBox,
                        onChanged: (value){
                          setState(() {
                            checkBox=value!;
                          });
                        },
                      )
                    ],
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 15,bottom: 10),
            child: Text(
                "Where did you submit it at?",
              style: MyFonts.medium.size(19).setColor(kWhite),
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context){
              return [PopupMenuItem(value: "Central Library",child: Text("Central Library"))];
            },
            onSelected: (value){
              selectedLocation=value;
            },
            child:  PopupButtonTile(title: "Library"),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context){
              return hostels.map((value) => PopupMenuItem(
                value: value,
                  child: Text(value),
              )).toList();
            },
            onSelected: (value){
              selectedLocation=value;
            },
            child:  PopupButtonTile(title: "Hostel"),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context){
              return sac.map((value) => PopupMenuItem(
                value: value,
                child: Text(value),
              )).toList();
            },
            onSelected: (value){
              selectedLocation=value;
            },
            child:  PopupButtonTile(title: "SAC"),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context){
              return cores.map((value) => PopupMenuItem(
                value: value,
                child: Text(value),
              )).toList();
            },
            onSelected: (value){
              selectedLocation=value;
            },
            child:  PopupButtonTile(title: "Core"),
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: (){
          if(checkBox==false){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mark the checkbox if you have submitted the item")));
            return;
          }
          if(selectedLocation==null){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a location")));
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LostFoundForm(category: "Found",imageString: widget.imageString, submittedat: selectedLocation,)));
        },
        child: NewPageButton(title: "Next",),
      ),
    );
  }
}

class PopupButtonTile extends StatelessWidget {
  final String title;
  PopupButtonTile({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 80),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kWhite)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    title,
                  style: MyFonts.medium.size(17).setColor(kWhite),
                ),
                Icon(
                    Icons.keyboard_arrow_down,
                  color: kWhite,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
