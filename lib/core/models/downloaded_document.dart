import 'dart:convert';

class DownloadedDocument {
  final int documentId;
  final int userId;
  final int? clientId;
  final String pathDocumentDownloaded;
  final String pathDocumentDownloadedPdf;
  final String pathDocumentDownloadedPng;
  final int id;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  DownloadedDocument({
    required this.documentId,
    required this.userId,
    required this.clientId,
    required this.pathDocumentDownloaded,
    required this.pathDocumentDownloadedPdf,
    required this.pathDocumentDownloadedPng,
    required this.id,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory DownloadedDocument.fromRawJson(String str) =>
      DownloadedDocument.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DownloadedDocument.fromJson(Map<String, dynamic> json) =>
      DownloadedDocument(
        documentId: json["document_id"],
        userId: json["user_id"],
        clientId: json["client_id"],
        pathDocumentDownloaded: json["path_document_downloaded"],
        pathDocumentDownloadedPdf: json["path_document_downloaded_pdf"],
        pathDocumentDownloadedPng: json["path_document_downloaded_png"],
        id: json["id"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "document_id": documentId,
        "user_id": userId,
        "client_id": clientId,
        "path_document_downloaded": pathDocumentDownloaded,
        "path_document_downloaded_pdf": pathDocumentDownloadedPdf,
        "path_document_downloaded_png": pathDocumentDownloadedPng,
        "id": id,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
      };
}
