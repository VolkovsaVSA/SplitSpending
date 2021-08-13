//
//  MyDateFormatter.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 14.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct MyDateFormatter {
    private init(){}
    static func formatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style)->DateFormatter {
        let dateFormatterFull = DateFormatter()
        dateFormatterFull.dateStyle = dateStyle
        dateFormatterFull.timeStyle = timeStyle
        return dateFormatterFull
    }
}
