import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    name: 'ALU Student',
    email: '',
    intake: 'S2024',
    role: 'Student',
    bio: '',
    interests: [],
  );

  UserModel get user => _user;
  bool get isOrganizer => _user.role == 'Club Leader' || _user.role == 'Organizer';

  void setOnboardingData({
    required List<String> interests,
    required String role,
    required String intake,
  }) {
    _user = UserModel(
      name: _user.name,
      email: _user.email,
      intake: intake,
      role: role,
      bio: _user.bio,
      interests: List.from(interests),
    );
    notifyListeners();
  }

  void setUserFromLogin({required String name, required String email}) {
    _user = UserModel(
      name: name,
      email: email,
      intake: _user.intake,
      role: _user.role,
      bio: _user.bio,
      interests: List.from(_user.interests),
    );
    notifyListeners();
  }

  void updateBio(String bio) {
    _user.bio = bio;
    notifyListeners();
  }

  void updateName(String name) {
    _user.name = name;
    notifyListeners();
  }

  void updateInterests(List<String> interests) {
    _user.interests = List.from(interests);
    notifyListeners();
  }

  void updateRole(String role) {
    _user.role = role;
    notifyListeners();
  }
}
