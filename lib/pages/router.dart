import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/IPsettings.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';

class DropDown extends StatefulWidget {
  static String id = "/ip";
  @override
  DropDownWidget createState() => DropDownWidget();
}
bool fg=true;
class DropDownWidget extends State {
  TextEditingController roomController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  hostelDetails hostel=hostelDetails("nothing", "--", "--=-=-===","something") ;
  String dropdownValue="No Value";
  final _keyform= GlobalKey<FormState>();
  List <String> spinnerItems = [
    'No Value',
    'Barak',
    'Umiam',
    'Brahmaputra',
    'Manas',
    'Dihing',
    'Dibang',
    'Married Scholars',
    'Siang',
    'Dhansiri',
    'Subhansiri',
    'Kapili',
    'Kameng'
  ] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,displayIcon: false),
      body: SingleChildScrollView(
        child : Form(
          key: _keyform,
          child: Center(
            child :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style:const TextStyle(color: Colors.red, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (data) {
                      setState(() {
                        dropdownValue = data!;
                        hostel.hostelName=dropdownValue;
                      });
                    },

                    items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                Text('Selected Hostel = ' + dropdownValue,
                    style: const TextStyle
                      (fontSize: 22,
                        color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: TextFormField(
                    // Tell your textfield which controller it owns
                      validator: (value){
                        if(value==null || value.isEmpty){return "Remember your room number correctly";}
                        return null;
                      },
                      controller: roomController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (v){ roomController.text = v;hostel.roomNo=v;roomController.selection = TextSelection.fromPosition(TextPosition(offset: roomController.text.length));},
                      decoration: const InputDecoration(
                        labelText: 'Room No.',

                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:   TextFormField(
                      validator: (value){
                        if(value==null || value.isEmpty){return "remember your block number correctly";}
                        return null;
                      },
                      controller: blockController,
                      keyboardType: TextInputType.text,
                      onChanged: (v){ blockController.text = v;hostel.block=v;blockController.selection = TextSelection.fromPosition(TextPosition(offset: blockController.text.length));},
                      decoration: const InputDecoration(
                        labelText: 'Block No.',

                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      validator: (value){
                        if(value==null || value.isEmpty){return "remember your floor number correctly";}
                        return null;
                      },
                      controller: floorController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (v){ floorController.text = v;hostel.floor=v;floorController.selection = TextSelection.fromPosition(TextPosition(offset: floorController.text.length));},
                      decoration: const InputDecoration(
                        labelText: 'Floor No.',

                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(onPressed: (){
                    if (_keyform.currentState!.validate()){
                      fg=false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IpPage(),settings: RouteSettings(
                          arguments: hostel,
                        )),
                      );}}, child: const Text("Load Data"),color: Colors.blue[600],),
                )

              ]),
            ),
          ),
        ),),
    );
  }
}

