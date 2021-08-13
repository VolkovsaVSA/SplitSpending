//
//  GlobalData.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 16/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

/*
func SetupActivityIndicator(titleView: String, textView: String, presentView: UIView) {

    let activityFrameHeight: CGFloat = 100
    let activityFrameWidth: CGFloat = 100
    let activityFrameCornerRadius: CGFloat = 12

    let activityIndicator = UIActivityIndicatorView(frame: CGRect(
        x: presentView.frame.width/2 - activityFrameWidth/2,
        y: presentView.frame.height/2 - activityFrameHeight/2,
        width: activityFrameWidth,
        height: activityFrameHeight))
    activityIndicator.backgroundColor = .clear
    activityIndicator.style = .whiteLarge
    GraphicsSetting.Dimension.cornerRadius(view: [activityIndicator], cornerRadius: activityFrameCornerRadius)
    
    let title = UILabel(frame: CGRect(
        x: activityFrameCornerRadius,
        y: 10,
        width: activityFrameWidth - activityFrameCornerRadius * 2,
        height: 20))
    title.text = titleView
    title.textAlignment = .center
    title.textColor = .white
    title.adjustsFontSizeToFitWidth = true
    title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    let text = UILabel(frame: CGRect(
        x: activityFrameCornerRadius,
        y: activityFrameWidth - activityFrameCornerRadius - 18,
        width: activityFrameWidth - activityFrameCornerRadius * 2,
        height: 20))
    text.text = textView
    text.textAlignment = .center
    text.textColor = .white
    text.adjustsFontSizeToFitWidth = true
    text.font = UIFont.systemFont(ofSize: 16, weight: .medium)

    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    blurView.alpha = 0.9
    blurView.backgroundColor = .clear
    blurView.frame = activityIndicator.bounds
    
    activityIndicator.insertSubview(blurView, at: 0)
    
    activityIndicator.addSubview(title)
    //activityIndicator.addSubview(text)
    activityIndicator.clipsToBounds = true
    
    activityIndicator.startAnimating()
    
    activityIndicator.tag = 100
    presentView.addSubview(activityIndicator)
    
}
 */

func RemoveActivityIndicator(presentView: UIView) {
    print("Start remove sibview")
    if let viewWithTag = presentView.viewWithTag(100) {
        viewWithTag.removeFromSuperview()
    } else {
        print("No!")
    }
}

func CorrectionKeyboardFrame(vc: UIViewController, totalPerson: Int) {
    
    switch vc.view.frame.height {
    //vc.view.frame.height = 568 - imphone 4'
    case 560...570:
        switch totalPerson {
        case 2: vc.setupKeyboardObservers(heightCorrection: 200)
        case 3: vc.setupKeyboardObservers(heightCorrection: 150)
        case 4: vc.setupKeyboardObservers(heightCorrection: 100)
        case 5: vc.setupKeyboardObservers(heightCorrection: 50)
        default: vc.setupKeyboardObservers(heightCorrection: 0)
        }
    //vc.view.frame.height = 667 - imphone 4,7'
    case 660...670:
        switch totalPerson {
        case 2...4: NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        case 5: vc.setupKeyboardObservers(heightCorrection: 150)
        case 6: vc.setupKeyboardObservers(heightCorrection: 100)
        case 7: vc.setupKeyboardObservers(heightCorrection: 50)
        default: vc.setupKeyboardObservers(heightCorrection: 0)
        }
    //vc.view.frame.height = 736 - imphone 5,5' Plus
    case 730...740:
        switch totalPerson {
        case 2...5: NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        case 6: vc.setupKeyboardObservers(heightCorrection: 190)
        case 7: vc.setupKeyboardObservers(heightCorrection: 150)
        case 8: vc.setupKeyboardObservers(heightCorrection: 100)
        case 9: vc.setupKeyboardObservers(heightCorrection: 50)
        default: vc.setupKeyboardObservers(heightCorrection: 0)
        }
    //vc.view.frame.height = 812 - imphone 5,8'
    case 810...820:
        switch totalPerson {
        case 2...5: NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        case 6: vc.setupKeyboardObservers(heightCorrection: 250)
        case 7: vc.setupKeyboardObservers(heightCorrection: 220)
        case 8: vc.setupKeyboardObservers(heightCorrection: 170)
        case 9: vc.setupKeyboardObservers(heightCorrection: 130)
        case 10: vc.setupKeyboardObservers(heightCorrection: 90)
        case 11: vc.setupKeyboardObservers(heightCorrection: 50)
        default: vc.setupKeyboardObservers(heightCorrection: 0)
        }
    //vc.view.frame.height = 896 - imphone 6.1, imphone 6.5'
    case 890...900:
        switch totalPerson {
        case 2...7: NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        case 8: vc.setupKeyboardObservers(heightCorrection: 260)
        case 9: vc.setupKeyboardObservers(heightCorrection: 210)
        case 10: vc.setupKeyboardObservers(heightCorrection: 170)
        case 11: vc.setupKeyboardObservers(heightCorrection: 130)
        case 12: vc.setupKeyboardObservers(heightCorrection: 80)
        case 13: vc.setupKeyboardObservers(heightCorrection: 40)
        default: vc.setupKeyboardObservers(heightCorrection: 0)
        }
    default: break//vc.setupKeyboardObservers(heightCorrection: 0)
    }
    
}
