import 'tree.dart';

/// Uma árvore conquistada (sessão de foco concluída) no jardim pessoal.
class CompletedTree {
  const CompletedTree({
    required this.type,
    required this.durationMinutes,
    required this.completedAt,
  });

  final TreeType type;
  final int durationMinutes;
  final DateTime completedAt;

  Map<String, dynamic> toJson() => {
        'type': type.slug,
        'duration': durationMinutes,
        'at': completedAt.toIso8601String(),
      };

  factory CompletedTree.fromJson(Map<String, dynamic> j) => CompletedTree(
        type: TreeType.fromSlug(j['type'] as String),
        durationMinutes: j['duration'] as int,
        completedAt: DateTime.parse(j['at'] as String),
      );
}
