// TEMP-DEMO: overrides de providers para visualização com dados populados
// (jardim cheio, círculo com membros, liga). NÃO COMMITAR ligado no main.
import '../data/models/circle.dart';
import '../data/models/completed_tree.dart';
import '../data/models/tree.dart';
import '../data/providers/circle_provider.dart';
import '../data/providers/entitlement_provider.dart';
import '../data/providers/garden_provider.dart';

List<CompletedTree> _demoTrees() {
  final now = DateTime.now();
  CompletedTree t(TreeType type, int daysAgo, int min, [int hour = 9]) =>
      CompletedTree(
        type: type,
        durationMinutes: min,
        completedAt: DateTime(
          now.year,
          now.month,
          now.day,
          hour,
        ).subtract(Duration(days: daysAgo)),
      );
  return [
    // Semana atual (streak de 6 dias) — mistura de espécies e durações.
    t(TreeType.oak, 0, 45, 8),
    t(TreeType.cherryBlossom, 0, 25, 14),
    t(TreeType.pine, 1, 60),
    t(TreeType.birch, 1, 25, 16),
    t(TreeType.willow, 2, 45),
    t(TreeType.roundBush, 3, 25),
    t(TreeType.oak, 3, 25, 19),
    t(TreeType.pine, 4, 90),
    t(TreeType.cherryBlossom, 5, 25),
    // Semanas anteriores.
    t(TreeType.birch, 8, 45),
    t(TreeType.oak, 9, 60),
    t(TreeType.willow, 10, 25),
    t(TreeType.pine, 11, 25),
    t(TreeType.roundBush, 12, 45),
    t(TreeType.oak, 14, 25),
    t(TreeType.birch, 15, 60),
    t(TreeType.cherryBlossom, 16, 25),
    t(TreeType.willow, 18, 45),
    t(TreeType.pine, 20, 25),
    t(TreeType.oak, 21, 90),
    t(TreeType.roundBush, 22, 25),
    t(TreeType.birch, 24, 45),
    t(TreeType.oak, 25, 25),
  ];
}

class _DemoGarden extends GardenNotifier {
  @override
  Future<List<CompletedTree>> build() async => _demoTrees();
}

const _demoCircle = Circle(
  id: 'demo-circle',
  name: 'Sprint da Manhã',
  inviteCode: 'GRV4TA',
  maxMembers: 12,
);

/// "Jeff" = u1, e o `currentUserIdProvider` também é overridado pra u1 —
/// assim o highlight/"Você" da liga sempre renderiza no demo (P1-5), sem
/// depender do timing do signin anônimo.
List<MemberStat> _demoMembers() => [
  const MemberStat(userId: 'u1', displayName: 'Jeff', weeklyTrees: 10),
  const MemberStat(userId: 'u2', displayName: 'Nicole', weeklyTrees: 8),
  const MemberStat(userId: 'u3', displayName: 'Marina', weeklyTrees: 7),
  const MemberStat(userId: 'u4', displayName: 'Rafael', weeklyTrees: 5),
  const MemberStat(userId: 'u5', displayName: 'Théo', weeklyTrees: 4),
  const MemberStat(userId: 'u6', displayName: 'Denise', weeklyTrees: 3),
  const MemberStat(userId: 'u7', displayName: 'Gui', weeklyTrees: 2),
  const MemberStat(userId: 'u8', displayName: 'Sônia', weeklyTrees: 1),
];

final demoSeedOverrides = [
  gardenProvider.overrideWith(_DemoGarden.new),
  myCircleProvider.overrideWith((ref) async => _demoCircle),
  circleMembersProvider.overrideWith((ref, id) async => _demoMembers()),
  currentUserIdProvider.overrideWithValue('u1'),
  // Estado Plus real (card de plano no Profile + guard do paywall).
  entitlementProvider.overrideWithValue(
    Entitlement(
      PlanStatus.plus,
      memberSince: DateTime(2026, 6, 12),
      renewsAt: DateTime(2027, 6, 12),
      isAnnual: true,
    ),
  ),
];
