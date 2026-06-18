import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/create_room_params.dart';
import '../../domain/entities/room_catalog.dart';
import '../../domain/entities/room_detail.dart';
import '../../domain/entities/room_image.dart';
import '../../domain/entities/room_status.dart';
import '../../domain/entities/selected_policy.dart';
import '../../domain/entities/update_room_params.dart';
import '../../domain/usecases/create_room_usecase.dart';
import '../../domain/usecases/get_room_detail_usecase.dart';
import '../../domain/usecases/update_room_usecase.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit({
    required CreateRoomUseCase createRoomUseCase,
    required UpdateRoomUseCase updateRoomUseCase,
    required GetRoomDetailUseCase getRoomDetailUseCase,
    required LocationService locationService,
  })  : _createRoomUseCase = createRoomUseCase,
        _updateRoomUseCase = updateRoomUseCase,
        _getRoomDetailUseCase = getRoomDetailUseCase,
        _locationService = locationService,
        super(const CreateRoomState());

  final CreateRoomUseCase _createRoomUseCase;
  final UpdateRoomUseCase _updateRoomUseCase;
  final GetRoomDetailUseCase _getRoomDetailUseCase;
  final LocationService _locationService;

  Future<void> loadForEdit(int roomId) async {
    emit(state.copyWith(roomId: roomId, initializing: true));
    try {
      final detail = await _getRoomDetailUseCase(roomId);
      emit(state.copyWith(
        initializing: false,
        name: detail.name,
        description: detail.description,
        price: detail.price.toString(),
        statusId: _statusIdFrom(detail.status),
        latitude: detail.latitude,
        longitude: detail.longitude,
        existingImages: detail.images,
        serviceIds: _serviceIdsFrom(detail.services),
        policies: _policiesFrom(detail.policies),
      ));
      final address = await _locationService
          .reverseGeocode(LatLngPoint(detail.latitude, detail.longitude));
      if (address != null) emit(state.copyWith(address: address));
    } on Failure catch (failure) {
      emit(state.copyWith(initializing: false, errorCode: failure.code));
    } catch (_) {
      emit(state.copyWith(initializing: false, errorCode: 'unknown.error'));
    }
  }

  int _statusIdFrom(RoomStatus status) => switch (status) {
        RoomStatus.available => 1,
        RoomStatus.unavailable => 2,
        RoomStatus.booked => 3,
        RoomStatus.unknown => 1,
      };

  Set<int> _serviceIdsFrom(List<String> services) {
    final ids = <int>{};
    for (final service in services) {
      final key = service.trim().toLowerCase();
      for (final option in kRoomServices) {
        if (option.name.toLowerCase() == key ||
            option.code.toLowerCase() == key) {
          ids.add(option.id);
          break;
        }
      }
    }
    return ids;
  }

  List<SelectedPolicy> _policiesFrom(List<RoomPolicyTag> policies) {
    final result = <SelectedPolicy>[];
    for (final policy in policies) {
      final key = policy.code.trim().toLowerCase();
      for (final option in kRoomPolicies) {
        if (option.code.toLowerCase() == key) {
          result.add(SelectedPolicy(
            id: option.id,
            code: option.code,
            name: option.name,
            description: policy.description,
          ));
          break;
        }
      }
    }
    return result;
  }

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
    try {
      final granted = await _locationService.ensurePermission();
      if (!granted) return false;
      final pos = await _locationService.getCurrentPosition();
      await setLocation(pos.latitude, pos.longitude);
      return true;
    } catch (_) {
      return false;
    }
  }

  void addImages(List<RoomImage> images) =>
      emit(state.copyWith(images: [...state.images, ...images]));

  void removeImage(int index) {
    final next = [...state.images]..removeAt(index);
    emit(state.copyWith(images: next));
  }

  void removeExistingImage(int id) {
    final next = state.existingImages.where((i) => i.id != id).toList();
    emit(state.copyWith(existingImages: next));
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
      if (state.isEditMode) {
        await _updateRoomUseCase(
          state.roomId!,
          UpdateRoomParams(
            roomId: state.roomId!,
            name: state.name.trim(),
            description: state.description.trim(),
            price: state.priceValue ?? 0,
            statusId: state.statusId,
            latitude: state.latitude!,
            longitude: state.longitude!,
            serviceIds: state.serviceIds.toList(),
            policies: state.policies,
            images: state.images,
            keptImageIds: state.existingImages.map((i) => i.id).toList(),
          ),
        );
      } else {
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
      }
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
