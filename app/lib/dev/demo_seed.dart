// TEMP-DEMO: overrides de providers para visualização com dados populados
// (jardim cheio, círculo com membros, liga). NÃO COMMITAR ligado no main.
import '../data/models/circle.dart';
import '../data/models/completed_tree.dart';
import '../data/models/tree.dart';
import '../data/providers/circle_provider.dart';
import '../data/providers/garden_provider.dart';

List<CompletedTree> _demoTrees() {
  final now = DateTime.now();
  CompletedTree t(TreeType type, int daysAgo, int min, [int hour = 9]) =>
      CompletedTree(
        type: type,
        durationMinutes: min,
        completedAt: DateTime(now.year, now.month, now.day, hour)
            .subtract(Duration(days: daysAgo)),
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

const _demoMembers = [
  MemberStat(userId: 'u1', displayName: 'Jeff', weeklyTrees: 10),
  MemberStat(userId: 'u2', displayName: 'Nicole', weeklyTrees: 8),
  MemberStat(userId: 'u3', displayName: 'Marina', weeklyTrees: 7),
  MemberStat(userId: 'u4', displayName: 'Rafael', weeklyTrees: 5),
  MemberStat(userId: 'u5', displayName: 'Théo', weeklyTrees: 4),
  MemberStat(userId: 'u6', displayName: 'Denise', weeklyTrees: 3),
  MemberStat(userId: 'u7', displayName: 'Gui', weeklyTrees: 2),
  MemberStat(userId: 'u8', displayName: 'Sônia', weeklyTrees: 1),
];

final demoSeedOverrides = [
  gardenProvider.overrideWith(_DemoGarden.new),
  myCircleProvider.overrideWith((ref) async => _demoCircle),
  circleMembersProvider.overrideWith((ref, id) async => _demoMembers),
];
