//
//  ViewController.swift
//  MapsUIkit
//
//  Created by Vir Davinder Singh on 2022-05-23.
//
import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController , CLLocationManagerDelegate{

    
    @IBOutlet var mapView: MKMapView!
    
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
         tap.numberOfTapsRequired = 1
       // tap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func tapped(sender: UITapGestureRecognizer)
    {
        if sender.state == .ended
        {
            print("tap geture recognized")
        }
    }
 
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    func render(_ location : CLLocation)
    {
        let coordinate = CLLocationCoordinate2D(latitude: 45.728,
                                                longitude: -67)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                                     longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region ,
                          animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Vir Here"
        pin.subtitle = "empty"
        mapView.addAnnotation(pin)
        
        
        
    }
    func mapView(_ mapView: MKMapView , viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else
        {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        
        if annotation == nil
        {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")

            annotationView?.canShowCallout  = true
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "location-arrow")
        return annotationView
    }
   
}

