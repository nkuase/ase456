import 'dart:convert';
import 'package:flutter/services.dart';

class UserModel {
  static const String defaultProfilePicture = 'https://picsum.photos/200/200';
  
  final String name;
  final String email;
  final String address;
  final String? profilePicture;
  final int posts;
  final int followers;
  final int following;

  UserModel({
    required this.name,
    required this.email,
    required this.address,
    this.profilePicture,
    this.posts = 0,
    this.followers = 0,
    this.following = 0,
  });

  String get displayProfilePicture => profilePicture ?? defaultProfilePicture;

  UserModel copyWith({
    String? name,
    String? email,
    String? address,
    String? profilePicture,
    int? posts,
    int? followers,
    int? following,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
} 