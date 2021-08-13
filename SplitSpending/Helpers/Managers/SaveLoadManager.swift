//
//  SaveLoadManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 12.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation
import UIKit

struct SaveLoadManager {
    private init() {}
    
    struct PathForSave {
        private init() {}
        private static let pathForSaveLibrary = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        static let history = pathForSaveLibrary + "/history.plist"
    }

    static func saveHistory() {
        print(#function)
        var arrayHistoryModel = NSArray()
        for itemDHistoryModel in HistoryArr {
            arrayHistoryModel = arrayHistoryModel.adding(itemDHistoryModel.dictionary) as NSArray
        }
        arrayHistoryModel.write(toFile: PathForSave.history, atomically: true)
        
        if UserDefaults.standard.bool(forKey: UDKeys.backupToIcloudAutomaticaly.rawValue) {
            guard UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) else {return}
            ICloudManager.copyFileToICloud(localPath: PathForSave.history, fileName: ICloudManager.ICloudFolder.ICLoudfileName.history.rawValue) { _ in
            }
        }
    }
    
    static func loadHistory() {
//        print(#function)
//        print("PathForSave.history: \(PathForSave.history)")
        if let loadArray = NSArray(contentsOfFile: PathForSave.history) {
            HistoryArr = []
            var tempData : HistoryModel!
            for itemArray in loadArray {
                tempData = HistoryModel(dictionary: itemArray as! NSDictionary)
                HistoryArr.append(tempData)
            }
            HistoryArr = HistoryArr.sorted (by: { $0.date > $1.date })
        } else {
            HistoryArr = []
        }
    }
    
}
