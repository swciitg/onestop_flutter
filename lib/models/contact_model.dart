class ContactModel {

  //Values of contact model
  late String name;
  late List<ContactDetailsModel> contacts;
  late String parent;

  //Constructor
  ContactModel({required this.name});

  //This constructor also does the work of initialising the variables
  ContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    parent = 'Campus';
    contacts = [];
    List<dynamic>.from(json['contacts']).forEach((element) {
      contacts.add(ContactDetailsModel.fromJson(element));
    });
  }
}

class ContactDetailsModel {
  //Values of contact model
  late String name;
  late String email;
  late int contact;

  //Constructor
  ContactDetailsModel({required this.name, required this.email, required this.contact});

  //This constructor also does the work of initialising the variables
  ContactDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contact = json['contact'];
    email = json['email'];
  }
}
