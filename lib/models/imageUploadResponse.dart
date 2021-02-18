import 'package:flutter/material.dart';

class ImageUploadResponse {
  ImageUploadResponse({
    this.path,
    this.timestamp,
    this.status,
    this.message,
    this.data,
  });

  String path;
  DateTime timestamp;
  int status;
  String message;
  ImageData data;

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      ImageUploadResponse(
        path: json["path"],
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: ImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "timestamp": timestamp.toIso8601String(),
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class ImageData {
  List<FileResponse> lstFiles;

  ImageData({
    this.lstFiles,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
      lstFiles: List<FileResponse>.from(
          json["files"].map((x) => FileResponse.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "files": List<dynamic>.from(lstFiles.map((x) => x.toJson())),
      };
}

class FileResponse {
  FileResponse({
    this.fileName,
    this.thumbnailUrl,
    this.fileUrl,
  });

  String fileName;
  String thumbnailUrl;
  String fileUrl;

  factory FileResponse.fromJson(Map<String, dynamic> json) => FileResponse(
        fileName: json["fileName"],
        thumbnailUrl: json["thumbnailUrl"],
        fileUrl: json["fileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "thumbnailUrl": thumbnailUrl,
        "fileUrl": fileUrl,
      };
}
