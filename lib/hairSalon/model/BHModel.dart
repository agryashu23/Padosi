import 'package:flutter/material.dart';

class BHBestSpecialModel {
  String title;
  String subTitle;
  String img;

  BHBestSpecialModel({required this.title, required this.subTitle, required this.img});
}

class BHCallModel {
  String img;
  String name;
  IconData callImg;
  String callStatus;
  String videoCallIcon;
  String audioCallIcon;

  BHCallModel({required this.img, required this.name, required this.callImg, required this.callStatus, required this.videoCallIcon, required this.audioCallIcon});
}

class BHCategoryModel {
  String img;
  String categoryName;

  BHCategoryModel({required this.img, required this.categoryName});
}

class BHGalleryModel {
  String img;

  BHGalleryModel({required this.img});
}

class BHHairStyleModel {
  String img;
  String name;

  BHHairStyleModel({required this.img, required this.name});
}

class BHIncludeServiceModel {
  String serviceImg;
  String serviceName;
  String time;
  int price;

  BHIncludeServiceModel({required this.serviceImg, required this.serviceName, required this.time, required this.price});
}

class BHMakeUpModel {
  String img;
  String name;

  BHMakeUpModel({required this.img, required this.name});
}

class MessageModel {
  String img;
  String name;
  String message;
  String lastSeen;

  MessageModel({required this.img, required this.name, required this.message, required this.lastSeen});
}

class BHNotificationModel {
  String img;
  String name;
  String msg;
  String status;
  String callInfo;

  BHNotificationModel({required this.img, required this.name, required this.msg, required this.status, required this.callInfo});
}
class BHNotifyModel {
  String img;
  String name;
  String address;
  double rating;
  double distance;

  BHNotifyModel({required this.img, required this.name, required this.address, required this.rating, required this.distance});
}

class BHOfferModel{

  String img;
  String offerName;
  String offerDate;
  int offerOldPrice;
  int offerNewPrice;

  BHOfferModel({required this.img, required this.offerName, required this.offerDate, required this.offerOldPrice,
    required this.offerNewPrice});
}


class BHReviewModel{

  String img;
  String name;
  double rating ;
  String day;
  String review;

  BHReviewModel({required this.img, required this.name, required this.rating, required this.day, required this.review});
}

class BHServicesModel{

  String img;
  String serviceName;
  String time;
  int price;
  bool radioVal;

  BHServicesModel({required this.img, required this.serviceName, required this.time, required this.price,required this.radioVal});
}

class BHPackagesModel{

  String img;
  String packageName;
  String time;
  int price;

  BHPackagesModel({required this.img, required this.packageName, required this.time, required this.price});
}

class BHSpecialOfferModel{
  String img;
  String title;
  String subtitle;

  BHSpecialOfferModel({required this.img, required this.title, required this.subtitle});
}

class BHMessageModel {
  int senderId;
  int receiverId;
  String msg;
  String time;

  BHMessageModel({required this.senderId, required this.receiverId, required this.msg, required this.time});
}
