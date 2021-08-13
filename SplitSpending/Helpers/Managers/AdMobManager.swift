//
//  AdMobManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 25/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AppTrackingTransparency

class AdMobManager: NSObject {
    
    static let shared = AdMobManager()
    
    let admobAppId = "ca-app-pub-8399858472733455~9707167159"
    let admobBannerId = "ca-app-pub-8399858472733455/5423117843"
    let admobFullscreenBannerId = "ca-app-pub-8399858472733455/6446792969"
    
    var interstitial: GADInterstitialAd?

    func createBanner(heightBanner: CGFloat, presentVC: UIViewController) {
        var bannerView: GADBannerView?
        
        print(presentVC.view.frame.width)
        
        bannerView = GADBannerView(frame: CGRect(x: 0,
                                                 y: presentVC.view.frame.size.height - heightBanner,
                                                 width: presentVC.view.frame.width, height: heightBanner)
                                   )
        guard let banner = bannerView else {return}
        banner.adUnitID = AdMobManager.shared.admobBannerId
        banner.rootViewController = presentVC
        banner.delegate = presentVC as? GADBannerViewDelegate

        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            print("STATUS \(status.rawValue)")
            banner.load(GADRequest())
        })

        banner.tag = 200
        presentVC.view.addSubview(banner)
    }
    
    func removeBanner(presentView: UIView) {
        if let viewWithTag = presentView.viewWithTag(200) {
            viewWithTag.removeFromSuperview()
        }
    }

    func requestInterstitialAds(rootVC: GADFullScreenContentDelegate) {
        let request = GADRequest()
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            GADInterstitialAd.load(withAdUnitID: AdMobManager.shared.admobFullscreenBannerId, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = rootVC
            })
        })
 
    }
    
    func showInterstitialAds(inRootViewController view: UIViewController) {
        if let fullScreenAds = interstitial {
            fullScreenAds.present(fromRootViewController: view)
        } else {
            print("not ready")
        }
    }
    
    
}



