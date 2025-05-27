// import 'package:flutter/material.dart';
// import 'package:notiq/data/providers/network_provider.dart';
// import 'package:provider/provider.dart';

// class OfflineScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final networkProvider = context.watch<NetworkProvider>();

//     if (networkProvider.isConnected) {
//       // If reconnected, go back automatically
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (Navigator.canPop(context)) {
//           Navigator.pop(context);
//         }
//       });
//     }
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/images/no-wifi.png', height: 200),
//                 const SizedBox(height: 24),
//                 Text(
//                   'No Internet Connection',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Please check your network settings and try again.',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: Colors.black54,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed:
//                       () => context.read<NetworkProvider>().checkConnection(),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Try Again'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
