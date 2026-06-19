import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/circle.dart';
import '../repositories/circle_repository.dart';

final circleRepositoryProvider =
    Provider<CircleRepository>((ref) => CircleRepository());

/// Círculo atual do usuário (null = não está em nenhum).
final myCircleProvider = FutureProvider<Circle?>(
    (ref) => ref.watch(circleRepositoryProvider).myCircle());

/// Membros + árvores na semana de um círculo.
final circleMembersProvider = FutureProvider.family<List<MemberStat>, String>(
    (ref, circleId) => ref.watch(circleRepositoryProvider).members(circleId));
