import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/focus_session/focus_session_controller.dart';
import '../models/circle.dart';
import '../repositories/circle_repository.dart';
import '../services/presence_service.dart';
import '../services/supabase_service.dart';

final circleRepositoryProvider = Provider<CircleRepository>(
  (ref) => CircleRepository(),
);

/// Uid da sessão como provider — permite override no demo seed (o "Você" da
/// liga depende dele) e desacopla as telas do singleton.
final currentUserIdProvider = Provider<String?>(
  (ref) => SupabaseService.instance.currentUserId,
);

/// Círculo atual do usuário (null = não está em nenhum).
final myCircleProvider = FutureProvider<Circle?>(
  (ref) => ref.watch(circleRepositoryProvider).myCircle(),
);

/// Membros + árvores na semana de um círculo.
final circleMembersProvider = FutureProvider.family<List<MemberStat>, String>(
  (ref, circleId) => ref.watch(circleRepositoryProvider).members(circleId),
);

/// Presença ao vivo do círculo ("X focando agora"). Best-effort: emite
/// `CirclePresence()` vazio até o realtime sincronizar; se cair, fica vazio.
/// Reflete a fase de foco do próprio usuário no canal (auto-track).
///
/// autoDispose: sem ouvinte (saiu/trocou de círculo, fechou a tela), o canal
/// é encerrado — a presença cai pros outros. Enquanto qualquer aba mantiver o
/// _Detail vivo (IndexedStack), o canal segue publicando mesmo na aba de foco.
final circlePresenceProvider = StreamProvider.autoDispose
    .family<CirclePresence, String>((ref, circleId) {
      final uid = ref.watch(currentUserIdProvider);
      if (uid == null) return const Stream.empty();

      final channel = CirclePresenceChannel(circleId: circleId, userId: uid);
      channel.join();

      // Publica no canal quando o usuário entra/sai de uma sessão de foco.
      ref.listen(focusSessionProvider.select((s) => s.phase), (_, phase) {
        channel.setFocusing(phase == FocusPhase.running);
      }, fireImmediately: true);

      ref.onDispose(channel.dispose);
      return channel.stream;
    });
