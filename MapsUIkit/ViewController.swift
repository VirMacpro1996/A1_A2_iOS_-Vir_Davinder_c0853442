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
    var mylocation : CLLocation? = nil
    
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
        
        mapView.removeOverlays(mapView.overlays)
        
        routes(start : coodarr[0],destination : coodarr[1])
        routes(start :coodarr[1],destination : coodarr[2])
        routes(start :coodarr[2],destination : coodarr[0])
        
       
    }
    
    func routes(start : CLLocationCoordinate2D , destination : CLLocationCoordinate2D)
    {
        
       
               
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
                count = 0
            }
        }
        else
        {
            removePin()
            count = 0
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
                coodarr.removeAll()
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
        let coordinate = CLLocationCoordinate2D(latitude : location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        mylocation = location
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                                     longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region ,
                          animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Vir Here"
        pin.subtitle = "My Location"
        mapView.addAnnotation(pin)
        
        
        
    }
    
    @objc func getDistance(pointer1: CLLocation, pointer2: CLLocation) ->String {
            let distanceInMeters = pointer1.distance(from: pointer2);
            let distanceInKms = distanceInMeters / 1000;
            return String(format: "%.2f", distanceInKms)
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let distanceFromA = getDistance(pointer1: mylocation!, pointer2: CLLocation(latitude: coodarr[0].latitude, longitude: coodarr[0].longitude))
            let distanceFromB = getDistance(pointer1: mylocation!, pointer2: CLLocation(latitude: coodarr[1].latitude, longitude: coodarr[1].longitude))
            let distanceFromC = getDistance(pointer1: mylocation!, pointer2: CLLocation(latitude: coodarr[2].latitude, longitude: coodarr[2].longitude))

            let alertController = UIAlertController(title: "Distance", message: "From Point A : \(distanceFromA) KM\n From Point B : \(distanceFromB) KM\n From Point C : \(distanceFromC) KM", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    
    
   
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           
        if overlay is MKPolyline {
                    let rendrer = MKPolylineRenderer(overlay: overlay)
                    rendrer.strokeColor = UIColor.blue
                    rendrer.lineWidth = 3
                    return rendrer
                }
        else if overlay is MKPolygon {
                let rendrer = MKPolygonRenderer(overlay: overlay)
                rendrer.fillColor = UIColor.red.withAlphaComponent(0.5)
                rendrer.strokeColor = UIColor.green
                rendrer.lineWidth = 4
                return rendrer
                }
        return MKOverlayRenderer()
            
        }
    func mapView(_ mapView: MKMapView , viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
                   return nil
               }
               let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
               annotationView.markerTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
               annotationView.canShowCallout = true
               annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
               return annotationView
           }
    }
    
    
    
   



