//
//  AddPhotoViewController.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/17/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Photos
import Vision
import CoreML

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionTextField: UITextView!
    @IBOutlet var tagsTextField: UITextField!
    @IBOutlet var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet var trashButtonOutlet: UIBarButtonItem!
    @IBOutlet var weatherLabel: UILabel!
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    var dateCreatedStr = String()
    var latituteDoub = Double()
    var longitudeDoub = Double()
    var allPhotos : [PhotoStruct]?
    var actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var weatherObj : Weather?          // Hold weather info
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actInd.center = view.center
        imagePicker.delegate = self
        
        // Used for activity indicator for posting photo to cloud
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(localSave),
                                       name: .photoSavedToCloud,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(stopAnimation),
                                       name: .finishedSyncing,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(alertSaveError),
                                       name: .errorSaving,
                                       object: nil)
        
        // Hide weather label until we load potential weather data
        weatherLabel.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Weather Networking
    
    func getWeatherInfo(urlString: String) {
        WeatherNetworking.sharedInstance.getData(url: urlString) { (weatherObj, error) in
            
            // Check if API request fails
            if error != nil {
                print(error?.localizedDescription ?? "API network error.")
                return
            }
            
            self.weatherObj = weatherObj
            print("We got a weatherObj!")
            
            DispatchQueue.main.async {
                self.updateWeatherUI()
            }
        }
    }
    
    func updateWeatherUI() {
        print("⛱ WE GOT WEATHER DATA!")
        if let icon = weatherObj?.currently?.icon {
            print("Icon is \(icon)")
            weatherLabel.alpha = 1.0
            weatherLabel.text = "Weather: \(icon)"
        } else {
            print("No current weather icon for this location.")
        }
    }
    
    // MARK: - Maching Learning
    
    func imageRecognition(image: UIImage) {
        print("Image maching learning called.")
        
        // Convert to CIImage (CoreImage)
        guard let ciImage = CIImage(image: image) else {
            fatalError("Not able to convert UIImage to CIImage")
        }
        
        detectObjects(image: ciImage)
    }
    
    func detectObjects(image: CIImage) {
        
        print("Detect objects called")
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("Can't load the ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Unexpected result type from VNCoreMLRequest")
            }
            
            // Put the top 5 into a string to show on the screen
            var tags = ""
            for result in results[0...4] {
                let tag = "#\(result.identifier)"
                
                // We don't need synonyms listed from ML model.
                // This just takes the first synonym of each image resultant
                var tagWithOutCommas = ""
                for (_, char) in tag.enumerated() {
                    if char == "," {
                        break
                    } else {
                        tagWithOutCommas.append("\(char)")
                    }
                }
                
                // Combine all tags into one
                tags = tags + tagWithOutCommas + " "
            }
            
            // Update tag field on UI
            DispatchQueue.main.async {
                self.tagsTextField.text = tags
            }
        }
        
        // Run the Core ML model classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Image Picker

    @IBAction func choosePhotoPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            guard let asset = info[UIImagePickerControllerPHAsset] as? PHAsset else {
                print("Get Image Asset failure.")
                return
            }
            
            // Check if we have location data
            if let location = asset.location {
                print("Latitude is: \(String(describing: location.coordinate.latitude))")
                print("Longitute is: \(String(describing: location.coordinate.longitude))")
                latituteDoub = location.coordinate.latitude
                longitudeDoub = location.coordinate.longitude
            } else {
                print("Location nil.")
            }
            
            // Check if we have date creation data
            if let dateObj = asset.creationDate {
                print("A creation date exists! \(dateObj.toString(dateFormat: "MMMM d, yyyy"))")
                dateCreatedStr = dateObj.toString(dateFormat: "MMMM d, yyyy")
            } else {
                print("Date created is nil.")
            }
            
            // Load picked image into imageView
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            // Run Machine Learning on picked Image
            // Convert to CIImage (CoreImage)
            imageRecognition(image: pickedImage)
            
            // Load up potential weather image using latitude & longitutde
            getWeatherInfo(urlString: WeatherNetworking.sharedInstance.generateAPIString(latitude: latituteDoub, longitude: longitudeDoub))
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save Actions
    
    // Save to cloud
    @IBAction func savePressed(_ sender: Any) {
        saveButtonOutlet.tintColor = UIColor.gray
        trashButtonOutlet.tintColor = UIColor.gray
        saveButtonOutlet.isEnabled = false
        trashButtonOutlet.isEnabled = false
        cloudSave()
        //localSave()
    }
    
    // Save to cloud
    func cloudSave() {
        
        // Check for all objects needed to save
        guard let image = imageView.image else {
            print("No image to save. Don't bother.")
            self.incompleteEntry()
            return
        }
        guard let caption = captionTextField.text else {
            print("No caption to save. Don't bother.")
            self.incompleteEntry()
            return
        }
        guard let tags = tagsTextField.text else {
            print("No tags to save. Don't bother.")
            self.incompleteEntry()
            return
        }
        
        // Make sure the user changed the image.
        if image == UIImage(named: "default") {
            print("Default image loaded. Change photo.")
            self.incompleteEntry()
            return
        }
        
        // Start activity indicator
        actInd.startAnimating()
        view.addSubview(actInd)
        
        // Create photo object
        let photo = Photo(fullsizeImage: image, caption: caption, tags: tags, date: dateCreatedStr, lat: latituteDoub, long: longitudeDoub)
        
        // Save entire object to cloud
        CloudKitManager.sharedInstance.savePhoto(photo)
    }
    
    // Save to local
    @objc func localSave() {
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            CloudKitManager.sharedInstance.cloudToDisk()
        }
        
        //CloudKitManager.sharedInstance.cloudToDisk()
    }
    
    @objc func stopAnimation() {
        saveButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        trashButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        actInd.stopAnimating()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        self.trashAlert()
    }
    
    // MARK: - Alerts
    
    func trashAlert() {
        saveButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        trashButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        actInd.stopAnimating()
        
        let alert = UIAlertController(title: "Are you sure?", message: "Click cancel to continue editing this entry.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete Entry", style: .destructive, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    func incompleteEntry() {
        
        saveButtonOutlet.isEnabled = true
        trashButtonOutlet.isEnabled = true
        saveButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        trashButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        
        let alert = UIAlertController(title: "Incomplete journal entry.", message: "Make sure all fields are filled out before saving entry.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func alertSaveError() {
        saveButtonOutlet.isEnabled = true
        trashButtonOutlet.isEnabled = true
        saveButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        trashButtonOutlet.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        actInd.stopAnimating()
        
        let alert = UIAlertController(title: "Error saving journal entry to iCloud.",
                                      message: "Check internet connection and try again.",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            _ = self.navigationController?.popViewController(animated: false)
        })
        
        alert.addAction(submitAction)
        self.present(alert, animated: true)
    }
}

extension Date {
    
    // Convert Date to readable String for cloud
    func toString(dateFormat: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
