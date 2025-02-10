// ignore_for_file: public_member_api_docs

import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:user_repository/user_repository.dart';

abstract class UserBaseRepository {
  String? get currentUserId;

  Stream<User> profile({required String userId});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient implements UserBaseRepository {
  /// {@macro database_client}
  const DatabaseClient();
}

class PowerSyncDatabaseClient extends DatabaseClient {
  const PowerSyncDatabaseClient({
    required PowerSyncRepository powerSyncRepository,
  }) : _powerSyncRepository = powerSyncRepository;

  final PowerSyncRepository _powerSyncRepository;

  @override
  String? get currentUserId =>
      _powerSyncRepository.supabase.auth.currentSession?.user.id;

  @override
  Stream<User> profile({required String userId}) =>
      _powerSyncRepository.db().watch(
        '''
        SELECT * FROM users WHERE id = ?
        ''',
        parameters: [userId],
      ).map(
        (event) => event.isEmpty ? User.anonymous : User.fromJson(event.first),
      );
}
