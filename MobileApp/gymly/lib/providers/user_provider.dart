import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/user_service.dart';

final userProvider = Provider((ref) => UserService(ref.watch(authProvider),
    ref.watch(authProvider.notifier), ref.watch(storageProvider)));
