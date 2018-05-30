//
//  MainViewController.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/17/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    var photos = [PhotoStruct]()
    var months = [String]()
    var dictOfMonths = [String: [PhotoStruct]]()
    
    var filteredMonths = [String]()
    var filteredData = [PhotoStruct]()
    var filteredDictOfMonths = [String: [PhotoStruct]]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120.0
        
        // Alert used if our local image file is empty
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(alertNoLocalData),
                                       name: .noLocalData,
                                       object: nil)
        
        // Set up nav & search bars
        setupNavAndSearch()
        
        // Set up today extension
        setUpTodayExtension()
    }
    
    func setupNavAndSearch() {
        // Setup nav bar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup search bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search Photo Tags"
        searchController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photos = StructToDisk.sharedInstance.getPostsFromDisk()
        
        // Create arrays of months to fill table view
        createMonths()
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }

    // MARK: - Actions
    
    @IBAction func settingsPressed(_ sender: Any) {
        showSettings()
    }
    
    // Attribution: - https://stackoverflow.com/questions/37722323/how-to-present-view-controller-from-right-to-left-in-ios-using-swift
    func showSettings() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    // MARK: - Alerts
    
    @objc func alertNoLocalData() {
        
        let alert = UIAlertController(title: "No journal entries on this device.",
                                      message: "Go to settings to sync your iCloud data.",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            self.showSettings()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Search Bar & Filtering
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredDictOfMonths.removeAll()
        filteredMonths.removeAll()
        filteredData.removeAll()
        
        if searchText.description == "" {
            filteredMonths = months
            filteredDictOfMonths = dictOfMonths
        }
        
        // For each photo, create a string of all terms to possibly search on
        let textToSearch = searchText.description.lowercased()
        print("Search text is \(textToSearch)")
        
        var stringsToSearch = [(String, PhotoStruct)]()
        for photo in photos {
            var result = ""
            result.append(photo.caption.lowercased())
            result.append(photo.tags.lowercased())
            result.append(photo.date.lowercased())
            stringsToSearch.append((result, photo))
        }
        
        // Create new data source for table based on matches.
        for entry in stringsToSearch {
            //if entry.0.contains(textToSearch) {
            print(textToSearch)
            print(entry.0)
            
            if entry.0.contains(textToSearch) {
                filteredData.append(entry.1)
                print("We found a match for \(textToSearch).")
            } else {
                print("No match for \(textToSearch)")
            }
        }
        setUpFilteredDictionaryDataSource()
        tableView.reloadData()
    }
    
    @objc func setUpFilteredDictionaryDataSource() {
        // Fill filtered months array
        for photo in self.filteredData {
            let arrayOfWords = photo.date.components(separatedBy: " ")
            let month = arrayOfWords[0]
            if !filteredMonths.contains(month) {
                filteredMonths.append(month)
            }
        }
        
        // Set up dictionary
        for month in filteredMonths {
            filteredDictOfMonths[month] = []
        }
        for photo in self.filteredData {
            let arrayOfWords = photo.date.components(separatedBy: " ")
            let month = arrayOfWords[0]
            if filteredMonths.contains(month) {
                filteredDictOfMonths[month]?.append(photo)
            }
        }
        
        //print(filteredData)
        print("Filtered months is: \(filteredMonths)")
        for _ in 0..<filteredDictOfMonths.count {
            print(filteredDictOfMonths.keys)
        }
    }
    
    // Filters content based on the selected annotation in MapVC
    @objc func filterContentFromMapSelect(filteredLat: Double, filteredLong: Double) {
        
        searchController.searchBar.text = " "
        
        print("🗺Filter from map called")
        
        let filteredLat = 41.8
        let filteredLong = -87.6
        
        filteredDictOfMonths.removeAll()
        filteredMonths.removeAll()
        filteredData.removeAll()
        
        // Only include photoObjects close enough to selected map point
        for photo in photos {
            if (photo.lat-3 < filteredLat && filteredLat < photo.lat+3) {
                if (photo.long-3 < filteredLong && filteredLong < photo.long+3) {
                    filteredData.append(photo)
                }
            }
        }
        setUpFilteredDictionaryDataSource()
        tableView.reloadData()
    }
    
    @IBAction func mapPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showMapSegue", sender: nil)
    }
    
    func isFiltering() -> Bool {
        return (searchController.isActive && !searchBarIsEmpty()) || searchController.searchBar.text == " "
    }
    
    // MARK: - Today Extension
    func setUpTodayExtension() {
        UserDefaults.init(suiteName: "scannillo.journal-app-widget")?.set("Does this work?", forKey: "key")
    }
}

