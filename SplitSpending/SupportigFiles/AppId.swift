//
//  AppId.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 21/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct AppId {
    private init() {}
    private static let appID = "1476506565"
    static let appHttp = "http://itunes.apple.com/app/id" + AppId.appID
    static let appUrl = URL(string: "itms-apps://itunes.apple.com/app/id" + AppId.appID)
    static let feedbackEmail = "divider@vsa.su"
}
