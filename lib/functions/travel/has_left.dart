bool hasLeft(DateTime s) {
  DateTime x = DateTime.now();
  return x.isAfter(s.toLocal());
}

