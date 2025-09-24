import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());

final profileSubmissionProvider = StateNotifierProvider<ProfileSubmissionNotifier, AsyncValue<int?>>((ref) {
  return ProfileSubmissionNotifier(ref.read(profileServiceProvider));
});

class ProfileSubmissionNotifier extends StateNotifier<AsyncValue<int?>> {
  final ProfileService _service;

  ProfileSubmissionNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> submitProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.submitProfile(profile);
      state = AsyncValue.data(id);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}