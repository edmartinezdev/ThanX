import UIKit
import Flutter
import GoogleMaps
import Photos
import AVFoundation
import MessageUI
import CoreLocation
import CocoaLumberjack

struct AppConstant {
    static let channelName: String = "com.app.ThankXDriver"
    static let googleMapKey: String = "AIzaSyAY4kxXmqOibojTWCVszT5dhUZZoKl1QrE"
    static let socketBaseUrl: String = "https://thankx.admindd.com"
    //static let socketBaseUrl: String = "http://35.225.98.185"
    //static let socketBaseUrl: String = "http://202.131.117.92:7046"
    static let socketNameSpace: String = "/v3/thankxTracking"
    static let isLogEnable: Bool = true
    static let isFileLoggingEnable: Bool = true
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var appChannel: FlutterMethodChannel? = nil
    var flutterResult: FlutterResult? = nil
    
    //MARK:- For Order Related Variable
    private(set) var orderId: String? = nil
    private(set) var customerId: String? = nil
    private(set) var driverId: String? = nil
    var lastCoordinate: CLLocationCoordinate2D? = nil
    var lastLocationUpdateTime = Date().timeIntervalSince1970
    var timer: Timer? = nil
    
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.createChannelAndRegisterHandlerForCommunication()
        GMSServices.provideAPIKey(AppConstant.googleMapKey)
        GeneratedPluginRegistrant.register(with: self)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            DDLog.add(DDOSLogger.sharedInstance)
        }
        if (AppConstant.isFileLoggingEnable) {
            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            DDLog.add(fileLogger)
        }
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.darkContent, animated: true)
        if #available(iOS 13, *) {
            application.statusBarStyle = .darkContent
        } else {
            application.statusBarStyle = .lightContent
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    func createChannelAndRegisterHandlerForCommunication() {
        
        guard let contoller: FlutterBinaryMessenger = self.window.rootViewController as? FlutterBinaryMessenger else { return }

        self.appChannel = FlutterMethodChannel.init(name: AppConstant.channelName, binaryMessenger: contoller)
        appChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let `self` = self else { return }
        
            if (call.method == "updateStatusBarColor") {
                if let args = call.arguments as? [Int], args.count >= 3 {
                    if let statusBar = UIApplication.shared.statusBarUIView {
                        let color = UIColor.init(red: CGFloat(args[0]) / 255.0, green: CGFloat(args[1]) / 255.0, blue: CGFloat(args[2]) / 255.0, alpha: 1.0)
                        statusBar.backgroundColor = color
                    }
                }
                result(nil)
            } else if (call.method == "checkForPhotoAccess") {
                self.checkForPhotoPermission(result: result)
            } else if (call.method == "checkForCameraAccess") {
                self.checkForCameraPermission(result: result)
            } else if (call.method == "checkForMailSend") {
                result(MFMailComposeViewController.canSendMail())
            } else if (call.method == "checkLocationPermission") {
                self.checkLocationPermission(result: result)
            } else if (call.method == "clearNotification") {
                UIApplication.shared.applicationIconBadgeNumber = 0
                result("clearNotification")
            } else if (call.method == "startLocationService") {
                "💣💥💣💥💣💥💣💥💣💥 Start Location Update 💣💥💣💥💣💥💣💥💣💥".performLog()
                if let dict = call.arguments as? NSDictionary {
                    if let oderId = dict.object(forKey: "orderId") as? String {
                        self.orderId = oderId
                    }
                    if let cusId = dict.object(forKey: "customerId") as? String {
                        self.customerId = cusId
                    }
                    if let diverId = dict.object(forKey: "driverId") as? String {
                        self.driverId = diverId
                    }
                    self.allowContinousLocationUpdate()
                }
                "💣💥💣💥💣💥💣💥💣💥 Start Location Update 💣💥💣💥💣💥💣💥💣💥".performLog()
                
            }
            else if (call.method == "stopLocationService") {
                self.stopContinousLocationUpdate()
            }
            else {
                result(FlutterMethodNotImplemented)
            }

        }
    }
}

//MARK:- Permission
extension AppDelegate {
    //MARK:- Open Setting
    private func openSettingPage(result: @escaping FlutterResult) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        result(true)
    }

    //MARK:- Photo Permission
    private func checkForPhotoPermission(result: @escaping FlutterResult) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                let isAllowed = !((status == PHAuthorizationStatus.restricted) || (status == PHAuthorizationStatus.denied))
                result(isAllowed)
            }
        }
        else if (status == PHAuthorizationStatus.restricted) || (status == PHAuthorizationStatus.denied) {
            result(false)
        } else {
            result(true)
        }
    }

    //MARK: - Camera Permission
    private func checkForCameraPermission(result: @escaping FlutterResult) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if cameraAuthorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                guard granted else {
                    result(false)
                    return
                }
                result(true)
            }
        }
        else if (cameraAuthorizationStatus == .denied) || (cameraAuthorizationStatus == .restricted) {
            result(false)
        } else {
            result(true)
        }
    }
}


///MARK:- Tracking
extension AppDelegate {
    //MARK: - Get Location Permission Status
    internal func checkLocationPermission(result: @escaping FlutterResult) {
        
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.notDetermined) {
            
            AppLocationManager.getLocation(isAskForContinousLocation: false, completionHandler: { (coordinate, state) in
                if let _ = coordinate {
                    result(true)
                } else {
                    result((state == LocationState.authorizedAlways) || state == LocationState.authorizedWhenInUse)
                }
            })
        } else if (status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied) {
            result(false)
        } else if (status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse) {
            result(true)
        }
    }
    
    //MARK: - Allow Continous Location Update
    internal func allowContinousLocationUpdate() {
        AppLocationManager.getLocation(isAskForContinousLocation: true, completionHandler: { (coordinate, state) in
            if let coordinate = coordinate {
                "New Location  latitude: \(coordinate.latitude) longitude: \(coordinate.longitude)".performLog()
                self.lastCoordinate = coordinate
            }
            "Location error: \(state)".performLog()
        })
        self.timer?.invalidate() // Invalidate past timer
        self.statTimerAtFixedInterval()
    }
    
    //MARK: - Stop Continous Location Update
    internal func stopContinousLocationUpdate() {
        "💣💥💣💥💣💥💣💥💣💥 Stop Location Update 💣💥💣💥💣💥💣💥💣💥".performLog()
        AppLocationManager.stopLocationUpdating()
        self.lastCoordinate = nil
        self.timer?.invalidate()
        self.timer = nil
    }

    @objc private func statTimerAtFixedInterval() {
            if ((Date().timeIntervalSince1970 - lastLocationUpdateTime) > 3.0) {
                lastLocationUpdateTime = Date().timeIntervalSince1970
                AppSocketManager.shared.sendDriverLocationToSocket()
            }
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.statTimerAtFixedInterval), userInfo: nil, repeats: false)
        }
}


extension String {
    func performLog() {
        if AppConstant.isFileLoggingEnable {
            DDLogError("Thakx Driver :\(self)")
        } else if AppConstant.isLogEnable {
            print("Thakx Driver |- \(self)")
        }
    }
}
