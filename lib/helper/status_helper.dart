import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/helper/Databases.dart';

class StatusHelper {
  static final StatusHelper _instance = StatusHelper.internal();

  factory StatusHelper() => _instance;

  StatusHelper.internal();

  Databases databases = new Databases();

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }
}

class Status {
  dynamic id;
  dynamic status;

  Status({this.id, this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(id: json['id'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return "Status(id: $id, status: $status)";
  }
}
