part of 'room_detail_cubit.dart';

sealed class RoomDetailState extends Equatable {
  const RoomDetailState();

  @override
  List<Object?> get props => [];
}

class RoomDetailLoading extends RoomDetailState {
  const RoomDetailLoading();
}

class RoomDetailLoaded extends RoomDetailState {
  const RoomDetailLoaded(this.detail, {this.address});

  final RoomDetail detail;
  final String? address;

  @override
  List<Object?> get props => [detail, address];
}

class RoomDetailFailureState extends RoomDetailState {
  const RoomDetailFailureState(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
