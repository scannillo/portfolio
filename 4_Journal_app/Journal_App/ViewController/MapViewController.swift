//
//  MapViewController.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/23/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    static let sharedInstance = MapViewController()
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Properties
    var photos = [PhotoStruct]()
    var myAnnotations = [MKPointAnnotation]()
    
    // Reference to the object that conforms to the `ContactFavoriteDelegate`
    weak var selectAnnotationDelegate: SelectAnnotationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photos = StructToDisk.sharedInstance.getPostsFromDisk()
        
        // Add each photoObj location to the map
        for obj in self.photos {
            self.addPoint(lat: obj.lat, long: obj.long)
        }
        
        // Add annotations to map
        mapView.addAnnotations(myAnnotations)
    }
    
    // Adds a lat/long point to map
    func addPoint(lat: Double, long: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        myAnnotations.append(annotation)
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationInstance = view.annotation {
            print("User tapped on annotation : \(String(describing: view.annotation))")
            
            // Pass these lat & long into MainVC
            print("Latitude: \(annotationInstance.coordinate.latitude)")
            print("Longitude: \(annotationInstance.coordinate.longitude)")
            
            // Tell the MainVC we selected a map annotation & filter search results
            selectAnnotationDelegate?.sendAnnotationToMainVC(filteredLat: annotationInstance.coordinate.latitude, filteredLong: annotationInstance.coordinate.longitude)
            
            // Dismiss MapVC
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func settingsPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
}
