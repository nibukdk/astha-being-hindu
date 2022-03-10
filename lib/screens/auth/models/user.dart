class UserModel {
  final String username;
  final String email;
  UserProfileModel? userProfile;

  UserModel({
    required this.username,
    required this.email,
    this.userProfile,
  });
}

class UserProfileModel {
  final String imageUrl;
  final String address;
  final String lat;
  final String long;
  // final EventModel? favaoriteEvents;
  // final TempleModel? favoriteTemples;

  UserProfileModel({
    required this.imageUrl,
    required this.address,
    required this.lat,
    required this.long,
    // this.favaoriteEvents,
    // this.favoriteTemples,
  });
}
