//
//  History.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 11.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class History: UITableViewController {
    var selectedIndex: Int!
    
    private var tempView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private var sortedHistoryArr: [HistoryModel]!
    private let searchController = UISearchController(searchResultsController: nil)
    private var filterHistoryMass = [HistoryModel]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    
    @IBAction func backBTNAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func checkFullVersion() {
        
//        if tempView.tag == 100 {
//            tempView.removeFromSuperview()
//        }
//
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = LocalizedString.SearchBar.Placeholder.searchByName
//
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
        
        
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {

            if tempView.tag == 100 {
                tempView.removeFromSuperview()
            }

            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = LocalizedString.SearchBar.Placeholder.searchByName

            navigationItem.searchController = searchController

            definesPresentationContext = true

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            HistoryArr = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            setupTempView()
        }
        
        
    }
    private func setupTempView() {
        tempView.backgroundColor = .clear
        
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        tempLabel.lineBreakMode = .byWordWrapping
        tempLabel.numberOfLines = 0
        tempLabel.text = LocalizedString.Labels.historyIsAvailableOnlyInTheFullVersion
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 22, weight: .thin)
        
        tempView.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.centerXAnchor.constraint(equalTo: tempView.centerXAnchor).isActive = true
        tempLabel.centerYAnchor.constraint(equalTo: tempView.centerYAnchor).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        tempView.tag = 100
        self.navigationController?.view.addSubview(tempView)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.topAnchor.constraint(equalTo: self.navigationController!.view.topAnchor, constant: 50).isActive = true
        tempView.bottomAnchor.constraint(equalTo: self.navigationController!.view.bottomAnchor).isActive = true
        tempView.leadingAnchor.constraint(equalTo: self.navigationController!.view.leadingAnchor).isActive = true
        tempView.trailingAnchor.constraint(equalTo: self.navigationController!.view.trailingAnchor).isActive = true
    }
    private func prepareTableview() {
        self.navigationController?.navigationBar.tintColor = .white
        self.tableView.backgroundView = GraphicsSetting.BackgroundColor.setBackgroundView(imageName: "backgroundImage100_flipVertical_black-2")
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableview()
        checkFullVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkFullVersion()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterHistoryMass.count
        } else {
            return HistoryArr.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        var history: HistoryModel!
        
        if isFiltering {
            history = filterHistoryMass[indexPath.row]
        } else {
            history = HistoryArr[indexPath.row]
        }
        
        cell.textLabel?.text =
            LocalizedString.ShareMessage.totalExpenses + ": " +
            Currency.currencyFormatter(currency: Decimal(Double(history.totalExpenses)),
                                       currencyCode: history.currency,
                                       showCode: CurrencyViewModel.shared.showCurrencyCode) + "\n" +
            LocalizedString.ShareMessage.numberOfPersons + ": " +
            history.numberOfPerson.description
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.text = MyDateFormatter.formatter(dateStyle: .full, timeStyle: .medium).string(from: history.date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleterowAction = UITableViewRowAction(style: .destructive, title: LocalizedString.Alert.Button.delete) { [weak self] (_,_) in
            
            guard let self = self else {return}
            AlertManager.twoButtonAlert(title: LocalizedString.Alert.Title.attention,
                                        text: LocalizedString.Alert.Text.doYouReallyWantToDeleteThisEntry,
                                        buttonActionText: LocalizedString.Alert.Button.delete,
                                        buttonActionStyle: .destructive, presentVC: self) { _ in
                
                HistoryArr.remove(at: indexPath.row)
                SaveLoadManager.saveHistory()
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                }
            } cancelActionHandler: {_ in}
            
        }
        return [deleterowAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "HistoryDetailSegue", sender: indexPath.row)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let vc = segue.destination as! DetailedHistory
            
            if isFiltering {
                vc.history = filterHistoryMass[indexPath.row]
            } else {
                vc.history = HistoryArr[indexPath.row]
            }
            
        }
    }


}

// MARK: - UISearchResultsUpdating
extension History: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filetrContentforSearchText(searchText: searchController.searchBar.text!)
    }
    
    private func filetrContentforSearchText(searchText: String) {
        
        filterHistoryMass = HistoryArr.filter({ $0.totalCost.contains { debt -> Bool in
            debt.name.contains(searchText)
            } })
        tableView.reloadData()
    }
}