// MARK: - UISearchResultsUpdating Delegate

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: - Table View Data Source

extension MainViewController : UITableViewDataSource {
    
    // Places photos into appropriate photo array
    func createMonthDict() {
        for photo in self.photos {
            let arrayOfWords = photo.date.components(separatedBy: " ")
            let month = arrayOfWords[0]
            if months.contains(month) {
                dictOfMonths[month]?.append(photo)
            }
        }
    }
    
    func createMonths() {
        for photo in self.photos {
            let arrayOfWords = photo.date.components(separatedBy: " ")
            let month = arrayOfWords[0]
            if !months.contains(month) {
                months.append(month)
            }
        }
        
        for month in months {
            dictOfMonths[month] = []
        }
        createMonthDict()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        createMonths()
        
        if isFiltering() {
            return filteredMonths.count
        }
        
        return months.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            return filteredMonths[section]
        }
        return months[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        if isFiltering() {
            
            // If we are filtering
            for i in 0..<filteredDictOfMonths.count {
                if section == i {
                    rowCount = (filteredDictOfMonths[filteredMonths[i]]?.count)!
                }
            }
            return rowCount
            
        } else {
        
            // Not filtering
            for i in 0..<dictOfMonths.count {
                if section == i {
                    rowCount = (dictOfMonths[months[i]]?.count)!
                }
            }
            return rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PhotoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PhotoTableViewCell else {
            fatalError("The dequeued cell is not an instance of PhotoTableViewCell.")
        }
        
        // If not filtering
        if !isFiltering() {
            for i in 0..<months.count {
                if indexPath.section == i {
                    let photoObj = self.dictOfMonths[months[i]]![indexPath.row]
                
                        //Set cell label properties
                        cell.cellTags.text = photoObj.caption
                
                        //Set cell image
                        cell.cellImageView.image = SSCache.sharedInstance.getImage(Key: photoObj.tags)
                    
                        cell.dateLabel.text = photoObj.date
                }
            }
        } else {
            // If filtering
            for i in 0..<filteredMonths.count {
                if indexPath.section == i {
                    let photoObj = self.filteredDictOfMonths[filteredMonths[i]]![indexPath.row]
                    
                    //Set cell label properties
                    cell.cellTags.text = photoObj.caption
                    
                    //Set cell image
                    cell.cellImageView.image = SSCache.sharedInstance.getImage(Key: photoObj.tags)
                    
                    cell.dateLabel.text = photoObj.date
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView?.indexPath(for: sender as! PhotoTableViewCell) {
                
                let destination = segue.destination as! DetailViewController
                
                if indexPath.section < dictOfMonths.count && indexPath.section >= 0 {
                    let photoObj = self.dictOfMonths[months[indexPath.section]]![indexPath.row]
                    destination.photoInstance = photoObj
                    destination.allPhotos = self.photos
                }
            }
        }
        if segue.identifier == "showAddPhoto" {
            if segue.destination is AddPhotoViewController {
                let vc = segue.destination as? AddPhotoViewController
                vc?.allPhotos = self.photos
            }
        }
        if segue.identifier == "showMapSegue" {
            if let destination = segue.destination as? MapViewController {
                destination.selectAnnotationDelegate = self
            }
        }
    }
}

// Implement 'SelectAnnotationDelegate' methods
extension MainViewController: SelectAnnotationDelegate {
    
    func sendAnnotationToMainVC(filteredLat: Double, filteredLong: Double) {
        print("🗺Send annotation to main VC called")
        self.filterContentFromMapSelect(filteredLat: filteredLat, filteredLong: filteredLong)
    }
    
}
