// domain/entities/internship_metadata_entity.dart
class InternshipMetadataEntity {
  final List<String> duration;
  final List<String> startMonth;
  final List<String> perks;
  final List<String> cities;
  final List<String> domains;
  final List<String> skills;
  final List<String> jobRoles;

  const InternshipMetadataEntity({
    required this.duration,
    required this.startMonth,
    required this.perks,
    required this.cities,
    required this.domains,
    required this.skills,
    required this.jobRoles,
  });

  // Factory to create from MasterDataEntity (from master/all API)
  factory InternshipMetadataEntity.fromMasterData(Map<String, dynamic> masterDataJson) {
    final data = masterDataJson['data'] as Map<String, dynamic>;

    // Extract duration values
    final duration = (data['duration'] as List)
        .map((e) => e['value'] as String)
        .toList();

    // Cities
    final cities = (data['locations'] as List)
        .map((e) => e['name'] as String)
        .toList();

    // Domains
    final domains = (data['domains'] as List)
        .map((e) => e['domain_name'] as String)
        .toList();

    // Skills: flatten all skills from skillsByDomain
    final List<String> skills = <String>[];
    final skillsByDomain = data['skillsByDomain'] as List;
    for (final domain in skillsByDomain) {
      final List skillList = domain['skills'];
      skills.addAll(
        skillList.map((s) => s['skill_name'] as String),
      );
    }
    // Remove duplicates
    final uniqueSkills = skills.toSet().toList();

    // Start month (static for now, unless in API)
    final startMonth = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    // Perks
    final perks = (data['perks'] as List)
        .map((e) => e['value'] as String)
        .toList();

    // jobRoles
    final jobRoles = (data['jobRoles'] as List)
        .map((e) => e['title'] as String)
        .toList();

    return InternshipMetadataEntity(
      duration: duration,
      startMonth: startMonth,
      perks: perks,
      cities: cities,
      domains: domains,
      skills: uniqueSkills,
      jobRoles: jobRoles,
    );
  }
}