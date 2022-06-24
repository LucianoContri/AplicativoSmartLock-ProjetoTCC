import 'package:smartlock/models/Labs.dart';
import 'package:smartlock/models/Reserve.dart';

class LabArguments {
  final Reserve? reserve;
  final Laboratorio? laboratorio;
  final String? origin;

  LabArguments(this.laboratorio, this.reserve, this.origin);
}
