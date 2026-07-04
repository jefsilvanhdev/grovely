import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Foto de perfil local (galeria → cópia no diretório do app). Null = sem
/// foto (avatar mostra a inicial do nome). Upload pra nuvem entra junto com
/// o auth real — por ora a foto é só do dono.
class ProfilePhotoNotifier extends Notifier<String?> {
  static const _pref = 'profile_photo_path';

  @override
  String? build() {
    unawaited(
      SharedPreferences.getInstance().then((p) {
        final path = p.getString(_pref);
        // Arquivo pode ter sido limpo pelo SO — não aponta pro vazio.
        if (path != null && File(path).existsSync() && path != state) {
          state = path;
        }
      }),
    );
    return null;
  }

  /// Abre o photo picker do sistema (sem permissão em Android 13+) e guarda
  /// uma cópia reduzida. Retorna false se o usuário cancelou ou deu erro.
  Future<bool> pickFromGallery() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked == null) return false;
      final dir = await getApplicationDocumentsDirectory();
      final dest = File(
        '${dir.path}/profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(picked.path).copy(dest.path);

      // Remove a foto anterior (não acumula lixo no docs dir).
      final old = state;
      if (old != null) {
        try {
          await File(old).delete();
        } catch (_) {}
      }

      state = dest.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pref, dest.path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> remove() async {
    final old = state;
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pref);
    if (old != null) {
      try {
        await File(old).delete();
      } catch (_) {}
    }
  }
}

final profilePhotoProvider = NotifierProvider<ProfilePhotoNotifier, String?>(
  ProfilePhotoNotifier.new,
);
