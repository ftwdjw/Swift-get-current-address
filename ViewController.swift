//
//  ViewController.swift
//  SwiftCurrentAddress
//
//  Created by John Mac on 10/4/16.
//  Copyright © 2016 John Wetters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    

    
    /******Outlets**********/
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func getAddress(_ sender: AnyObject) {
         dropPin=true
        localText = ""
        print("\nlocal text=\(localText)\n")
        print("drop pin")
        self.locationManager.startUpdatingLocation()
    }

    @IBAction func stop(_ sender: AnyObject) {
        dropPin=false
        //self.locationManager.stopUpdatingLocation()
        self.mapView.removeAnnotations([self.annotation])
        print("delete pin")
    }
    
    /******Outlets**********/
    
 
    //variables
    var localText = ""
    var measurement=0
    var measurementSave = 0
    var i=0
    var latitude=0.0
    var longitude=0.0
    var dropPin=true
    var lastDropPin=false
    let annotation = MKPointAnnotation()
    let placemarks = MKPlacemark()//init for placemark data
    var data : [String] = []
    let geocoder = CLGeocoder()
    var myText = ""
    var locationManager = CLLocationManager()
    
    
    // MARK: - Properties
    
//    lazy var locationManager : CLLocationManager = {
//        
//        let locationManager = CLLocationManager()
//        
//        //Set up location manager with defaults
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.delegate = self
//        
//        //Optimisation of battery
//        locationManager.pausesLocationUpdatesAutomatically = true
//        locationManager.activityType = CLActivityType.fitness
//        locationManager.allowsBackgroundLocationUpdates = false
//        
//        return locationManager
//    }()
//

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
          self.locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        //let geocoder = CLGeocoder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    // MARK: - CLLocation didUpdateLocations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation])
    {//start location
        var count=0
        
        let location = locations.last
        
        print("update last location \(measurement)")
        measurement += 1
        
        
        latitude=location!.coordinate.latitude
        longitude=location!.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //print("center=\(center)")
        
        self.mapView.setRegion(region, animated: true)
        
        //self.geocoder.reverseGeocodeLocation(locationManager.location!, completionHandler:{ (placemarks,error) -> Void in } )
        
        self.geocoder.reverseGeocodeLocation(self.locationManager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {//start error
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }//end error
        
            print("placemarks count=\((placemarks?.count)!)")
        //do stuff in here
            if (placemarks?.count)! > 0 {//start if
                
                count += 1
                
                 let pm = placemarks![0]
                
                //get placemark info
                let title1=[ (pm.subThoroughfare!) +  " " + (pm.thoroughfare!)]
                var subTitle1=[ (pm.locality!) +   " , " + (pm.administrativeArea!) + " " ]
                subTitle1.append(pm.postalCode!)
                // add annotation
                self.annotation.title =  title1.joined(separator: " ")
                print("\(title1)")
                self.annotation.subtitle=subTitle1.joined(separator: " ")
                print("\(subTitle1)")
                self.annotation.coordinate = (self.locationManager.location?.coordinate)!
                self.mapView.addAnnotation(self.annotation)
                //select and show annotation
                let yourAnnotationAtIndex = 0
                self.mapView.selectAnnotation(self.mapView.annotations[yourAnnotationAtIndex], animated: true)
                
                if count==1{
                    self.locationManager.stopUpdatingLocation()
                }
                
                print("count=\(count)")
                
            }//end if
        
        
        
        })//end of do stuff in here

       

           }//end locaton
    
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = MKUserTrackingMode.follow
            
            print("\nPermission Allowed\n")
        } else {
            print("\nPermission Refused\n")
        }
    }
    
    // MARK: - LocationManagerError
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error:Error)
    {
        print("Error: " + error.localizedDescription)
    }
    



}

//    var localText : String = ""
//    var postalCode : String = ""
//    var title1 : [String] = [""]
//    var subTitle1 : [String] = [""]
//var location = CLLocation()
//var center:CLLocationCoordinate2D

// MARK: - getAddress

//    func getAddress(){//start getAddress
//        print("try to get address here")
//
//                    //start of reverseGeocoder
//
//                CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error) -> Void in
//                    print(self.locationManager.location)
//
//                    if error != nil {//start error
//                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//                        return
//                    }//end error
//
//                        if (placemarks?.count)! > 0 {//start if
//
//                            print("\nprint out placemarks\n")
//                            let pm = placemarks![0]
//
//
//                            print("pm=\(pm)")
//
//                            print("\nthoroughfare=\(pm.thoroughfare!)\n")
//                            print("\nsubThoroughfare=\(pm.subThoroughfare!)\n")
//                             print("\n locality=\(pm.locality!)\n")
//                            self.localText=pm.locality!
//                             //print("\nsubLocality=\(pm.subLocality!)\n")
//                            print("\nadministrativeArea=\(pm.administrativeArea!)\n")
//                            print("\nsubAdministrativeArea=\(pm.subAdministrativeArea!)\n")
//                            print("\npostalCode=\(pm.postalCode!)\n")
//                            print("\ncountry=\(pm.country!)\n")
//                            print("\nISOcountryCode=\(pm.isoCountryCode!)\n")
//                            self.title1=[ (pm.subThoroughfare!) +  " " + (pm.thoroughfare!)]
//                            self.subTitle1=[ (pm.locality!) +   " , " + (pm.administrativeArea!) + " " ]
//                            self.subTitle1.append(pm.postalCode!)
//                        }//end if
//                        else {//start else
//                            print("Problem with the data received from geocoder")
//                        }//end else
//                    })
//                    //end of reverse geocoder
//
//
//                    print("place=",localText)
//                    annotation.title =  self.title1.joined(separator: " ")
//                    annotation.subtitle=self.subTitle1.joined(separator: " ")
//                    annotation.coordinate = (locationManager.location?.coordinate)!
//                    mapView.addAnnotation(annotation)
//                    measurementSave=measurement
//                    print("\nadd annotation\n")
//                    print("\nmeasurementSaved=\(measurementSave)\n")
//
//
//                    let yourAnnotationAtIndex = 0
//                    mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
//
//
//                    self.locationManager.stopUpdatingLocation()
//         }


//            annotation.title = "Get My Location"
//            annotation.subtitle = "           Address"
//            annotation.coordinate = center
//            mapView.addAnnotation(annotation)
//            //select to show annotation
//            mapView.selectAnnotation(annotation, animated: true)
//            //let yourAnnotationAtIndex = 0
//            //mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
//            measurementSave=measurement
//            print("\nadd annotation\n")
//            print("\nmeasurementSaved=\(measurementSave)\n")



//            print("place=",pm.locality!)
//            annotation.title =  self.title1.joined(separator: " ")
//            annotation.subtitle=self.subTitle1.joined(separator: " ")
//            annotation.coordinate = (locationManager.location?.coordinate)!
//            mapView.addAnnotation(annotation)
//            measurementSave=measurement
//            print("\nadd annotation\n")
//            print("\nmeasurementSaved=\(measurementSave)\n")
//
//
//            let yourAnnotationAtIndex = 0
//            mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
//
//
//            self.locationManager.stopUpdatingLocation()
//
//
//

