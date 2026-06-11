import 'package:equatable/equatable.dart';


class SelectedPolicy extends Equatable {
  final int id;
  final String code;
  final String name;
  final String description;

  const SelectedPolicy({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
  });

  SelectedPolicy copyWith({String? description}) => SelectedPolicy(
        id: id,
        code: code,
        name: name,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [id, code, name, description];
}
