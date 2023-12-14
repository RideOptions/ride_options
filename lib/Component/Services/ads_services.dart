import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsServices{

  // for banner ads
  //test id
   var adUnit = "ca-app-pub-3940256099942544/6300978111";
  //  live ad id
  // var adUnit = "ca-app-pub-2881496466882737/3695820003";

  late BannerAd bannerad;
  late RewardedAd rewardedAd;
  bool isAdLoaded = false;

  initBannerAd(){
    print('object');
    bannerad = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(
            onAdLoaded: (ad){

                isAdLoaded = true;

            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
              print(error);
            }
        ),

        request: AdRequest(

        )
    );
    bannerad.load();
  }

  // for rewarded ads

  //for live ad
  // final String rewardedAdUnitId = "ca-app-pub-2881496466882737/9671100835";
  //for test ad
  final String rewardedAdUnitId = "ca-app-pub-3940256099942544/5224354917";

  void _loadReewardedAd(){
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(

          onAdFailedToLoad: (LoadAdError error){
            print('Failed to load rewarded ad, Error: $error');
          },
          onAdLoaded: (RewardedAd ad){
            print("$ad loaded");
            rewardedAd = ad;
            _setFullScreenContentCallback();
            _showRewardedAd();
          },

        )
    );
  }

  void _setFullScreenContentCallback(){
    if(rewardedAd == null) return;
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print("$ad onAdShowedFullScreenContent"),

      onAdDismissedFullScreenContent: (RewardedAd ad){
        print("$ad onAdDismissedFullScreenContent");
        ad.dispose();
      },

      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error){
        print("$ad onAdFailedtoShowFullscreencontent: $error");
        ad.dispose();
      },

      onAdImpression: (RewardedAd ad) => print("$ad Impression Occured"),
    );
  }

  void _showRewardedAd(){

    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem){
          num amount = rewardItem.amount;
          print("you earned: $amount");
        }
    );
  }
}