import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
enum Category{food, travel, leisure, work}

final formetter = DateFormat.yMd();

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie_filter,
  Category.work: Icons.work,
};

class Expense{

  Expense({required this.tital, required this.amount, required this.date, required this.category}): id = uuid.v4();

  final String id;
  final String tital;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatteddate{
    return formetter.format(date);
  }
}


