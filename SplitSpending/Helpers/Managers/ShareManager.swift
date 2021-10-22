//
//  ShareManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 19/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class ShareManager: NSObject {
    static let share = ShareManager()
    
//    var activityViewController: UIActivityViewController?
    
    func share(object: [String], showInController: UIViewController) {
        let ac = UIActivityViewController(activityItems: object, applicationActivities: nil)
        showInController.present(ac, animated: true)
    }
}
