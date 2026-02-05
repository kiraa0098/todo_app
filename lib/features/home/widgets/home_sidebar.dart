import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/common/helper/secure_storage_helper.dart';

import '../screens/home_page.dart';

class HomeSidebar extends StatelessWidget {
  final void Function(HomeSection section)? onSectionSelected;
  final HomeSection? selected;

  const HomeSidebar({super.key, this.onSectionSelected, this.selected});

  Future<void> _logout(BuildContext context) async {
    await SecureStorageHelper.deleteToken();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget navItem({
      required String title,
      required String asset,
      required HomeSection section,
    }) {
      final isSelected = selected == section;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Material(
          color: isSelected ? cs.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onSectionSelected != null
                ? () => onSectionSelected!(section)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    asset,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      isSelected ? cs.primary : cs.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? cs.onPrimaryContainer
                            : cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: SafeArea(
        child: FutureBuilder<Map<String, String?>>(
          future: SecureStorageHelper.getUserInfo(),
          builder: (context, snapshot) {
            final userInfo = snapshot.data;
            final userName = (userInfo == null)
                ? ''
                : [
                    userInfo['firstName'],
                    userInfo['lastName'],
                  ].where((e) => e != null && e.trim().isNotEmpty).join(' ');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(Icons.person, color: cs.onPrimaryContainer),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            snapshot.connectionState == ConnectionState.waiting
                                ? Container(
                                    width: 80,
                                    height: 16,
                                    color: cs.surfaceVariant,
                                  )
                                : Text(
                                    userName.isNotEmpty ? userName : 'User',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                navItem(
                  title: 'Notes',
                  asset: 'assets/svg/icon/note.svg',
                  section: HomeSection.notes,
                ),
                navItem(
                  title: 'Todos',
                  asset: 'assets/svg/icon/task-checklist.svg',
                  section: HomeSection.todos,
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Divider(color: cs.outlineVariant),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(Icons.logout, color: cs.error),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                        color: cs.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
