import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/platform/location_service.dart';
import '../../domain/entities/room_detail.dart';
import '../../domain/usecases/get_room_detail_usecase.dart';

part 'room_detail_state.dart';

class RoomDetailCubit extends Cubit<RoomDetailState> {
  RoomDetailCubit({
    required GetRoomDetailUseCase getRoomDetailUseCase,
    required LocationService locationService,
  })  : _getRoomDetailUseCase = getRoomDetailUseCase,
        _locationService = locationService,
        super(const RoomDetailLoading());

  final GetRoomDetailUseCase _getRoomDetailUseCase;
  final LocationService _locationService;

  Future<void> load(int roomId) async {
    emit(const RoomDetailLoading());
    try {
      final detail = await _getRoomDetailUseCase(roomId);
      emit(RoomDetailLoaded(detail));
      final address = await _resolveAddress(detail);
      if (address != null && state is RoomDetailLoaded) {
        emit(RoomDetailLoaded(detail, address: address));
      }
    } on Failure catch (failure) {
      emit(RoomDetailFailureState(failure.code));
    } catch (_) {
      emit(const RoomDetailFailureState('unknown.error'));
    }
  }

  Future<String?> _resolveAddress(RoomDetail detail) async {
    try {
      return await _locationService
          .reverseGeocode(LatLngPoint(detail.latitude, detail.longitude));
    } catch (_) {
      return null;
    }
  }
}
