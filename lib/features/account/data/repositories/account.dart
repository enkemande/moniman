import 'package:moniman/features/account/data/providers/remote_account.dart';
import 'package:moniman/features/account/domain/entities/account.dart';
import 'package:moniman/features/account/domain/repositories/account.dart';

class AccountRepositoryImpl implements AccountRepository {
  final RemoteAccountProvider remoteAccountProvider;

  AccountRepositoryImpl({
    required this.remoteAccountProvider,
  });

  @override
  Stream<Account> onAccountStateChange(String userId) {
    return remoteAccountProvider.onAccountStateChange(userId);
  }
}
