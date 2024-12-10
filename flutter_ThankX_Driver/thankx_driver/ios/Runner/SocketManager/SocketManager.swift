//
//  SocketManager.swift
//  Runner
//
//  Created by agileimac-1 on 25/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import CoreLocation
import SocketIO
import CocoaLumberjack

enum SocketEventList: String {
    case driverJoin = "driver-join"
    case updateDriverLocation = "update-driver-location"
}


class AppSocketManager: NSObject {
    static let shared: AppSocketManager = AppSocketManager()
    
    private var manager: SocketManager! = nil
    internal private(set) var socketClient: SocketIOClient? = nil
    
    override init() {
        super.init()
        guard let chatServerURL = URL(string: AppConstant.socketBaseUrl) else { return }
        manager = SocketManager(socketURL: chatServerURL, config: [.log(false), .compress, SocketIOClientOption.reconnects(true)])
    }
    
    internal func setupSocketClientForConnect() -> Void {
        
        if let socketClient = self.socketClient, socketClient.status == SocketIOStatus.connected {
            return
        }
        
        if self.socketClient == nil {
            self.socketClient = manager.socket(forNamespace: AppConstant.socketNameSpace)
            self.registerChatServerHandler()
        }
        self.socketClient?.connect()
    }
    
    func registerChatServerHandler() {
        
        guard let socketClient = self.socketClient else { return }
        
        socketClient.on(clientEvent: .connect, callback: { (_, _) in
            "Socket Connected".performLog()
            self.userJoin()
        })
        
        socketClient.on(clientEvent: .disconnect, callback: { (_, _) in
            "Socket Disconnect".performLog()
        })
        
    }

    
    func userJoin() {
        
        guard let socketClient = self.socketClient else { return }
        guard socketClient.status == SocketIOStatus.connected else { return }
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        var dict: [String: Any] = [:]
        dict["driverId"] = appdelegate.driverId ?? ""
        dict["socketId"] = socketClient.sid
        
        socketClient.emitWithAck(SocketEventList.driverJoin.rawValue, dict).timingOut(after: 0, callback: {[weak self] data in
            guard let _ = self else { return }
            "Response userJoin :: \(data)".performLog()
        })
    }
    
    func logDriverLocationInFile(withCoordinate coord: CLLocationCoordinate2D) {
        "Time Stamp :: \(Date().timeIntervalSince1970) Cord :: latitude -> \(coord.latitude) longitude -> \(coord.longitude)".performLog()
    }
    
    func sendDriverLocationToSocket() {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        guard let coord = appdelegate.lastCoordinate else { return }
        guard let socketClient = self.socketClient else {
            self.setupSocketClientForConnect()
            return
        }
        guard socketClient.status == SocketIOStatus.connected else {
            socketClient.connect()
            return
        }
        
        var dict: [String: Any] = [:]
        dict["orderId"] = appdelegate.orderId
        dict["customerId"] = appdelegate.customerId
        dict["driverId"] = appdelegate.driverId
        dict["latitude"] = coord.latitude
        dict["longitude"] = coord.longitude

        "Time Stamp :: \(Date().timeIntervalSince1970)  Socket Emit Data :: dict -> \(dict)".performLog()
        "Socket Event : \(SocketEventList.updateDriverLocation.rawValue) data :: \(dict)".performLog()
        socketClient.emitWithAck(SocketEventList.updateDriverLocation.rawValue, dict).timingOut(after: 0, callback: {[weak self] data in
            guard let _ = self else { return }
            "Time Stamp :: \(Date().timeIntervalSince1970)  Response Location Update :: \(data)".performLog()
        })
    }
    
}
