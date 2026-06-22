class BookingRequest {
  final String id;
  final String requesterName;
  final String propertyName;
  final String? bookerImageUrl;

  const BookingRequest({
    required this.id,
    required this.requesterName,
    required this.propertyName,
    this.bookerImageUrl,
  });
}
