import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/circle.dart';
import '../repositories/circle_repository.dart';
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
