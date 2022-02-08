//
//  ViewController.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 07/10/21.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    var Countries: [countries] = Bundle.main.decode(from: "countries")
    var filteredCountries = [countries]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country-Facts!"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 80
        
        configureSearchController()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))

//        if let data = loadJSON(filename: "countries") {
//            Countries = data
//        } else {
//            print("failed to load countries data")
//        }
        
        //print(Countries)
        
    }
    
//    func loadJSON(filename fileName: String) -> [countries]? {
//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(Country.self, from: data)
//                return jsonData.results
//            } catch {
//                print("error: \(error)")
//            }
//        }
//        return nil
//    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification request has been granted! Thank you!")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
        
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Did you know...!?"
        content.body = "\((Countries.randomElement()?.name)!) has a population of \((Countries.randomElement()?.population)!)"
        content.sound = .default
        content.categoryIdentifier = "alarm"
        
        var dateComponents = DateComponents()
        
        //askTime
        let ac = UIAlertController(title: "Get Facts Daily!", message: "At what time do you want to get facts?", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Hour (24-Hour Format)"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Minutes"
        }

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac] _ in
            
            guard let hour = Int((ac?.textFields?[0].text)!) else {
                print("Could not get the hour")
                return
            }
            
            guard let minute = Int((ac?.textFields?[1].text)!) else {
                print("Could not get the minute")
                return
            }
            
            dateComponents.hour = hour
            dateComponents.minute = minute
            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    //To show notifications even when the app is in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    func configureSearchController() {
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search countries,capitals..."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = Countries.filter { (country: countries) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased()) || country.capital.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            
            (filteredCountries.count == 0) ?
                tableView.setEmptyMessage("No Results") : tableView.restoreInitialStage()
            
            return filteredCountries.count
        }
        
        return Countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country",for: indexPath) as! countryCell
        let country: countries
        
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = Countries[indexPath.row]
        }
        
        let flagFileName = getFlagFileName(code: country.alpha2Code)
        
        //cell.textLabel?.text = country.name
        cell.nameLabel.text = country.name
        cell.captionLabel.text = country.capital
        cell.flagImageView.image = UIImage(named: flagFileName)
        cell.flagImageView.layer.cornerRadius = 8
        cell.flagImageView.layer.borderColor = UIColor.gray.cgColor
        cell.flagImageView.layer.borderWidth = 0.5
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func getFlagFileName(code: String) -> String {
        return "flag_hd_" + code + ".png"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        let country: countries
        
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = Countries[indexPath.row]
        }
        
        vc.detailItem = country
        
        //-Including navController to get bar buttons in VC
        let navController = UINavigationController(rootViewController: vc)
        
        //navigationController?.pushViewController(vc, animated: true)
        
        //-present for ModalPresentationStyle
        navigationController?.present(navController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ALL COUNTRIES & CAPITALS"
    }
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 26)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restoreInitialStage() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension Bundle {
    func decode<T: Decodable>(from resourceString: String) -> T {
        guard let url = Bundle.main.url(forResource: resourceString, withExtension: "json") else {
            fatalError("Unable to decode URL from \(resourceString)")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(resourceString)")
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode data from \(resourceString)")
        }
        return decoded
    }
}
