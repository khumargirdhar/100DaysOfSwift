//
//  ViewController.swift
//  Project16
//
//  Created by Khumar Girdhar on 21/05/21.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NewDelhi = Capital(title: "New Delhi", coordinate: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), info: "India's Capital.")
        let London = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home for the 2012 Summer Olympics.")
        let Oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let Paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let Rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 49.9, longitude: 12.5), info: "Has a whole country inside it.")
        let Washington = Capital(title: "Washington D.C", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        //Challenge 2
        mapStyle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(mapStyle))
        
//        mapView.addAnnotation(NewDelhi)
//        mapView.addAnnotation(London)
//        mapView.addAnnotation(Oslo)
//        mapView.addAnnotation(Paris)
//        mapView.addAnnotation(Rome)
//        mapView.addAnnotation(Washington)
        
        mapView.addAnnotations([NewDelhi, London, Oslo, Paris, Rome, Washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = try mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView                  //Challenge 1
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            //challenge 1
            annotationView?.pinTintColor = .systemBlue
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac,animated: true)
        
        
        //Challenge 3
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            if capital.title == "New Delhi" {
                vc.website = "https://en.wikipedia.org/wiki/New_Delhi"
            }
            if capital.title == "London" {
                vc.website = "https://en.wikipedia.org/wiki/London"
            }
            if capital.title == "Oslo" {
                vc.website = "https://en.wikipedia.org/wiki/Oslo"
            }
            if capital.title == "Paris" {
                vc.website = "https://en.wikipedia.org/wiki/Paris"
            }
            if capital.title == "Rome" {
                vc.website = "https://en.wikipedia.org/wiki/Rome"
            }
            if capital.title == "Washington D.C" {
                vc.website = "https://en.wikipedia.org/wiki/Washington,_D.C."
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //Challenge 2
    @objc func mapStyle() {
        let ac = UIAlertController(title: "How do you want maps to look?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Default", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }))
        present(ac,animated: true)
    }
    
    
}

