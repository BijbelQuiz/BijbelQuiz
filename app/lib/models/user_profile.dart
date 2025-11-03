import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Represents a user profile with a unique ID, name, and avatar.
class UserProfile {
  /// A unique identifier for the user profile.
  final String id;

  /// The name of the user.
  String name;

  /// A string representing the user's chosen avatar.
  String avatar;

  /// Creates a new user profile.
  ///
  /// If an [id] is not provided, a new unique ID will be generated.
  UserProfile({String? id, required this.name, this.avatar = 'default'})
      : id = id ?? const Uuid().v4();

  /// Creates a user profile from a JSON object.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'] ?? 'default',
    );
  }

  /// Converts the user profile to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }

  /// Encodes the user profile to a JSON string.
  String toJsonString() => json.encode(toJson());

  /// Decodes a user profile from a JSON string.
  factory UserProfile.fromJsonString(String jsonString) =>
      UserProfile.fromJson(json.decode(jsonString));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserProfile{id: $id, name: $name, avatar: $avatar}';
  }
}
