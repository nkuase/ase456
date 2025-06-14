import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class StatsWidget extends StatelessWidget {
  final UserModel userModel;

  const StatsWidget({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Posts', userModel.posts.toString()),
            _buildStatItem('Followers', userModel.followers.toString()),
            _buildStatItem('Following', userModel.following.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 