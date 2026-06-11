import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/platform/location_service.dart';
import '../../domain/entities/create_room_params.dart';
import '../../domain/entities/room_image.dart';
import '../../domain/entities/selected_policy.dart';
import '../../domain/usecases/create_room_usecase.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit({
    required CreateRoomUseCase createRoomUseCase,
    required LocationService locationService,
  })  : _createRoomUseCase = createRoomUseCase,
        _locationService = locationService,
        super(const CreateRoomState());

  final CreateRoomUseCase _createRoomUseCase;
  final LocationService _locationService;

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateDescription(String value) =>
      emit(state.copyWith(description: value));
  void updatePrice(String value) => emit(state.copyWith(price: value));
  void updateStatus(int statusId) => emit(state.copyWith(statusId: statusId));

  Future<void> setLocation(double latitude, double longitude) async {
    emit(state.copyWith(
      latitude: latitude,
      longitude: longitude,
      address: null,
    ));
    final address =
        await _locationService.reverseGeocode(LatLngPoint(latitude, longitude));
    if (address != null) emit(state.copyWith(address: address));
  }

  Future<bool> useCurrentLocation() async {
    final granted = await _locationService.ensurePermission();
    if (!granted) return false;
    final pos = await _locationService.getCurrentPosition();
    await setLocation(pos.latitude, pos.longitude);
    return true;
  }

  void addImages(List<RoomImage> images) =>
      emit(state.copyWith(images: [...state.images, ...images]));

  void removeImage(int index) {
    final next = [...state.images]..removeAt(index);
    emit(state.copyWith(images: next));
  }

  void toggleService(int id) {
    final next = {...state.serviceIds};
    if (!next.add(id)) next.remove(id);
    emit(state.copyWith(serviceIds: next));
  }

  void addPolicy(SelectedPolicy policy) {
    if (state.policies.any((p) => p.id == policy.id)) return;
    emit(state.copyWith(policies: [...state.policies, policy]));
  }

  void removePolicy(int id) {
    final next = state.policies.where((p) => p.id != id).toList();
    emit(state.copyWith(policies: next));
  }

  void next() {
    if (!state.isCurrentStepValid) {
      emit(state.copyWith(showStepErrors: true));
      return;
    }
    if (state.currentStep < CreateRoomState.lastStep) {
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
        showStepErrors: false,
      ));
    }
  }

  void back() {
    if (state.currentStep > 0) {
      emit(state.copyWith(
        currentStep: state.currentStep - 1,
        showStepErrors: false,
      ));
    }
  }

  Future<void> submit() async {
    emit(state.copyWith(status: CreateRoomStatus.submitting));
    try {
      await _createRoomUseCase(
        CreateRoomParams(
          name: state.name.trim(),
          description: state.description.trim(),
          price: state.priceValue ?? 0,
          statusId: state.statusId,
          latitude: state.latitude!,
          longitude: state.longitude!,
          serviceIds: state.serviceIds.toList(),
          policies: state.policies,
          images: state.images,
        ),
      );
      emit(state.copyWith(status: CreateRoomStatus.success));
    } on Failure catch (failure) {
      emit(state.copyWith(
        status: CreateRoomStatus.failure,
        errorCode: failure.code,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: CreateRoomStatus.failure,
        errorCode: 'unknown.error',
      ));
    }
  }
}
