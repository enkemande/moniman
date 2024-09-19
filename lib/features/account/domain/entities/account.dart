import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:moniman/core/enums/currencies.dart';
import 'package:moniman/core/extensions/currency.dart';
import 'package:moniman/features/account/domain/enums/account_status.dart';

class Account extends Equatable {
  final String id;
  final String phoneNumber;
  final String encryptedBalance;
  final Currencies currency;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? decryptedBalance;
  final String publicKey;
  final AccountStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? frontIDCardImageUrl;
  final String? backIDCardImageUrl;
  final String? selfieIDCardImageUrl;

  const Account({
    required this.id,
    required this.encryptedBalance,
    this.currency = Currencies.xaf,
    this.status = AccountStatus.active,
    required this.phoneNumber,
    required this.publicKey,
    this.decryptedBalance,
    this.firstName,
    this.lastName,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.frontIDCardImageUrl,
    this.backIDCardImageUrl,
    this.selfieIDCardImageUrl,
  });

  Account copyWith({
    String? id,
    String? encryptedBalance,
    Currencies? currency,
    AccountStatus? status,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? publicKey,
    String? decryptedBalance,
  }) {
    return Account(
      id: id ?? this.id,
      encryptedBalance: encryptedBalance ?? this.encryptedBalance,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      publicKey: publicKey ?? this.publicKey,
      email: email ?? this.email,
      decryptedBalance: decryptedBalance ?? this.decryptedBalance,
    );
  }

  static Account empty() {
    return const Account(
      id: '',
      encryptedBalance: '',
      phoneNumber: '',
      publicKey: '',
    );
  }

  bool get isEmpty {
    return id.isEmpty && encryptedBalance.isEmpty && phoneNumber.isEmpty;
  }

  String get fullName {
    return '$firstName $lastName';
  }

  String get formattedBalance {
    return NumberFormat.currency(
      locale: 'en_US',
      customPattern: '#,### \u00a4',
      symbol: currency.symbol,
      decimalDigits: 0,
    ).format(double.parse(decryptedBalance ?? '0'));
  }

  @override
  List<Object?> get props => [
        id,
        encryptedBalance,
        currency,
        status,
        phoneNumber,
        firstName,
        lastName,
        email,
        decryptedBalance,
        createdAt,
        updatedAt,
        publicKey,
        frontIDCardImageUrl,
        backIDCardImageUrl,
        selfieIDCardImageUrl,
      ];
}
