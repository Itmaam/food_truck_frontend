import 'package:food_truck_finder_user_app/api/core/http_client.dart';

abstract class BaseCRUDApi<T> {
  final HttpClient httpClient;

  BaseCRUDApi(String baseUrl) : httpClient = createHttpClient(baseUrl);

  Future<T> create(T entity) async {
    final response = await httpClient.post('/create', body: entity);
    return fromJson(response as Map<String, dynamic>);
  }

  Future<T> update(int id, T entity) async {
    final response = await httpClient.put('/update/$id', body: entity);
    return fromJson(response as Map<String, dynamic>);
  }

  Future<T> getById(int id) async {
    final response = await httpClient.get('/$id');
    return fromJson(response as Map<String, dynamic>);
  }

  Future<List<T>> list({
    int take = 20,
    int skip = 0,
    String? search,
    String? orderBy,
    Map<String, dynamic>? filter,
  }) async {
    final response = await httpClient.get(
      '/list',
      queryParameters: {
        'take': take,
        'skip': skip,
        'search': search,
        'orderBy': orderBy,
        ...(filter ?? {}).map((key, value) => MapEntry('filter.$key', value)),
      },
    );
    return (response as List)
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> delete(int id) async {
    await httpClient.delete('/$id');
  }

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T entity);
}
