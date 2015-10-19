import UIKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate, RMMapViewDelegate {
    
    let kAccessToken = "sk.eyJ1IjoidG9uaXN1dGVyIiwiYSI6ImNpZmptbnhxYTAxMGR0ZWx4ZjFhejdkMzEifQ.4HxuC8B4MW_slik23J9NqQ"
    let kMapID = "tonisuter.cife1ku4000gmtaknuv49tvwc"
    let kHsrCoordinate = CLLocationCoordinate2DMake(47.223252, 8.817011)
    
    let locationManager = CLLocationManager()
    var mapView: RMMapView!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var listCoordination = [Double]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RMConfiguration.sharedInstance().accessToken = kAccessToken
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


        let tileSource: RMMapboxSource = RMMapboxSource(mapID: kMapID)
        mapView = RMMapView(frame: view.bounds, andTilesource: tileSource)
        mapView.zoom = 17
        mapView.userTrackingMode = RMUserTrackingModeFollow
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        setSavedMarkers()
        
    }
    
    func setSavedMarkers(){
        
        listCoordination = defaults.objectForKey("SavedMarkers") as? [Double] ?? [Double]()
        
        
        for var index = 0; index < listCoordination.count; ++index {
            setMarker(listCoordination[index], longitude: listCoordination[++index], load: false)
        }
        
    
    }
    
    
    @IBAction func pressedSetMarker(sender: AnyObject)
    {
        

        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Marker hinzufügen",
            message: "Bitte hier die Koordinaten eintragen:",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Latitude"
                textField.keyboardType = UIKeyboardType.DecimalPad
        })
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Longitude"
                textField.keyboardType = UIKeyboardType.DecimalPad
        })
        
        let action = UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    
                    if let latitude = theTextFields[0].text, longitude = theTextFields[1].text{
                        let Latitude: Double = (latitude as NSString).doubleValue
                        let Longitude: Double = (longitude as NSString).doubleValue
                        self.setMarker(Latitude, longitude: Longitude, load: true)
                    }
                    
                }
            })
        
        alertController?.addAction(action)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    
    }
    
    func setMarker(latitude: Double, longitude: Double, load: Bool){
        
        let cordination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
        
        if load{
            
            listCoordination.append(latitude)
            listCoordination.append(longitude)
            
            saveXML()
            
        }
        
        let annotation: RMPointAnnotation = RMPointAnnotation(mapView: mapView, coordinate: cordination, andTitle: "Posten")
        mapView.addAnnotation(annotation)
        
    }
    
    func saveXML(){
    
        defaults.setObject(listCoordination, forKey: "SavedMarkers")
        defaults.synchronize()
        
    }

    @IBAction func pressedLogSolution(sender: AnyObject) {
        
        var json = [String:String]()
        json["task"] = "Schatzkarte"
        let solutionLogger = SolutionLogger(viewController: self)
        
        let test = listCoordination
        
        json["points"] = test.description
        
        
        let solutionStr = solutionLogger.JSONStringify(json)
        solutionLogger.logSolution(solutionStr)
    }
    
    
    @IBAction func pressedLocation(sender: AnyObject) {
        
        let coordination = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        mapView.centerCoordinate = coordination;
        mapView.zoom = 17
    }
    
    @IBAction func pressedHSRLocation(sender: AnyObject) {
        
        mapView.centerCoordinate = kHsrCoordinate;
        mapView.zoom = 17
    }
 
    @IBAction func pressedDeleteMarkers(sender: AnyObject) {
        
        listCoordination.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        saveXML()
        
    }
}
