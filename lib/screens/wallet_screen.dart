import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// A simple model for this screen's asset list
class WalletAsset {
  final String name;
  final String symbol;
  final String iconUrl;
  final double cryptoAmount;
  final double usdValue;
  final double changePercent;

  const WalletAsset({
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.cryptoAmount,
    required this.usdValue,
    required this.changePercent,
  });
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  // --- Mock Data based on your design ---
  static const List<WalletAsset> _assets = [
    WalletAsset(
      name: 'Bitcoin',
      symbol: 'BTC',
      iconUrl: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      cryptoAmount: 0.05,
      usdValue: 1500.00,
      changePercent: 2.5,
    ),
    WalletAsset(
      name: 'Ethereum',
      symbol: 'ETH',
      iconUrl: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      cryptoAmount: 1.2,
      usdValue: 2850.70,
      changePercent: -1.2,
    ),
    WalletAsset(
      name: 'Solana',
      symbol: 'SOL',
      iconUrl: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
      cryptoAmount: 15,
      usdValue: 2100.30,
      changePercent: 5.8,
    ),
    WalletAsset(
      name: 'Tether',
      symbol: 'USDT',
      iconUrl: 'https://assets.coingecko.com/coins/images/325/large/Tether.png',
      cryptoAmount: 500,
      usdValue: 500.00,
      changePercent: 0.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () { /* TODO: QR Scan Logic */ },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 24),
          // --- Total Balance Section ---
          Center(
            child: Column(
              children: [
                Text(
                  'Total Balance',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$1,234.56', // This is mock data
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- Action Buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.arrow_upward_rounded,
                label: 'Send',
                onPressed: () {},
              ),
              _ActionButton(
                icon: Icons.arrow_downward_rounded,
                label: 'Receive',
                onPressed: () {},
              ),
              _ActionButton(
                icon: Icons.add_rounded,
                label: 'Add',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),

          // --- My Assets List ---
          Text(
            'My Assets',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _assets.length,
            itemBuilder: (context, index) {
              return _AssetTile(asset: _assets[index]);
            },
          ),
        ],
      ),
    );
  }
}

// --- Reusable Action Button ---
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(18),
          ),
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// --- Reusable Asset List Tile ---
class _AssetTile extends StatelessWidget {
  final WalletAsset asset;
  const _AssetTile({required this.asset});

  @override
  Widget build(BuildContext context) {
    final bool isUp = asset.changePercent >= 0;
    final Color changeColor = isUp ? Colors.greenAccent : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white12,
            child: CachedNetworkImage(
              imageUrl: asset.iconUrl,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${asset.cryptoAmount} ${asset.symbol}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${asset.usdValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isUp ? '+' : ''}${asset.changePercent.toStringAsFixed(2)}%',
                style: TextStyle(color: changeColor, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}