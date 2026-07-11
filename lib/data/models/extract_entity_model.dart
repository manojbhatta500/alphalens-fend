class ExtarctEntityModel {
  final String ticker;
  final List<Entities> entities;

  ExtarctEntityModel({
    required this.ticker,
    required this.entities,
  });

  factory ExtarctEntityModel.fromJson(Map<String, dynamic> json) {
    var rawEntities = json['entities'];
    List<Entities> parsedEntities = [];
    
    if (rawEntities != null && rawEntities is List) {
      parsedEntities = rawEntities
          .map((v) => Entities.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    return ExtarctEntityModel(
      ticker: json['ticker']?.toString() ?? '',
      entities: parsedEntities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'entities': entities.map((v) => v.toJson()).toList(),
    };
  }
}

class Entities {
  final String name;
  final String entityType;
  final String role;
  final String details;
  final String source;

  Entities({
    required this.name,
    required this.entityType,
    required this.role,
    required this.details,
    required this.source,
  });

  factory Entities.fromJson(Map<String, dynamic> json) {
    return Entities(
      name: json['name']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'entity_type': entityType,
      'role': role,
      'details': details,
      'source': source,
    };
  } 
}