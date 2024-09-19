import 'package:moniman/features/account/domain/entities/account.dart';

abstract class AccountRepository {
  Stream<Account> onAccountStateChange(String userId);
}
