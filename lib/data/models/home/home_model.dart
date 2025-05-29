import 'package:xnime_app/data/models/home/completed_section.dart';
import 'package:xnime_app/data/models/home/ongoing_section.dart';

class HomeModel {
  final OngoingSection ongoing;
  final CompletedSection completed;

  const HomeModel({required this.ongoing, required this.completed});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    ongoing: OngoingSection.fromJson(json['data']['ongoing']),
    completed: CompletedSection.fromJson(json['data']['completed']),
  );

  Map<String, dynamic> toJson() => {
    'data': {"ongoing": ongoing.toJson(), "completed": completed.toJson()},
  };
}
