import 'package:dockcheck/models/invite.dart';
import 'package:dockcheck/services/api_service.dart';

class InviteRepository {
  final ApiService apiService;

  InviteRepository(this.apiService);

  Future<Invite?> createInvite(Invite invite) async {
    try {
      final data = await apiService.post('invites/create', invite.toJson());
      return Invite.fromJson(data);
    } catch (error) {
      print('Error creating invite: $error');
      return null;
    }
  }

  Future<Invite?> getInviteById(String inviteId) async {
    try {
      final data = await apiService.get('invites/$inviteId');
      return Invite.fromJson(data);
    } catch (error) {
      print('Error getting invite: $error');
      return null;
    }
  }

  Future<List<Invite>> getAllInvites() async {
    try {
      final data = await apiService.get('invites');
      return (data as List).map((item) => Invite.fromJson(item)).toList();
    } catch (error) {
      print('Error getting invites: $error');
      return [];
    }
  }

  Future<Invite?> updateInvite(String inviteId, Invite invite) async {
    try {
      final data = await apiService.put('invites/$inviteId', invite.toJson());
      return Invite.fromJson(data);
    } catch (error) {
      print('Error updating invite: $error');
      return null;
    }
  }
}
