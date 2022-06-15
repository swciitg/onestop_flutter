import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:onestop_dev/pages/lost_found/lnf_form.dart';
class LostFoundLocationForm extends StatefulWidget {
  final String imageString;
  LostFoundLocationForm({Key? key,required this.imageString}) : super(key: key);

  @override
  State<LostFoundLocationForm> createState() => _LostFoundLocationFormState();
}

class _LostFoundLocationFormState extends State<LostFoundLocationForm> {
  String? selectedLocation=null;
  bool checkBox=false;
  String? selectedDropdown;
  List<String> libraries = ["Library","Central library"];
  List<String> hostels = ["Hostel","Brahmaputra","Dihing","Manas","Lohit","Dhansiri","Subansiri","Disang","Kameng","Umiam","Barak"];
  List<String> sacs = ["SAC","Old SAC","New SAC"];
  List<String> cores = ["Core","Core 1","Core 2","Core 3","Core 4"];

  @override
  Widget build(BuildContext context) {
    double HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
          "2. Submit at desk",
          style: MyFonts.w600.size(16).setColor(kWhite),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(blue: 2, grey: 1),
          Container(
              margin: const EdgeInsets.only(top: 40,left: 16,right: 16,bottom: 15),
              child: Text(
                  "Please submit the found item at your nearest security desk.",
                style: MyFonts.w400.size(14).setColor(kWhite),
              ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 50),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: kBlueGrey,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "I have submitted it",
                        style: MyFonts.w400.size(16).setColor(kWhite),
                      ),
                      Theme(
                          data: ThemeData(unselectedWidgetColor: lBlue3),
                          child: Checkbox(
                            checkColor: kBlack,
                            activeColor: lBlue3,
                            overlayColor: MaterialStateProperty.all(lBlue3),
                            value: checkBox,
                            onChanged: (value){
                              setState(() {
                                checkBox=value!;
                              });
                            },
                          )
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
              style: MyFonts.w500.size(16).setColor(kWhite),
            ),
          ),

          ListView(
            shrinkWrap: true,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: kBlueGrey),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  child: DropdownButtonFormField<
                      String>(

                    value: selectedDropdown=="Library" ? selectedLocation : "Library",
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: kWhite,
                    ),
                    style: MyFonts.w500.size(16).setColor(kWhite),
                    onChanged: (data) {
                      setState(() {
                        selectedLocation = data!;
                        selectedDropdown="Library";
                      });
                    },
                    decoration: decfunction(''),
                    items: libraries.map<
                        DropdownMenuItem<
                            String>>(
                            (String value) {
                          return DropdownMenuItem<
                              String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(value,
                                style: MyFonts.w500.size(18).setColor(kWhite),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),



              Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: kBlueGrey),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  child: DropdownButtonFormField<
                      String>(
                    value: selectedDropdown=="Hostel" ? selectedLocation : "Hostel",
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: kWhite,
                    ),
                    style: MyFonts.w500.size(16).setColor(kWhite),
                    onChanged: (data) {
                      setState(() {
                        selectedLocation = data!;
                        selectedDropdown="Hostel";
                      });
                    },
                    decoration: decfunction(''),
                    items: hostels.map<
                        DropdownMenuItem<
                            String>>(
                            (String value) {
                          return DropdownMenuItem<
                              String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(value,
                                style: MyFonts.w500.size(18).setColor(kWhite),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: kBlueGrey),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  child: DropdownButtonFormField<
                      String>(
                    value: selectedDropdown=="SAC" ? selectedLocation : "SAC",
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: kWhite,
                    ),
                    style: MyFonts.w500.size(16).setColor(kWhite),
                    onChanged: (data) {
                      setState(() {
                        selectedLocation = data!;
                        selectedDropdown="SAC";
                      });
                    },
                    decoration: decfunction(''),
                    items: sacs.map<
                        DropdownMenuItem<
                            String>>(
                            (String value) {
                          return DropdownMenuItem<
                              String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(value,
                                style: MyFonts.w500.size(18).setColor(kWhite),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: kBlueGrey),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  child: DropdownButtonFormField<
                      String>(
                    value: selectedDropdown=="Core" ? selectedLocation : "Core",
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: kWhite,
                    ),
                    style: MyFonts.w500.size(16).setColor(kWhite),
                    onChanged: (data) {
                      setState(() {
                        selectedLocation = data!;
                        selectedDropdown="Core";
                      });
                    },
                    decoration: decfunction(''),
                    items: cores.map<
                        DropdownMenuItem<
                            String>>(
                            (String value) {
                          return DropdownMenuItem<
                              String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(value,
                                style: MyFonts.w500.size(18).setColor(kWhite),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: (){
          if(checkBox==false){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mark the checkbox if you have submitted the item")));
            return;
          }
          if(selectedLocation==null || ["Library","Hostel","Core","SAC"].contains(selectedLocation)){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select location of item submission")));
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LostFoundForm(category: "Found",imageString: widget.imageString, submittedat: selectedLocation,)));
        },
        child: NewPageButton(title: "Next",),
      ),
    );
  }
}

decfunction(String x) {
  return InputDecoration(
    labelText: x,
    labelStyle: MyFonts.w500.setColor(kGrey7),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: kGrey2, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: kGrey2,
        width: 1,
      ),
    ),
  );
}