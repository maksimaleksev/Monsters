//
//  ViewController.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit
import MapKit

protocol MapViewProtocol: class {
    var scale: Double { get set }
    func show(region: MKCoordinateRegion)
    func showLocationSettingsAlert(title: String, message: String)
}

class MapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol!
    var scale = 0.0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scaleButtonsStackView: UIStackView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var centerMapOnUserButton: UIButton!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scaleButtonsStackView.layer.cornerRadius = 5
        centerMapOnUserButton.layer.cornerRadius = centerMapOnUserButton.frame.width/2
    }
    
    //MARK: - IBActions
    
    @IBAction func zoomInButtonTapped(_ sender: UIButton) {
        
        if scale > 0.25 {
            scale -= 0.25
            guard let region = presenter.makeRegion(scale: scale) else { return }
            mapView.setRegion(region, animated: true)
        } else {
            scale = 0.0
            guard let location = presenter.userLocation else { return }
            presenter.getLocation(location)
        }
    }
    
    @IBAction func zoomOutButtonTapped(_ sender: UIButton) {
        
        scale += 0.25
        guard let region = presenter.makeRegion(scale: scale) else { return }
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func centerMapOnUserButtonTapped(_ sender: UIButton) {
        guard let location = presenter.userLocation else { return }
        presenter.getLocation(location)
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
 
    func show(region: MKCoordinateRegion) {
        guard let mapView = mapView else { return }
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
