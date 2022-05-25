//
//  ViewController.swift
//  MapsUIkit
//
//  Created by Vir Davinder Singh on 2022-05-23.
//
import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate {

    
    @IBOutlet var mapView: MKMapView!
    
    var count = 0
    var arr:[String] = ["A","B","C"]
    
    var destination : CLLocationCoordinate2D!
    var start : CLLocationCoordinate2D!
    
    var coodarr: [CLLocationCoordinate2D] = []
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
         tap.numberOfTapsRequired = 1
       // tap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(addLongPressAnnotattion))
        view.addGestureRecognizer(longpress)
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        
        addPolygon()
        
        
        
    }
    
    @IBAction func draw(_ sender: UIButton) {
        
        
        routes(start : coodarr[0],destination : coodarr[0])
        routes(start :coodarr[1],destination : coodarr[2])
        routes(start :coodarr[2],destination : coodarr[0])
        
       
    }
    
    func routes(start : CLLocationCoordinate2D , destination : CLLocationCoordinate2D)
    {
        
        mapView.removeOverlays(mapView.overlays)
               
               let sourcePlaceMark = MKPlacemark(coordinate: start)
               let destinationPlaceMark = MKPlacemark(coordinate: destination)
               
               // request a direction
               let directionRequest = MKDirections.Request()
               
               // assign the source and destination properties of the request
               directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
               directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
               
               // transportation type
               directionRequest.transportType = .automobile
               
               // calculate the direction
               let directions = MKDirections(request: directionRequest)
               directions.calculate { (response, error) in
                   guard let directionResponse = response else {return}
                   // create the route
                   let route = directionResponse.routes[0]
                   // drawing a polyline
                   self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                   
                   // define the bounding map rect
                   let rect = route.polyline.boundingMapRect
                   self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
                   
           }
        
        
        
    }
    func addPolygon() {
            let polygon = MKPolygon(coordinates: coodarr, count: coodarr.count)
            mapView.addOverlay(polygon)
        }
    
//    func addAnnotationsForPlaces() {
//            mapView.addAnnotations(places)
//
//            let overlays = places.map {MKCircle(center: $0.coordinate, radius: 2000)}
//            mapView.addOverlays(overlays)
//        }
//    func addPolyline() {
//            let coordinates = places.map {$0.coordinate}
//            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//            mapView.addOverlay(polyline)
//        }
    
    func removePin() {
            for annotation in mapView.annotations
           {
                if annotation.title == "Vir Here"
                {
                }
                else
                {
                mapView.removeAnnotation(annotation)
                }
            }
            
   
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let alertController = UIAlertController(title: "Your Favorite", message: "A nice place to visit", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
   
    @objc func addLongPressAnnotattion(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == .ended
        {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            // add annotation for the coordinate
        if count < 3
        {
            let annotation = MKPointAnnotation()
            
            if count == 0
            {
                
                    annotation.title = arr[count]
                    count += 1
            }
            else if count == 1
            {
                    annotation.title = arr[count]
                    count += 1
            }
            else if count == 2
            {
                annotation.title = arr[count]
                count += 1

            }
            
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
        else
        {
            
        }
    }
    }
    
   
    @objc func tapped(sender: UITapGestureRecognizer)
    {
        
        mapView.removeOverlays(mapView.overlays)
        if sender.state == .ended
        {
        if count < 3
            {
            let touchPoint = sender.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
                    let annotation = MKPointAnnotation()
            if count == 0
            {
                coodarr.append(coordinate)
                    annotation.title = arr[count]
                    count += 1
            }
            else if count == 1
            {
                coodarr.append(coordinate)
                    annotation.title = arr[count]
                    count += 1
            }
            else if count == 2
            {
                
                coodarr.append(coordinate)
                annotation.title = arr[count]
                count += 1

            }
            
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            if coodarr.count == 3
            {
                addPolygon()
            }
        }
            else
            {
                removePin()
                count = 0
            }
           
            
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle {
                let rendrer = MKCircleRenderer(overlay: overlay)
                rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
                rendrer.strokeColor = UIColor.green
                rendrer.lineWidth = 2
                return rendrer
            } else if overlay is MKPolyline {
                let rendrer = MKPolylineRenderer(overlay: overlay)
                rendrer.strokeColor = UIColor.blue
                rendrer.lineWidth = 3
                return rendrer
            } else if overlay is MKPolygon {
                let rendrer = MKPolygonRenderer(overlay: overlay)
                rendrer.fillColor = UIColor.red.withAlphaComponent(0.5)
                rendrer.strokeColor = UIColor.green
                rendrer.lineWidth = 4
                return rendrer
            }
            return MKOverlayRenderer()
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


