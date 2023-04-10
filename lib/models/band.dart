import 'package:flutter/material.dart';

class Band {
  String id;
  String name;
  int votes;

  Band({required this.id, required this.name, required this.votes});

  factory Band.fromMap(Map<String, dynamic> map) => Band(
        id: map.containsKey('id') ? map['id'] : 'no-id',
        name: map.containsKey('name') ? map['name'] : 'no-name',
        votes: map.containsKey('votes') ? map['votes'] : 0,
      );
}
