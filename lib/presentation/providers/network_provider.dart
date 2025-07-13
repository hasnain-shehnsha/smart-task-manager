import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());
final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfo(ref.watch(connectivityProvider)),
);
final isConnectedProvider = StreamProvider<bool>(
  (ref) => ref.watch(networkInfoProvider).onConnectivityChanged,
);
