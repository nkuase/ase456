import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class InfoWidget extends StatelessWidget {
  final UserModel userModel;

  const InfoWidget({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          userModel.name,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          userModel.email,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        Text(
          userModel.address,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
} 