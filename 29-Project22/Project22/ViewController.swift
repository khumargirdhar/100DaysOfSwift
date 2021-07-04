//
//  ViewController.swift
//  Project22
//
//  Created by Khumar Girdhar on 05/06/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var circleView: UIView!
    
    var locationManager: CLLocationManager?
    //Challenge1
    var isAlertShown = false
    //Challenge2
    var beacons = [Beacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circleView.layer.cornerRadius = 128
        circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        let beacon1 = Beacon(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "MyBeacon1")
        let beacon2 = Beacon(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 123, minor: 456, identifier: "MyBeacon2")
        let beacon3 = Beacon(uuid: UUID(uuidString: "5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF")!, major: 123, minor: 456, identifier: "MyBeacon3")
        let beacon4 = Beacon(uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 123, minor: 456, identifier: "MyBeacon4")
        let beacon5 = Beacon(uuid: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!, major: 123, minor: 456, identifier: "MyBeacon5")
        
        beacons += [beacon1, beacon2, beacon3, beacon4, beacon5]
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    for beacon in beacons {
                        startScanning(uuid: beacon.uuid!, major: beacon.major!, minor: beacon.minor!, identifier: beacon.identifier!)
                    }
                }
            }
        }
    }
    
    func startScanning(uuid: UUID, major: UInt16, minor: UInt16, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .red
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            case .immediate:
                self.view.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE!"
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            //Challenge 1
            if !isAlertShown {
                isAlertShown = true
                let ac = UIAlertController(title: "Beacon 5A4 found!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
         
            for beacon in beacons {
                if beacon.uuid == UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") {
                    nameLabel.text = "MyBeacon1"
                } else if beacon.uuid == UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0") {
                    nameLabel.text = "MyBeacon2"
                } else if beacon.uuid == UUID(uuidString: "5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF") {
                    nameLabel.text = "MyBeacon3"
                } else if beacon.uuid == UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") {
                    nameLabel.text = "MyBeacon4"
                } else if beacon.uuid == UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6") {
                    nameLabel.text = "MyBeacon5"
                }
            }
        }
    }
}

