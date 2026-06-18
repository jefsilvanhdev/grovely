/// Tipos de árvore disponíveis (biblioteca em assets/brand/trees/).
enum TreeType {
  oak('oak'),
  pine('pine'),
  roundBush('round-bush'),
  willow('willow'),
  birch('birch'),
  cherryBlossom('cherry-blossom');

  const TreeType(this.slug);
  final String slug;

  static TreeType fromSlug(String s) => TreeType.values.firstWhere(
    (t) => t.slug == s,
    orElse: () => TreeType.oak,
  );
}

/// Estágios de crescimento (arquivos `<tipo>-<estagio>.svg`).
enum TreeStage {
  seed('seed'),
  sprout('sprout'),
  sapling('sapling'),
  young('young'),
  mature('mature'),
  elder('elder'),
  withered('withered');

  const TreeStage(this.slug);
  final String slug;

  /// Estágio de crescimento proporcional ao progresso (0..1) da sessão.
  /// `withered` é estado à parte (sessão falha), não derivado do progresso.
  static TreeStage fromProgress(double p) {
    if (p <= 0) return TreeStage.seed;
    if (p < 0.20) return TreeStage.seed;
    if (p < 0.40) return TreeStage.sprout;
    if (p < 0.60) return TreeStage.sapling;
    if (p < 0.80) return TreeStage.young;
    if (p < 1.0) return TreeStage.mature;
    return TreeStage.elder;
  }
}

/// Caminho do asset SVG para um tipo+estágio.
String treeAsset(TreeType type, TreeStage stage) =>
    'assets/brand/trees/${type.slug}-${stage.slug}.svg';
