import 'package:provider/provider.dart';

import 'package:KYC/Model/Kyc_level_model.dart';

final providers = <SingleChildCloneableWidget>[
  ChangeNotifierProvider(create: (_) => KYCModel())
];

// final providers = <SingleChildCloneableWidgett>[
//
