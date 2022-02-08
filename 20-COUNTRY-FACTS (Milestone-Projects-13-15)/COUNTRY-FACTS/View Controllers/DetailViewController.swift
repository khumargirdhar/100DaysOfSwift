//
//  DetailViewController.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 07/10/21.
//

import UIKit
import SafariServices   //To implement the webView

class DetailViewController: UITableViewController {
    var detailItem: countries!
    
    // -For number formatting of Population
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    enum Section: String {
        case flag = "Flag"
        case general = "General"
        case timezones = "Time Zones"
        case languages = "Languages"
        case langCodes = "Language Codes"
        case currencies = "Currencies"
    }
    
    let sectionTitles: [Section] = [.flag, .general, .timezones, .languages, .langCodes, .currencies]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = detailItem.name
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let read = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(readTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        navigationItem.rightBarButtonItems = [share, read]
        
    }
    
    @objc func doneTapped() {
        dismiss(animated: true)
    }
    
    @objc func readTapped() {
        //Wikipedia
        let wikiURL: String = "https://en.wikipedia.org/wiki/\(detailItem.name.replacingOccurrences(of: " ", with: "_"))"
        guard let url = URL(string: wikiURL) else {
            print("Could not get the Wikipedia URL")
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .automatic
        present(safariVC, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTitles[section] {
        case .flag:                         return 1
        case .general:                      return 5
        case .timezones:                    return detailItem.timezones.count
        case .languages, .langCodes:        return detailItem.languages.count
        case .currencies:                   return detailItem.currencies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section].rawValue.uppercased()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "country")
        tableView.register(FlagCell.self, forCellReuseIdentifier: "FlagCell")
        
        //tableView.register(UITableView.self, forCellReuseIdentifier: "FlagCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "country",for: indexPath)
//
//        switch indexPath.row {
//        case 0: cell.textLabel?.text = (detailItem.capital == "") ?  "Capital - N/A" : "Capital - \(detailItem!.capital)"
//        case 1: cell.textLabel?.text = "Population - \(detailItem!.population)"
//        //case 2: cell.textLabel?.text = "
//        default: cell.textLabel?.text = nil
//        }
//
//        cell.textLabel?.numberOfLines = 0
//
//        return cell
        
        func getFlagFileName(code: String) -> String {
            return "flag_hd_" + code + ".png"
        }
        
        switch sectionTitles[indexPath.section] {
        case .flag:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
            if let cell = cell as? FlagCell { cell.configure(for: detailItem) }
            return cell
        case .general:
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            switch(indexPath.row) {
            case 0: cell.textLabel?.text = configureName()
            case 1: cell.textLabel?.text = configureRegion()
            case 2: cell.textLabel?.text = configureCapital()
            case 3: cell.textLabel?.text = configurePopulation()
            case 4: cell.textLabel?.text = configureDemonym()
            case 5: cell.textLabel?.text = configureArea()
            default: return cell
            }
            return cell
        case .timezones:
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = configureTimezone(detailItem.timezones[indexPath.row])
            return cell
        case .languages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = configureLanguage(detailItem.languages[indexPath.row])
            return cell
        case .langCodes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = configureLangCode(detailItem.languages[indexPath.row])
            return cell
        case .currencies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = configureCurrency(detailItem.currencies[indexPath.row])
            return cell
        }
    }

    @objc func shareTapped() {
        var shareName: String?
        var shareCapital: String?
        var sharePopulation: String?
        
        if let name = detailItem?.name {
            shareName = "\(name) is a very beautiful country!"
        }
        if let capital = detailItem?.capital {
            shareCapital = "It's capital is \(capital)."
        }
        if let population = detailItem?.population {
            sharePopulation = "It has a population of \(population)."
        }
//
//        let shareArray = [shareName,shareCapital,sharePopulation]
//
        
        let ac = UIActivityViewController(activityItems: [shareName, shareCapital, sharePopulation] as [Any] , applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
        present(ac, animated: true)
        
    }
    
    
    //CONFIGURING ALL JSON INFORMATION
    func configureName() -> String {
        if detailItem.name == detailItem.nativeName { return "Name: \(detailItem.name)"}
        return "Name: \(detailItem.name) · \(detailItem.nativeName)"
    }
    
    func configureCapital() -> String {
        if detailItem.capital == "" { return "Capital: N/A" }
        return "Capital: \(detailItem.capital)"
    }
    
    func configureRegion() -> String {
        if detailItem.region == .empty { return "Region: N/A" }
        return "Region: \(detailItem.region.rawValue)"
        }
    
    func configureDemonym() -> String {
        if detailItem.demonym == "" { return "Demonym: N/A" }
        return "Demonym: \(detailItem.demonym)"
    }
    
    func configurePopulation() -> String {
        if let population = numberFormatter.string(for: detailItem.population) {
            return "Population: \(population)"
        }
        return "Population: N/A"
    }
    
    func configureArea() -> String {
        if let area = numberFormatter.string(for: detailItem.area) {
            return "Area: \(area) Km²"
        }
        return "Area: N/A"
    }
    
    func configureTimezone(_ timezone: String) -> String {
        return "\(timezone)"
    }
    
    func configureCurrency(_ currency: Currency) -> String {
        let code = currency.code ?? ""
        let name = currency.name ?? ""
        let symbol = currency.symbol ?? ""
        return "\(code) · \(name) · \(symbol)"
    }
    
    func configureLangCode(_ language: Language) -> String {
        if let iso6391 = language.iso6391 { return "\(iso6391), \(language.iso6392)" }
        return "Language Codes: N/A"
    }
    
    func configureLanguage(_ language: Language) -> String {
        if language.name == language.nativeName { return "\(language.name)" }
        return "\(language.name) · \(language.nativeName)"
    }
    
}
