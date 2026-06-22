part of 'create_room_cubit.dart';

enum CreateRoomStatus { idle, submitting, success, failure }

class CreateRoomState extends Equatable {
  const CreateRoomState({
    this.currentStep = 0,
    this.roomId,
    this.initializing = false,
    this.name = '',
    this.description = '',
    this.price = '',
    this.statusId = 1,
    this.latitude,
    this.longitude,
    this.address,
    this.serviceIds = const {},
    this.policies = const [],
    this.images = const [],
    this.existingImages = const [],
    this.showStepErrors = false,
    this.status = CreateRoomStatus.idle,
    this.errorCode,
  });

  static const lastStep = 2;

  final int currentStep;

  /// Non-null when the wizard is editing an existing room.
  final int? roomId;

  /// True while the edit form is fetching/seeding the existing room data.
  final bool initializing;

  final String name;
  final String description;
  final String price;
  final int statusId;

  // Step 1 — location.
  final double? latitude;
  final double? longitude;
  final String? address;

  // Step 1 — photos.
  final List<RoomImage> images;

  /// Existing server-side images (with ids) kept when editing.
  final List<RoomImageRef> existingImages;

  // Step 2 — services & policies.
  final Set<int> serviceIds;
  final List<SelectedPolicy> policies;


  final bool showStepErrors;

  final CreateRoomStatus status;
  final String? errorCode;

  bool get hasLocation => latitude != null && longitude != null;
  double? get priceValue => double.tryParse(price.trim());

  bool get isEditMode => roomId != null;
  int get totalPhotoCount => existingImages.length + images.length;

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        final p = priceValue;
        return name.trim().isNotEmpty &&
            description.trim().isNotEmpty &&
            p != null &&
            p > 0 &&
            hasLocation;
      default:
        return true;
    }
  }

  CreateRoomState copyWith({
    int? currentStep,
    int? roomId,
    bool? initializing,
    String? name,
    String? description,
    String? price,
    int? statusId,
    double? latitude,
    double? longitude,
    String? address,
    List<RoomImage>? images,
    List<RoomImageRef>? existingImages,
    Set<int>? serviceIds,
    List<SelectedPolicy>? policies,
    bool? showStepErrors,
    CreateRoomStatus? status,
    String? errorCode,
  }) {
    return CreateRoomState(
      currentStep: currentStep ?? this.currentStep,
      roomId: roomId ?? this.roomId,
      initializing: initializing ?? this.initializing,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      statusId: statusId ?? this.statusId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      images: images ?? this.images,
      existingImages: existingImages ?? this.existingImages,
      serviceIds: serviceIds ?? this.serviceIds,
      policies: policies ?? this.policies,
      showStepErrors: showStepErrors ?? this.showStepErrors,
      status: status ?? this.status,
      errorCode: errorCode,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        roomId,
        initializing,
        name,
        description,
        price,
        statusId,
        latitude,
        longitude,
        address,
        images,
        existingImages,
        serviceIds,
        policies,
        showStepErrors,
        status,
        errorCode,
      ];
}
