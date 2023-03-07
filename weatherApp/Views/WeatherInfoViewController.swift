//
//  WeatherInfoViewController.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 2/25/23.
//

import UIKit
import CoreLocation

class WeatherInfoViewController: UIViewController {

  //MARK: - IBOutlets

  /*
   I have used UIKit Interface builder here for UI becuase of time constraints. I mostly prefer building UI programatically using constraint layout.
   */

  @IBOutlet weak var search: UITextField! {
    didSet {
      search.delegate = self
    }
  }
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var cityName: UILabel!
  @IBOutlet weak var currentWeatherImageView: UIImageView!
  @IBOutlet weak var temperature: UILabel!
  @IBOutlet weak var minTemperature: UILabel!
  @IBOutlet weak var maxTemperature: UILabel!

  //MARK: - Private variables
  private var weatherInfoViewModel = WeatherInfoViewModel()
  private var userDefaults = UserDefaults.standard

  lazy var locationManager: CLLocationManager = {
    var locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.activityType = . automotiveNavigation
    locationManager.distanceFilter = 10.0  // Movement threshold for new events
    return locationManager
  }()

  

  //MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard weatherInfoViewModel.isLocationAccessEnabled() else {
      guard let prevCityName = userDefaults.string(forKey: Constants.previousCityName) else { return }
      weatherInfoViewModel.fetchWeatherInfo(for: prevCityName) { [weak self] result in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.setupView()
        }
      }
      return
    }
  }

  //MARK: - IBActions

  @IBAction func searchButtonPressed(_ sender: Any) {

    guard let cityName = search.text?.lowercased(), !cityName.isEmpty else {
      handleNoSearchResult(with: Constants.noCityMessage)
      return
    }
    userDefaults.set(cityName, forKey: Constants.previousCityName)

    weatherInfoViewModel.fetchWeatherInfo(for: cityName) { [weak self] result in
      guard let self = self else { return }
      DispatchQueue.main.async {
        result ? self.setupView() : self.handleNoSearchResult(with: self.weatherInfoViewModel.errorInfoString)
      }
    }
    search.endEditing(true)
  }

  //MARK: - Private methods

  private func setupUI() {
    //Search Textfield customization
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: search.frame.height - 1, width: search.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.white.cgColor
    search.borderStyle = UITextField.BorderStyle.none
    search.layer.addSublayer(bottomLine)
    search.attributedPlaceholder = NSAttributedString(
      string: Constants.cityName,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
    )

    backgroundImageView.image = UIImage(named: Constants.backgroundImage)
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.layer.opacity = 0.9
  }

  private func setupView() {
    currentWeatherImageView.image = UIImage(data: weatherInfoViewModel.weatherIconData)
    cityName.text = weatherInfoViewModel.cityNameString
    temperature.text = weatherInfoViewModel.temperatureString
    minTemperature.text = weatherInfoViewModel.minTemperatureString
    maxTemperature.text = weatherInfoViewModel.maxTemperatureString
  }

  private func handleNoSearchResult(with message: String) {
    let alert = UIAlertController(title:  Constants.error,
                                  message: message,
                                  preferredStyle: .alert)
    let alertActionOkButton = UIAlertAction(title: Constants.ok, style: .default)
    alert.addAction(alertActionOkButton)
    self.present(alert, animated: true)
  }
}

//MARK: - UITextFieldDelegate

extension WeatherInfoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    search.endEditing(true)
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    search.text != "" ? true : false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    search.text = ""
  }
}

//MARK: - CLLocationManagerDelegate

extension WeatherInfoViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    locationManager.delegate = nil
    guard let location = locations.first else { return }
    weatherInfoViewModel.getWeatherInfoForCurrentLocation(coordinates: location.coordinate) { [weak self] _ in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.setupView()
      }
    }
  }
}

