//
//  HomeCell.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var nameOfPerson: UITextField!
    @IBOutlet weak var amountOfPerson: UITextField!
    @IBOutlet weak var contactBTN: UIButton!
    
    
    func configureCell(indexPath: IndexPath, totalCostDict: [Int: Debt]) {
        nameOfPerson.placeholder = LocalizedString.nameOfPerson + " " + "\(indexPath.row + 1)"
        
        if totalCostDict.count > 0 {
            nameOfPerson.text = totalCostDict[indexPath.row]?.name
            if let amount = totalCostDict[indexPath.row]?.amount {
                amountOfPerson.text = amount.description
            }
        } 
        
    }

}
