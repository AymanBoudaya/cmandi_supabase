import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';

Future<void> main() async {
  // Add Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
// Init Local storage
  await GetStorage.init();

  // Await splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 4. Initialiser Supabase (avec gestion d'erreur)
  try {
    await Supabase.initialize(
      url: 'https://yjcopixznzprehftnymq.supabase.co', // 🔹 Ton URL Supabase
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqY29waXh6bnpwcmVoZnRueW1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxNzgxNjYsImV4cCI6MjA2ODc1NDE2Nn0.BhLKrFyMmKtmpHuoCdlJ_coTo8HQuPKcNj_UGhHIXOA', // 🔹 Ta clé publique
    );

    // 5. Injecter le repository d'authentification
    Get.put(AuthenticationRepository());
    usePathUrlStrategy();
    runApp(App());
  } catch (e, stack) {
    debugPrint('Erreur lors de l\'initialisation de Supabase: $e');
    debugPrintStack(stackTrace: stack);
    // En prod, tu pourrais afficher un écran d'erreur ou logger l'événement
  }
}
