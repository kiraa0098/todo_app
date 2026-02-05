import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  static const Duration defaultTimeout = Duration(seconds: 3);
  static const String connectionErrorTag = '__CONNECTION_ERROR__';

  static void _debugConnectionTimeout(String method, Uri url, Exception e) {
    debugPrint('[BaseApi] $method timeout for $url: $e');
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    try {
      return await http
          .put(url, headers: headers, body: body)
          .timeout(timeout ?? defaultTimeout);
    } on TimeoutException catch (e) {
      _debugConnectionTimeout('PUT', url, e);
      throw connectionErrorTag;
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        _debugConnectionTimeout('PUT', url, e);
        throw connectionErrorTag;
      }
      rethrow;
    }
  }

  /// Generic POST request with timeout
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    try {
      return await http
          .post(url, headers: headers, body: body)
          .timeout(timeout ?? defaultTimeout);
    } on TimeoutException catch (e) {
      _debugConnectionTimeout('POST', url, e);
      throw connectionErrorTag;
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        _debugConnectionTimeout('POST', url, e);
        throw connectionErrorTag;
      }
      rethrow;
    }
  }

  /// Generic GET request with timeout
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      return await http
          .get(url, headers: headers)
          .timeout(timeout ?? defaultTimeout);
    } on TimeoutException catch (e) {
      _debugConnectionTimeout('GET', url, e);
      throw connectionErrorTag;
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        _debugConnectionTimeout('GET', url, e);
        throw connectionErrorTag;
      }
      rethrow;
    }
  }

  /// Generic DELETE request with timeout
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    try {
      return await http
          .delete(url, headers: headers, body: body)
          .timeout(timeout ?? defaultTimeout);
    } on TimeoutException catch (e) {
      _debugConnectionTimeout('DELETE', url, e);
      throw connectionErrorTag;
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        _debugConnectionTimeout('DELETE', url, e);
        throw connectionErrorTag;
      }
      rethrow;
    }
  }
}
