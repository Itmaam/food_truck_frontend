import 'dart:convert';

/// Same as jsonDecode but it doesn't throw an exception when the object is not a valid json.
dynamic tryJsonDecode(dynamic source) {
  try {
    return jsonDecode(source as String);
  } catch (_) {
    return null;
  }
}

/// Gets a value from a json object by specified path which is a dot-separated string.
/// If the path does not exist, it will return null.
dynamic get(dynamic json, String path) {
  List<String> keys = path.split('.');

  if (keys.isEmpty) {
    return null;
  }

  final currentKey = int.tryParse(keys.first) ?? keys.first;

  dynamic value = json[currentKey];

  if (keys.length == 1) {
    return value;
  }

  return get(value, keys.sublist(1).join('.'));
}

/// Sets a value to a json object by specified path which is a dot-separated string.
/// If the path does not exist, it will be created.
void set(dynamic json, String path, dynamic value) {
  List<String> keys = path.split('.');

  if (keys.isEmpty) {
    return;
  }

  final currentKey = int.tryParse(keys.first) ?? keys.first;
  final nextKey = keys.length > 1 ? int.tryParse(keys[1]) ?? keys[1] : null;

  if (nextKey == null) {
    json[currentKey] = value;
    return;
  }

  if (json[currentKey] == null) {
    json[currentKey] =
        nextKey is int
            ? List<dynamic>.filled(nextKey + 1, null)
            : <String, dynamic>{};
  }

  set(json[currentKey], keys.sublist(1).join('.'), value);
}
