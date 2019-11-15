//
//  ViewController.swift
//  WeatherApp
//
//  Created by Roshan on 08/10/19.
//  Copyright © 2019 Roshan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var ConditionImage: UIImageView!
    @IBOutlet weak var ConditionLabel: UILabel!
    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var BackgroundView: UIView!
    
    let GradientLayer = CAGradientLayer()
    let APIKey = "868da1e72e37c4ef229fadbe8a5080b5"
    var lat = 13.06
    var lon = 80.23
    var ActivityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundView.layer.addSublayer(GradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        ActivityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        ActivityIndicator.backgroundColor=UIColor.black
        view.addSubview(ActivityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        ActivityIndicator.startAnimating()
        
        if(CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBg()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&units=metric").responseJSON{
            response in
            self.ActivityIndicator.stopAnimating()
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.Location.text = jsonResponse["name"].stringValue
                self.ConditionImage.image = UIImage(named: iconName)
                self.ConditionLabel.text = jsonWeather["main"].stringValue
                self.Temperature.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.Day.text = dateFormatter.string(from:date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n")
                {
                    self.setGrayGradientBg()
                }
                else{
                    self.setBlueGradientBg()
                    
                }
                
                
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
     
    func setGrayGradientBg(){
        let topcolor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomcolor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        GradientLayer.frame = view.bounds
        GradientLayer.colors = [topcolor,bottomcolor]
    }
    
    func setBlueGradientBg(){
        let topcolor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomcolor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        GradientLayer.frame = view.bounds
        GradientLayer.colors = [topcolor,bottomcolor]
    }


}

