//
//  ViewController.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit
import MapKit

protocol MapViewProtocol: class {
    func showLocation(location: CLLocationCoordinate2D)
    func showLocationSettingsAlert(title: String, message: String)
}

class MapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol!
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
 
    func showLocation(location: CLLocationCoordinate2D) {
        guard let mapView = mapView else { return }
        
        let regionRadius: CLLocationDistance = 1000
        
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
    }
    
    func showLocationSettingsAlert(title: String, message: String) {
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }

        
}

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
}
