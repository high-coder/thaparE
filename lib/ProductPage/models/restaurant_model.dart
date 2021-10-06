import 'ProductsModel.dart';
import 'featuredItem.dart';

class RestaurantModel {
  String name;
  List images;
  List productsIds;
  List<FeaturedItem> productsData;
  List featuredItems;
  List<FeaturedItem> featuredItemsDetails;
  List orderData;
  String uid;
  List tags;
  String address;

  RestaurantModel(
      {this.name,
      this.featuredItems,
      this.images,
      this.productsIds,
      this.orderData,
      this.productsData,
      this.featuredItemsDetails,
      this.address,
      this.tags,
      this.uid});

  RestaurantModel fromJson({Map json}) {
    return RestaurantModel(
      name: json["name"],
      featuredItems: json["featured"],
      productsIds: json["products"],
      orderData: json["orders"],
      images: json["images"],
      productsData: [],
      uid: json["uid"],
      // after the user taps on the restaurant then we will load the data of the that restaurant
      featuredItemsDetails: [], // after the user taps on the restaurant then we will load the data of that restaurant
      tags: json["tags"],
      address: json["address"],
    );
  }
}
