//
//  ICloudManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation
import UIKit

struct ICloudManager {
    private init() {}
    
    enum SaveLoadType {
        case save
        case load
    }
    
    enum ICloudError: Error {
        case containerError
        case noInternet
        case noIcloudBackUp
        case somethingWentWrong
        
        static func errorHandling(error: ICloudError?, vc: UIViewController, type: SaveLoadType) {
            
            if error != nil {
                switch error! {
                case .containerError:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.noAccessToIcloud, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                case .noIcloudBackUp:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.youDoNotHaveABackupSaved, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                case .noInternet:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.noInternetConnection, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                case .somethingWentWrong:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.somethingWentWrong, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                }
            } else {
                switch type {
                case .save:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.success, text: LocalizedString.Alert.Text.backupUploadedSuccessfully, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                case .load:
                    AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.success, text: LocalizedString.Alert.Text.backupDownloadedSuccessfully, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
                }
                
                
            }
            
        }
    }
    
    enum ICloudFolder: String {
        case mainFolder = "SplitSpendingBackup"
        case testFolder = "Documents"
        enum ICLoudfileName: String {
            case history = "history"
        }
        static var allFileNames: [String] {
            return [ICloudFolder.ICLoudfileName.history.rawValue]
        }
    }
    private static func removeOldFile (path: String) {
        var isDir:ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("error remove file \(path) - \(error.localizedDescription)")
            }
            print("remove old file: \(path) - is OK")
        }
    }
    private static func getContainerUrl() throws -> URL {
        guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent(ICloudFolder.mainFolder.rawValue) else {
            throw ICloudError.containerError
        }
        return url
    }
    //private func checkICloud(comp)
    private static func urlFileToCopy(fileName: String, completion: @escaping (ICloudError?)->Void) -> URL? {
        var containerUrl: URL!
        do {
            containerUrl = try getContainerUrl()
        } catch {
            completion(ICloudError.containerError)
            return nil
        }
        return containerUrl.appendingPathComponent(fileName).appendingPathExtension("plist")
    }
    private static func createDirectoryInICloud(completion: @escaping (ICloudError?)->Void) {
        var containerUrl: URL!
        do {
            containerUrl = try getContainerUrl()
        } catch {
            completion(ICloudError.containerError)
            return
        }
        
        if !FileManager.default.fileExists(atPath: containerUrl.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: containerUrl, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                completion(ICloudError.noInternet)
            }
        }
    }
    
    static func copyFileToICloud(localPath: String, fileName: String, completion: @escaping (ICloudError?)->Void) {
        createDirectoryInICloud { errorCreateDirectoryInICloud in
            completion(errorCreateDirectoryInICloud)
            return
        }

        guard let urlFileName = urlFileToCopy(fileName: fileName, completion: { urlFileToCopyError in
            completion(urlFileToCopyError)
            return
        }) else {
            completion(ICloudError.containerError)
            return
        }
        if FileManager.default.fileExists(atPath: localPath) {
           removeOldFile(path: urlFileName.path)
        }
        
        do {
            try FileManager.default.copyItem(atPath: localPath, toPath: urlFileName.path)
        } catch {
            completion(ICloudError.somethingWentWrong)
            print(error.localizedDescription + " " + #function)
            return
        }
        completion(nil)
    }
    
    static func loadFromIcloud(localPath: String, fileName: String, completion: @escaping (ICloudError?)->Void) {
        print(#function)
        createDirectoryInICloud { errorCreateDirectoryInICloud in
            completion(errorCreateDirectoryInICloud)
            return
        }
        guard let urlFileName = urlFileToCopy(fileName: fileName, completion: { urlFileToCopyError in
            completion(urlFileToCopyError)
            return
        }) else {
            completion(ICloudError.containerError)
            return
        }
        
        do {
            try FileManager.default.startDownloadingUbiquitousItem(at: urlFileName)
        } catch {
            completion(ICloudError.noIcloudBackUp)
            return
        }
        
        if FileManager.default.fileExists(atPath: urlFileName.path) {
            removeOldFile(path: localPath)
        }
        
        do {
            try FileManager.default.copyItem(atPath: urlFileName.path, toPath: localPath)
        } catch {
            completion(ICloudError.somethingWentWrong)
            return
        }
        completion(nil)
    }
    
}



