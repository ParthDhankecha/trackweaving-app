class ApiResponse<T> {
  final String code;
  final String message;
  final T? data;

  ApiResponse({required this.code, required this.message, this.data});

  /// Factory constructor to deserialize the JSON response.
  ///
  /// The key to generic parsing is the required 'dataConverter' function.
  /// This function takes the JSON map from the "data" field and converts
  /// it into the specific class T (e.g., PartChangeRecord).
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) dataConverter,
  ) {
    // 1. Parse the common fields
    final code = json['code'] as String;
    final message = json['message'] as String;

    // 2. Check if the 'data' field exists and is not null
    T? dataValue;
    if (json.containsKey('data') && json['data'] != null) {
      // 3. Use the provided dataConverter function to parse the inner JSON map
      // This is where the boilerplate is removed from the network call layer!
      try {
        dataValue = dataConverter(json['data'] as Map<String, dynamic>);
      } catch (e) {
        // Handle potential parsing errors in the data field
        print('Error parsing generic data field: $e');
        // You might throw an error or set dataValue to null based on your error strategy
      }
    }

    // 4. Return the fully constructed ApiResponse
    return ApiResponse<T>(code: code, message: message, data: dataValue);
  }

  // Helper to check if the response indicates success
  bool get isSuccess => code == 'OK';

  @override
  String toString() {
    return 'ApiResponse(code: $code, message: $message, data: $data)';
  }
}
