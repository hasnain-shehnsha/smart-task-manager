import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/task_list_screen.dart';
import 'presentation/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: SmartTaskManagerApp()));
}

class SmartTaskManagerApp extends ConsumerWidget {
  const SmartTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Smart Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: authState.user == null ? LoginScreen() : const TaskListScreen(),
    );
  }
}
