enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  unknown;

  static BookingStatus fromBackend(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.unknown;
    }
  }
}
