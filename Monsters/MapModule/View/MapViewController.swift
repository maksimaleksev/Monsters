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
    func setAnnotations(_ annotations: [MonsterAnnotation])
    func animateWarningDistanceViewAppear()
}

class MapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol!
    internal var scale: Double = 0.0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scaleButtonsStackView: UIStackView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var centerMapOnUserButton: UIButton!
    @IBOutlet weak var showMyTeamButton: UIButton!
    @IBOutlet weak var warningDistanceView: UIView!
    @IBOutlet weak var warningDistanceLabel: UILabel!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupAppDelegate()
        self.warningDistanceView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        showMyTeamButton.isHidden = presenter.isTeamEmpty
        setupButtonsaAndViewAppereance()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scaleButtonsStackView.layer.cornerRadius = 5
        centerMapOnUserButton.layer.cornerRadius = centerMapOnUserButton.frame.width/2
        showMyTeamButton.layer.cornerRadius = 5
        warningDistanceView.layer.cornerRadius = 5
        centerMapOnUserButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.stopTimer()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func zoomInButtonTapped(_ sender: UIButton) {
        
        if scale > 0.025 {
            
            scale /= 2
            let region = presenter.makeRegion(center: mapView.centerCoordinate, scale: scale)
            mapView.setRegion(region, animated: true)
            
        } else {
            
            scale = 0
            let region = presenter.makeRegion(regionRadius: 300, for: mapView.centerCoordinate)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    @IBAction func zoomOutButtonTapped(_ sender: UIButton) {
        
        if scale == 0 {
            
            scale = 0.025
            
        } else {
            
            scale += scale
            
        }
        
        let region = presenter.makeRegion(center: mapView.centerCoordinate, scale: scale)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func centerMapOnUserButtonTapped(_ sender: UIButton) {
        scale = 0
        presenter.showRegion()
    }
    
    @IBAction func showMyTeamButtonTapped(_ sender: UIButton) {
        presenter.showMyTeam()
    }
    
    //MARK: - Class methods
    
    //Set colors for screen mode
    private func setupButtonsaAndViewAppereance() {
        
        switch self.traitCollection.userInterfaceStyle {
        
        case .light:
            zoomInButton.setButtonColor(textColor: .black, backgroundColor: #colorLiteral(red: 0.8500000238, green: 0.8500000238, blue: 0.8500000238, alpha: 0.75))
            zoomOutButton.setButtonColor(textColor: .black, backgroundColor: #colorLiteral(red: 0.8500000238, green: 0.8500000238, blue: 0.8500000238, alpha: 0.75))
            centerMapOnUserButton.setButtonColor(textColor: .black, backgroundColor: #colorLiteral(red: 0.8500000238, green: 0.8500000238, blue: 0.8500000238, alpha: 0.75))
            warningDistanceView.backgroundColor = #colorLiteral(red: 0.8500000238, green: 0.8500000238, blue: 0.8500000238, alpha: 0.75)
            warningDistanceLabel.textColor = .black
        case .dark:
            zoomInButton.setButtonColor(textColor: .white, backgroundColor: #colorLiteral(red: 0.1540525854, green: 0.1540525854, blue: 0.1540525854, alpha: 0.75))
            zoomOutButton.setButtonColor(textColor: .white, backgroundColor: #colorLiteral(red: 0.150000006, green: 0.150000006, blue: 0.150000006, alpha: 0.75))
            centerMapOnUserButton.setButtonColor(textColor: .white, backgroundColor: #colorLiteral(red: 0.150000006, green: 0.150000006, blue: 0.150000006, alpha: 0.75))
            warningDistanceView.backgroundColor = #colorLiteral(red: 0.150000006, green: 0.150000006, blue: 0.150000006, alpha: 0.75)
            warningDistanceLabel.textColor = .white
        default:
            break
        }
        
    }
    
    //Setup appdelegate
    private func setupAppDelegate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
    }
    
    //MapView Setup
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    //Removing old annotations
    private func removeAppleMapOverlays() {
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
        let annotations = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        self.mapView.removeAnnotations(annotations)
    }
    
}

//MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    func setAnnotations(_ annotations: [MonsterAnnotation]) {
        removeAppleMapOverlays()
        mapView.addAnnotations(annotations)
    }
    
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
    
    //Animated disapearing distance warning view
    private func animateWarningDistanceViewDisappear() {
        
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.warningDistanceView.alpha = 0
                       },
                       completion: nil)
    }
    
    //Animating appearing distance warning view
    func animateWarningDistanceViewAppear () {
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        self?.warningDistanceView.alpha = 1
                       },
                       completion: {[weak self] isComplete in
                        guard isComplete else { return }
                        self?.animateWarningDistanceViewDisappear()
                       })
    }
}

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MonsterAnnotation else { return nil }
        
        let identifier = "MonsterAnnotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView()
        annotationView.image = UIImage(named: annotation.imageName)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MonsterAnnotation else { return }
        presenter.showMonster(annotation.monster)
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        presenter.mapViewIsLoaded = true
    }
}

//MARK: - AppDelegate protocol

extension MapViewController: AppDelegateProtocol {
    
    func appDidBecomeActive() {
        setupButtonsaAndViewAppereance()
    }
    
}
