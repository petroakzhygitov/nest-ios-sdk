//
//  ViewController.swift
//  NestSDKDemoSwift
//
//  Created by Petro Akzhygitov on 31/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

import UIKit
import NestSDK

class ViewController: UIViewController, NestSDKConnectWithNestButtonDelegate {

    @IBOutlet weak var connectWithNestButton: NestSDKConnectWithNestButton!
    @IBOutlet weak var nestInfoTextView: UITextView!

    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []

    var structuresObserverHandle: NestSDKObserverHandle = 0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Check authorization
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            observeStructures()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // Clean up
        removeObservers()
    }

    func observeStructures() {
        // Clean up previous observers
        removeObservers()

        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in

            self.logMessage("Structures updated!")

            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()

            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                self.logMessage("Found structure: \(structure.name)!")

                self.observeThermostatsWithinStructure(structure)
                self.observeSmokeCOAlarmsWithinStructure(structure)
                self.observeCamerasWithinStructure(structure)
            }
        })
    }

    func observeThermostatsWithinStructure(structure: NestSDKStructure) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in

                if (error != nil) {
                    self.logMessage("Error observing thermostat: \(error)")

                } else {
                    self.logMessage("Thermostat \(thermostat.name) updated! Current temperature in C: \(thermostat.ambientTemperatureC)")
                }
            })

            deviceObserverHandles.append(handle)
        }
    }

    func observeSmokeCOAlarmsWithinStructure(structure: NestSDKStructure) {
        for smokeCOAlarmId in structure.smokeCoAlarms as! [String] {
            let handle = dataManager.observeSmokeCOAlarmWithId(smokeCOAlarmId, block: {
                smokeCOAlarm, error in

                if (error != nil) {
                    self.logMessage("Error observing smokeCOAlarm: \(error)")

                } else {
                    self.logMessage("smokeCOAlarm \(smokeCOAlarm.name) updated! Current state: \(smokeCOAlarm.coAlarmState.rawValue)")
                }
            })

            deviceObserverHandles.append(handle)
        }
    }

    func observeCamerasWithinStructure(structure: NestSDKStructure) {
        for cameraId in structure.cameras as! [String] {
            let handle = dataManager.observeCameraWithId(cameraId, block: {
                camera, error in

                if (error != nil) {
                    self.logMessage("Error observing camera: \(error)")

                } else {
                    self.logMessage("Camera \(camera.name) updated! Streaming state: \(camera.isStreaming)")
                }
            })

            deviceObserverHandles.append(handle)
        }
    }

    func removeObservers() {
        removeDevicesObservers();
        removeStructuresObservers();
    }

    func removeDevicesObservers() {
        for (_, handle) in deviceObserverHandles.enumerate() {
            dataManager.removeObserverWithHandle(handle);
        }

        deviceObserverHandles.removeAll()
    }

    func removeStructuresObservers() {
        dataManager.removeObserverWithHandle(structuresObserverHandle)
    }

    func logMessage(message: String) {
        nestInfoTextView.text = nestInfoTextView.text + "\(message)\n"
    }

    // MARK: NestSDKConnectWithNestButtonDelegate

    func connectWithNestButton(connectWithNestButton: NestSDKConnectWithNestButton!, didAuthorizeWithResult result: NestSDKAuthorizationManagerAuthorizationResult!, error: NSError!) {
        if (error != nil) {
            print("Process error: \(error)")

        } else if (result.isCancelled) {
            print("Cancelled")

        } else {
            print("Authorized!")

            observeStructures()
        }
    }

    func connectWithNestButtonDidUnauthorize(connectWithNestButton: NestSDKConnectWithNestButton!) {
        removeObservers()
    }
}

