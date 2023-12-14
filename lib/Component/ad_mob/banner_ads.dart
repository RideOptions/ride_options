// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// // for banner ads
// //test id
// // var AdUnitId = "ca-app-pub-3940256099942544/6300978111";
// //real id
//
// var AdUnitId = "ca-app-pub-2881496466882737/3695820003";
//
// late BannerAd banner;
//
// void createBannerAd() {
//
//   banner = BannerAd(
//     adUnitId: AdUnitId,
//     size: AdSize.banner,
//     request: AdRequest(),
//     listener: BannerAdListener(
//       // Called when an ad is successfully received.
//       onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
//       // Called when an ad request failed.
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         print('${ad.runtimeType} failed to load: $error');
//       },
//       // Called when an ad opens an overlay that covers the screen.
//       onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
//       // Called when an ad removes an overlay that covers the screen.
//       onAdClosed: (Ad ad) {
//         print('${ad.runtimeType} closed');
//         ad.dispose();
//         createBannerAd();
//         print('${ad.runtimeType} reloaded');
//       },
//     ),
//   )..load();
// }