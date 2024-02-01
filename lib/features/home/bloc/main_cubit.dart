import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/custom_interceptor.dart';
import 'package:prosto_doc/core/models/category_model.dart';
import 'package:prosto_doc/core/models/document_model.dart';
import 'package:prosto_doc/core/models/downloaded_document.dart';
import 'package:prosto_doc/core/models/send_code_phone.dart';
import 'package:prosto_doc/core/models/user_model.dart';

part 'main_state.dart';

final dio = Dio()..interceptors.add(DatasourceInterceptor());

const storage = FlutterSecureStorage();

class MainCubit extends Cubit<MainState> {
  String role = '';
  MainCubit() : super(MainInitial());

  Future<SendCodePhone?> sendCodePhone(String phone) async {
    try {
      Response response =
          await dio.post('$baseUrl/api/v1/auth/send-code-phone', data: {
        "phone": phone,
      });

      if (response.statusCode == 200) {
        return SendCodePhone.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<List<Categories>?> getCategories() async {
    try {
      Response response =
          await dio.get('$baseUrl/api/v1/categories/', queryParameters: {
        "category_type": 'parents',
      });

      if (response.statusCode == 200) {
        final res = List<Categories>.from(
            response.data.map((x) => Categories.fromJson(x)));
        print(res.map((e) => e.name));
        return res;
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<List<Categories>?> getSubCategories() async {
    try {
      Response response =
          await dio.get('$baseUrl/api/v1/categories/', queryParameters: {
        "category_type": 'children',
      });

      if (response.statusCode == 200) {
        return List<Categories>.from(
            response.data.map((x) => Categories.fromJson(x)));
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<List<Categories>?> getSubcategories(int id) async {
    print(role);
    // try {
    Response response = await dio.get('$baseUrl/api/v1/categories/',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        queryParameters: {
          "category_type": 'all',
          "parent_category_id": id,
        });

    if (response.statusCode == 200) {
      final res = List<Categories>.from(
          response.data.map((x) => Categories.fromJson(x)));
      print(res.map((e) => e.name));
      return res;
    } else {
      return null;
    }
    // } on DioException catch (e) {
    //   throw "${e.message}";
    // }
  }

  Future<DocumentModel?> getDocumentsByCategory(int id) async {
    print(role);
    // try {
    Response response = await dio.get(
        '$baseUrl/api/v1/document${role == 'is_lawyer' ? '-layer' : ''}/',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        queryParameters: {
          "category_id": id,
        });

    if (response.statusCode == 200) {
      print(DocumentModel.fromJson(response.data));
      return DocumentModel.fromJson(response.data);
    } else {
      return null;
    }
    // } on DioException catch (e) {
    //   throw "${e.message}";
    // }
  }

  Future<DocumentModel?> getMyDocuments() async {
    try {
      Response response = await dio.get(
        '$baseUrl/api/v1/document${role == 'is_lawyer' ? '-layer/is-lawyer/me/' : '/client/me/'}',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        queryParameters: {
          "page": "1",
          "size": "50",
        },
      );

      if (response.statusCode == 200) {
        emit(MyDocumentGeted(
            documents: DocumentModel.fromJson(response.data).items));
        return DocumentModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "$e";
    }
  }

  Future<DocumentModel?> getClientDocuments(int clientId) async {
    try {
      Response response = await dio.get(
        '$baseUrl/api/v1/document${role == 'is_lawyer' ? '-layer/is-lawyer/client/' : '/client/client/'}',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        queryParameters: {
          "client_id": clientId,
          "page": "1",
          "size": "50",
        },
      );

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "Bad getClientDocuments";
    }
  }

  Future<List<UserModel>?> getClients() async {
    try {
      Response response = await dio.get(
        '$baseUrl/api/v1/lawyer-clients/',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        return List<UserModel>.from(
            response.data.map((x) => UserModel.fromJson(x)));
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<UserModel?> addClient(UserModel client) async {
    final data = jsonEncode(client.toJson());
    // print(data);
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/lawyer-clients/',
        // options: Options(contentType: Headers.formUrlEncodedContentType),
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        print(response.data);
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "${e.message}";
    }
  }

  Future<UserModel?> updateClient(UserModel client) async {
    try {
      Response response = await dio.put(
        '$baseUrl/api/v1/lawyer-clients/${client.id}',
        // options: Options(contentType: Headers.formUrlEncodedContentType),
        data: client.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "Bad updateClient";
    }
  }

  Future<Item?> addDocument(
      int categoryId, String avaibility, File file, String title) async {
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/document-layer/',
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap({
          "category_id": categoryId,
          "title": title,
          "document_availability": avaibility,
          "document_file": await MultipartFile.fromFile(file.path),
        }),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return Item.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<DownloadedDocument?> downloadDocument(
      int documentId, int clientId, List<Map<String, dynamic>> items) async {
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/document-layer/client-download-document/$documentId/',
        data: {
          "client_id": clientId,
          "fields_value_document": items,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        return DownloadedDocument.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "Bad download doc";
    }
  }

  Future<bool?> deleteDocument(int documentId) async {
    try {
      Response response = await dio.delete(
        '$baseUrl/api/v1/document-layer/$documentId/',
      );

      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }
}
