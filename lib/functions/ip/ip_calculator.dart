String calculatedetails(HostelDetails args, String initials) {
  String block = args.block;
  int W = -1, X = -1, Y = -1, Z = -1;

  switch (block) {
    case "b1":
      W = 0;
      break;
    case "b2":
      W = 1;
      break;
    case "b3":
      W = 2;
      break;
    case "b4":
      W = 3;
      break;
    case "c1":
      W = 4;
      break;
    default:
      W = (block.toLowerCase().codeUnitAt(0) - 97).toInt();
      break;
  }

  var selectedHostel = args.hostelName;
  X = int.parse(args.floor);
  Y = int.parse(args.roomNo);

  if (args.hostelName == "Brahmaputra") {
    if (W == 0 || W == 1) {
      Z = Y;
    } else {
      if (X == 0) {
        Z = Y - 134;
      } else if (X == 1) {
        Z = Y - 119;
      } else if (X == 2) {
        Z = Y - 133;
      } else {
        Z = Y - 131;
      }
    }
  } else {
    Y %= 100;
  }

  String ipAddress;
  if (selectedHostel == "Dhansiri" ||
      selectedHostel == "Lohit" ||
      selectedHostel == "Married Scholars" ||
      selectedHostel == "Dibang") {
    ipAddress = "Unavailable";
  } else if (selectedHostel == "Dihing" ||
      selectedHostel == "Kapili" ||
      selectedHostel == "Siang") {
    ipAddress = "$initials.$X.$Y";
  } else if (selectedHostel == "Brahmaputra") {
    if (W != 0) {
      ipAddress = "$initials.$W$X.$Z";
    } else {
      ipAddress = "$initials.$X.$Z";
    }
  } else {
    if (W != 0) {
      ipAddress = "$initials.$W$X.$Y";
    } else {
      ipAddress = "$initials.$X.$Y";
    }
  }

  return ipAddress;
}

class HostelDetails {
  late String hostelName;
  late String block;
  late String floor;
  late String roomNo;
  HostelDetails(this.hostelName, this.block, this.floor, this.roomNo);
}
