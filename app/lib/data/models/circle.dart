/// Um círculo (grupo de 6–12 pessoas).
class Circle {
  const Circle({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.maxMembers,
  });

  final String id;
  final String name;
  final String inviteCode;
  final int maxMembers;

  factory Circle.fromJson(Map<String, dynamic> j) => Circle(
        id: j['id'] as String,
        name: (j['name'] as String?) ?? '',
        inviteCode: (j['invite_code'] as String?) ?? '',
        maxMembers: (j['max_members'] as int?) ?? 12,
      );
}

/// Estatística pública de um membro (nome + árvores na semana).
class MemberStat {
  const MemberStat({
    required this.userId,
    required this.displayName,
    required this.weeklyTrees,
  });

  final String userId;
  final String displayName;
  final int weeklyTrees;

  factory MemberStat.fromJson(Map<String, dynamic> j) => MemberStat(
        userId: j['user_id'] as String,
        displayName: (j['display_name'] as String?) ?? 'Member',
        weeklyTrees: (j['weekly_trees'] as int?) ?? 0,
      );
}
