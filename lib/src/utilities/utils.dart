import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/road.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';

const String oSRMServer = "https://routing.openstreetmap.de";
const double earthRadius = 6371009;
typedef TurnByTurnInformation = ({
  RoadInstruction currentInstruction,
  RoadInstruction? nextInstruction,
  double distance
});

enum Languages {
  en,
  es,
  de,
  ar,
  // ignore: constant_identifier_names
  pt_br,
}

enum RoadType {
  car,
  foot,
  bike,
}

enum Profile {
  route,
  trip,
}

enum Overview {
  simplified,
  full,
  none,
}

enum Geometries {
  polyline,
  polyline6,
  geojson,
}

enum SourceGeoPointOption {
  any,
  first,
}

enum DestinationGeoPointOption {
  any,
  last,
}

extension RoadTypeExtension on RoadType {
  String get value {
    return ["car", "foot", "bike"][index];
  }
}

extension OverviewExtension on Overview {
  String get value {
    return ["simplified", "full", "false"][index];
  }
}

extension GeometriesExtension on Geometries {
  String get value {
    return ["polyline", "polyline6", "geojson"][index];
  }
}

extension TransformToWaysOSRM on List<LngLat> {
  String toWaypoints() {
    return map((e) => e.toString())
        .reduce((value, element) => "$value;$element");
  }
}

double parseToDouble(dynamic value) {
  return double.parse(value.toString());
}

/// parseRoad
/// this method used to parse json get it  from route service to [Road] object
/// we use this method in another thread like compute
/// the [data] is [ParserRoadComputeArg] that will to be parsed to [Road]
/// fix parsing problem [#1]
/// return [Road] object that contain list of waypoint
/// and distance and duration of the road
Future<Road> parseRoad(ParserRoadComputeArg data) async {
  Map<String, dynamic> jsonResponse = data.jsonRoad;
  bool alternative = data.alternative;
  var road = Road.empty();
  final List<Map<String, dynamic>> routes =
      List.castFrom(jsonResponse["routes"]);

  final route = routes.first;

  road = Road.fromOSRMJson(
    route: route,
  );

  if (routes.length > 1 && alternative) {
    routes.removeAt(0);
    for (var route in routes) {
      final alternative = Road.fromOSRMJson(
        route: route,
      );
      road.addAlternativeRoute(alternative);
    }
  }

  return road;
}

/// [parseTrip
/// ]
/// this method used to parse json get from trip service,
/// the [data] is  [ParserTripComputeArg] that contain information need it to be parsed to [Road]
/// such as json map and language that will be instruction
/// return [Road] object that contain list of waypoint and other information
/// this road represent trip that will pass by all geopoint entered as args
/// and this road will not be the shortes route
Future<Road> parseTrip(ParserTripComputeArg data) async {
  Map<String, dynamic> jsonResponse = data.jsonRoad;
  var road = Road.empty();
  final List<Map<String, dynamic>> routes =
      List.castFrom(jsonResponse["trips"]);
  final route = routes.first;
  road = Road.fromOSRMJson(
    route: route,
  );

  return road;
}
