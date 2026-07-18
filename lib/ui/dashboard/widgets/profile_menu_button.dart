import 'package:alphalens_fend/blocs/delete_account/delete_account_cubit.dart';
import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:alphalens_fend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileMenuButton extends StatelessWidget {
  const ProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          Navigator.pushReplacementNamed(context, '/');

        } else if (state is DeleteAccountFailure) {
          showFeedback(context, state.message, Colors.redAccent);
        }
      },
      child: PopupMenuButton<String>(
        onSelected: (value) {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
        ),
        offset: const Offset(0, 50),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.person_outline_rounded,
            size: 22,
            color: theme.colorScheme.primary,
          ),
        ),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings_outlined, size: 18),
                SizedBox(width: 12),
                Text('Settings', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Delete Account',
            onTap: () {
              context.read<DeleteAccountCubit>().deleteAccount();
            },
            child: Row(
              children: [
                Icon(Icons.delete_rounded, size: 18, color: Colors.redAccent),
                SizedBox(width: 12),
                Text('Delete Account', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'logout',
            onTap: () async {
              try {
                await TokenStorage.deleteToken();
                Navigator.pushReplacementNamed(context, '/');
              } catch (e) {
                print("Error occurred while deleting token: $e");
                showFeedback(context, "Error occurred while logging out.", Colors.redAccent);
              }
            },
            child: Row(
              children: [
                Icon(Icons.logout_rounded, size: 18, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Text('Logout', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}