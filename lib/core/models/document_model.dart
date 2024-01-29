import 'dart:convert';

class DocumentModel {
  final List<Item> items;
  final int total;
  final int page;
  final int size;
  final int pages;

  DocumentModel({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory DocumentModel.fromRawJson(String str) =>
      DocumentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        total: json["total"],
        page: json["page"],
        size: json["size"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total": total,
        "page": page,
        "size": size,
        "pages": pages,
      };
}

class Item {
  final int id;
  final int categoryId;
  final String title;
  final String documentAvailability;
  final String pathDocument;
  final String? pdfFileLocation;
  final String? pngFileLocation;
  final int userUploadedId;
  final List<Field> fields;
  final DateTime dateCreated;
  final String? titleCategory;
  final String? iconCategory;

  Item({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.documentAvailability,
    required this.pathDocument,
    required this.pdfFileLocation,
    required this.pngFileLocation,
    required this.userUploadedId,
    required this.fields,
    required this.dateCreated,
    required this.titleCategory,
    required this.iconCategory,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        documentAvailability: json["document_availability"],
        pathDocument: json["path_document"],
        pdfFileLocation: json["pdf_file_location"],
        pngFileLocation: json["png_file_location"],
        userUploadedId: json["user_uploaded_id"],
        fields: json["fields"] != null
            ? List<Field>.from(json["fields"].map((x) => Field.fromJson(x)))
            : [],
        dateCreated: DateTime.parse(json["date_created"]),
        titleCategory: json["title_category"],
        iconCategory: json["icon_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "document_availability":
            documentAvailabilityValues.reverse[documentAvailability],
        "path_document": pathDocument,
        "pdf_file_location": pdfFileLocation,
        "png_file_location": pngFileLocation,
        "user_uploaded_id": userUploadedId,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
        "date_created": dateCreated.toIso8601String(),
        "title_category": titleCategoryValues.reverse[titleCategory],
        "icon_category": iconCategoryValues.reverse[iconCategory],
      };
}

enum DocumentAvailability { EMPTY }

final documentAvailabilityValues =
    EnumValues({"Общедоступный": DocumentAvailability.EMPTY});

class Field {
  final int id;
  final String label;
  final TypeFieldInput typeFieldInput;
  final bool required;

  Field({
    required this.id,
    required this.label,
    required this.typeFieldInput,
    required this.required,
  });

  factory Field.fromRawJson(String str) => Field.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json["id"],
        label: json["label"],
        typeFieldInput: typeFieldInputValues.map[json["type_field_input"]]!,
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type_field_input": typeFieldInputValues.reverse[typeFieldInput],
        "required": required,
      };
}

enum TypeFieldInput { TEXT_FIELD }

final typeFieldInputValues =
    EnumValues({"TEXT_FIELD": TypeFieldInput.TEXT_FIELD});

enum IconCategory {
  STATIC_CATEGORIES_0_B0_A6_DC3_141_C_45_C7_BC6_C_F72_E25_ACE860_SVG
}

final iconCategoryValues = EnumValues({
  "/static/categories/0b0a6dc3-141c-45c7-bc6c-f72e25ace860.svg": IconCategory
      .STATIC_CATEGORIES_0_B0_A6_DC3_141_C_45_C7_BC6_C_F72_E25_ACE860_SVG
});

enum TitleCategory { EMPTY }

final titleCategoryValues = EnumValues({"Суды": TitleCategory.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
