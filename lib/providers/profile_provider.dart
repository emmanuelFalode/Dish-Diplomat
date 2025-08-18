import 'package:foodapp/models/profile_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

List<ProfileModel> profileList = [
  ProfileModel(name: 'Personal Info'),
  ProfileModel(name: 'Address'),
  ProfileModel(name: 'Cart'),
  ProfileModel(name: 'Favorite'),
  ProfileModel(name: 'Notifications'),
  ProfileModel(name: 'Payement Method'),
  ProfileModel(name: 'FAQs'),
  ProfileModel(name: 'User Review'),
  ProfileModel(name: 'Setting'),
  ProfileModel(name: 'Logout'),
];

@riverpod
List<ProfileModel> profile(ref) {
  return profileList;
}
