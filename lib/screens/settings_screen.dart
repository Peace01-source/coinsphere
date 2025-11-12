import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _biometricLock = true;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController, setting the default tab to "Security" (index 1)
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // --- Profile Card ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Uses the card color from your theme
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 32, color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Mercer', // Mock data
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '0x12aC...fEaB56', // Mock data
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // TODO: Copy to clipboard logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Address Copied!')),
                              );
                            },
                            child: const Icon(Icons.copy, size: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Tab Bar ("General" / "Security") ---
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.black, // Text color for selected tab
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'General'),
                Tab(text: 'Security'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- Tab Content ---
          SizedBox(
            height: 450, // Give the tab content a fixed height to avoid layout errors
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralSettings(), // Placeholder for "General"
                _buildSecuritySettings(context), // "Security" options
              ],
            ),
          ),

          const SizedBox(height: 24),
          // --- Log Out Button ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FilledButton(
              onPressed: () { /* TODO: Logout Logic */ },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary, // Pink/Magenta color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the "Security" tab's content
  Widget _buildSecuritySettings(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Biometric Lock', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          secondary: Icon(Icons.fingerprint, color: accentColor),
          value: _biometricLock,
          onChanged: (value) {
            setState(() {
              _biometricLock = value;
            });
          },
          activeColor: accentColor,
          tileColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.shield_outlined,
          title: 'Two-Factor Authentication',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.password_rounded,
          title: 'Change Passcode',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.hub_outlined,
          title: 'Connected Dapps',
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: Colors.white12),
        ),
        _SettingsTile(
          icon: Icons.help_outline_rounded,
          title: 'Help Center',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          onTap: () {},
        ),
      ],
    );
  }
  
  // Placeholder for the "General" tab
  Widget _buildGeneralSettings() {
    return const Center(
      child: Text(
        'General Settings Here',
        style: TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
}

// --- Reusable Settings List Tile ---
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white54),
        onTap: onTap,
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}