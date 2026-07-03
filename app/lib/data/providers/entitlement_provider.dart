import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado do plano do usuário (fonte única para Profile e guard do paywall).
///
/// Hoje é um stub (todo mundo `free`); o Agente D troca a implementação pelo
/// CustomerInfo do RevenueCat sem mexer em quem consome. O demo seed faz
/// override para exercitar os estados trial/plus.
enum PlanStatus { free, trial, plus }

class Entitlement {
  const Entitlement(
    this.status, {
    this.trialDaysLeft,
    this.renewsAt,
    this.memberSince,
    this.isAnnual,
  });

  final PlanStatus status;
  final int? trialDaysLeft; // trial
  final DateTime? renewsAt; // plus
  final DateTime? memberSince; // plus
  final bool? isAnnual; // plus

  static const free = Entitlement(PlanStatus.free);

  bool get isPaying => status != PlanStatus.free;
}

final entitlementProvider = Provider<Entitlement>((ref) => Entitlement.free);
