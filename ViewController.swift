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
    var measurement=0
    var dropPin=true
    let geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    


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
        
        
        let latitude=location!.coordinate.latitude
        let longitude=location!.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //print("center=\(center)")
        
        self.mapView.setRegion(region, animated: true)
        
        self.geocoder.reverseGeocodeLocation(self.locationManager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {//start error
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }//end error
            
        
            print("placemarks count=\((placemarks?.count)!)")
        //do stuff in here
            
             let pm = placemarks![0]
            
            print("subThoroughfare=\(pm.subThoroughfare)")
            
             print("thoroughfare=\(pm.thoroughfare)")
            
            print("locality=\(pm.locality)")
            print("administrativeArea=\(pm.administrativeArea)")
              print("postalCode=\(pm.postalCode)")
            
            if (placemarks?.count)! > 0 {//start if
                
                count += 1
                
                
                
                //get placemark info
                
                //fatal error: unexpectedly found nil while unwrapping an Optional value
                var title1 = [""]
                
                if pm.subThoroughfare == nil{
                   title1 = [(pm.thoroughfare!)]
                }
                else{
                  title1=[ (pm.subThoroughfare!) +  " " + (pm.thoroughfare!)]
                }

                //let title1=[ (pm.subThoroughfare!) +  " " + (pm.thoroughfare!)]
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
                //let yourAnnotationAtIndex = 0
                
                print("annotations=\([self.mapView.annotations])")
                
                let number = self.mapView.annotations.count
                
                                if number == 2{
                    self.mapView.selectAnnotation(self.mapView.annotations[1], animated: true)
                      }
                                else{
            
                self.mapView.selectAnnotation(self.mapView.annotations[0], animated: true)
                }
                
                if count==1{
                    self.locationManager.stopUpdatingLocation()
                }
                
                print("count=\(count)")
                //self.mapView.selectAnnotation(self.mapView.annotations[0], animated: true)
                
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

