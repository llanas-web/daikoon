// ignore_for_file: public_member_api_docs

class PowersyncJsonUtils {
  static bool boolFromInt(int value) => value == 1;
  // ignore: avoid_positional_boolean_parameters
  static int boolToInt(bool value) => value ? 1 : 0;
}
