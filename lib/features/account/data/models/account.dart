import 'package:moniman/core/enums/currencies.dart';
import 'package:moniman/features/account/domain/entities/account.dart';
import 'package:moniman/features/account/domain/enums/account_status.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.encryptedBalance,
    required super.phoneNumber,
    required super.publicKey,
    super.currency,
    super.status,
    super.firstName,
    super.lastName,
    super.email,
    super.decryptedBalance,
    super.createdAt,
    super.updatedAt,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'],
      encryptedBalance: map['encryptedBalance'],
      phoneNumber: map['phoneNumber'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      publicKey: map['publicKey'],
      email: map['email'],
      decryptedBalance: map['decryptedBalance'],
      currency: Currencies.values.firstWhere(
        (e) => e.toString() == map['currency'],
        orElse: () => Currencies.xaf,
      ),
      status: AccountStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => AccountStatus.active,
      ),
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      id: account.id,
      encryptedBalance: account.encryptedBalance,
      phoneNumber: account.phoneNumber,
      firstName: account.firstName,
      lastName: account.lastName,
      publicKey: account.publicKey,
      email: account.email,
      decryptedBalance: account.decryptedBalance,
      currency: account.currency,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'encryptedBalance': encryptedBalance,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'publicKey': publicKey,
      'email': email,
      'status': status.toString().split('.').last,
      'currency': currency.toString().split('.').last,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'encryptedBalance': encryptedBalance,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'publicKey': publicKey,
      'email': email,
      'status': status.toString().split('.').last,
      'currency': currency.toString().split('.').last,
    };
  }
}
