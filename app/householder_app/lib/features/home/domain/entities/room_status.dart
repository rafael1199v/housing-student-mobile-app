enum RoomStatus {
  available,
  unavailable,
  booked,
  unknown;
  
  static RoomStatus fromBackend(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'available':
        return RoomStatus.available;
      case 'unavailable':
        return RoomStatus.unavailable;
      case 'booked':
        return RoomStatus.booked;
      default:
        return RoomStatus.unknown;
    }
  }
}
