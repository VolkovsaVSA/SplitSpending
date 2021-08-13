//
//  File.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct LocalizedString {
    private init() {}
    struct Alert {
        private init() {}
        struct Title {
            private init() {}
            static let error = NSLocalizedString("Error", comment: " ")
            static let purchase = NSLocalizedString("Purchase", comment: " ")
            static let attention = NSLocalizedString("Attention", comment: " ")
            static let success = NSLocalizedString("Success", comment: " ")
            static let history = NSLocalizedString("History", comment: " ")
        }
        struct Text {
            private init() {}
            static let enterTheNumberOfPerson = NSLocalizedString("Enter the number of person", comment: " ")
            static let mailServicesAreNotAvailable = NSLocalizedString("Mail services are not available", comment: " ")
            static let fillInAllTheFelds = NSLocalizedString("Fill in all the fields!", comment: " ")
            static let fullStringByFullVersion = NSLocalizedString("When you purchase the full version of the application, all the application functions will be available to you, and the ads banner will not be displayed.", comment: " ")
            static let buyTheFullVersionFor = NSLocalizedString("Buy the full version for", comment: " ")
            static let transactionError = NSLocalizedString("Transaction error", comment: " ")
            static let somethingWentWrong = NSLocalizedString("Something went wrong. Please try again later.", comment: " ")
            static let purchaseConfirmed = NSLocalizedString("Purchase confirmed.", comment: " ")
            static let purchaserestored = NSLocalizedString("Purchase restored.", comment: " ")
            static let toUseThisFeaturePurchaseTheFullVersionOfTheProgramFor = NSLocalizedString("To use this feature, purchase the full version of the program for", comment: " ")
            static let noInternetConnectionToBuyTheFullVersionOfTheApplication = NSLocalizedString("No internet connection to buy the full version of the application.", comment: " ")
            static let theBackupWasSuccessful = NSLocalizedString("The backup was successful.", comment: " ")
            static let backupAutomaticalyAttention = NSLocalizedString("Enable this option if you want to automatically save any changes to history. If you want to independently manage the creation of a backup, do not enable this option. Use the save and load backup buttons.", comment: " ")
            static let backupDownloadedSuccessfully = NSLocalizedString("Backup downloaded successfully.", comment: " ")
            static let backupUploadedSuccessfully = NSLocalizedString("Backup uploaded successfully.", comment: " ")
            static let doYouReallyWantToDeleteThisEntry = NSLocalizedString("Do you really want to delete this entry?", comment: " ")
            static let noAccessToIcloud = NSLocalizedString("No access to iCloud. Log in to the iCloud on your device and check your internet connection.", comment: " ")
            static let noInternetConnection = NSLocalizedString("No internet connection.", comment: " ")
            static let youDoNotHaveABackupSaved = NSLocalizedString("You do not have a backup saved.", comment: " ")
            static let doYouWantSaveThisCalculation = NSLocalizedString("Do you want to save this calculation into history?", comment: " ")
        }
        struct Placeholder {
            private init() {}
            static let numberOfPerson = NSLocalizedString("Number of person", comment: " ")
        }
        struct Button {
            private init() {}
            static let ok = NSLocalizedString("OK", comment: " ")
            static let cancel = NSLocalizedString("Cancel", comment: " ")
            static let buy = NSLocalizedString("Buy", comment: " ")
            static let delete = NSLocalizedString("Delete", comment: " ")
            static let save = NSLocalizedString("Save", comment: " ")
        }
    }
    struct Email {
        private init() {}
        struct Subject {
            private init() {}
            static let feedbackOnApplication = NSLocalizedString("Feedback on application 'Divider'", comment: " ")
        }
        struct MessageBody {
            private init() {}
            static let sentFromTheSplitSpendingApp = NSLocalizedString("Sent from the 'Divider' app", comment: " ")
        }
        
    }
    struct ActivityIndicator {
        private init() {}
        struct Title {
            private init() {}
            static let loading = NSLocalizedString("Loading", comment: " ")
            static let calculate = NSLocalizedString("Calculate", comment: " ")
        }
        struct Text {
            private init() {}
            static let pleaseWait = NSLocalizedString("please wait", comment: " ")
            static let inProgress = NSLocalizedString("in progress", comment: " ")
        }
    }
    struct ShareMessage {
        private init() {}
        static let totalExpenses = NSLocalizedString("Total expenses", comment: " ")
        static let numberOfPersons = NSLocalizedString("Number of persons", comment: " ")
        static let expensesPerPerson = NSLocalizedString("Expenses per person", comment: " ")
        static let payouts = NSLocalizedString("Payouts", comment: " ")
    }
    struct TVCSectionHeader {
        private init() {}
        static let total = NSLocalizedString("Total", comment: " ")
        static let expenses = NSLocalizedString("Expenses", comment: " ")
        static let payments = NSLocalizedString("Payments", comment: " ")
    }
    struct SearchBar {
        private init() {}
        struct Placeholder {
            private init() {}
            static let searchByName = NSLocalizedString("Search by name", comment: " ")
        }
    }
    struct Labels {
        private init() {}
        static let historyIsAvailableOnlyInTheFullVersion = NSLocalizedString("History is available only in the full version.", comment: " ")
        
    }
    
    static let nameOfPerson = NSLocalizedString("Person", comment: " ")
    static let date = NSLocalizedString("Date", comment: " ")
}
