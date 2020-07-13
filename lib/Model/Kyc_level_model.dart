import 'package:KYC/Screens/Kyc_level.dart';
import 'package:flutter/cupertino.dart';

class KYCModel extends ChangeNotifier {
  int _kycValue;

  KYCModel() {
    this._kycValue = 0;
  }

  int get kycLevel => _kycValue;
  setKycLevel(int kycValue) => _kycValue = kycValue;

  void updateKycLevel() {
    _kycValue = _kycValue++;

    notifyListeners();
  }
}
