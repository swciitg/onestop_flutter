class RestaurantModel{
  String? name;
  String? caption;
  String? closing_time;
  String? waiting_time;
  String? phone_number;
  


  RestaurantModel(
      {
        this.name,
        this.caption,
        this.closing_time,
        this.waiting_time,
        this.phone_number
      });


  RestaurantModel.fromJson(Map<String,dynamic> json)
  {
    name =json['name'];
    closing_time = json['closing_time'];
    waiting_time = json['waiting_time'];
    caption = json['caption'];
    phone_number = json['phone_number'];
  }
}