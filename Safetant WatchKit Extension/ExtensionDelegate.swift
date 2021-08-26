//
//  ExtensionDelegate.swift
//  Safetant WatchKit Extension
//
//  Created by Yusuf Umar Hanafi on 16/08/21.
//

import WatchKit
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    

    private let store = HKHealthStore()
    private let falls = HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen)!
    private var lastAnchor: HKQueryAnchor?
    

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        requestPermissionToDetectFalls()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    private func requestPermissionToDetectFalls() {
            store.requestAuthorization(toShare: nil, read: [falls]) { success, error in
                print("Finished requesting authorization", success, error)
                self.observeFalls()
            }
        }
        
        private func observeFalls() {
            let query = HKObserverQuery(sampleType: falls, predicate: nil) { query, handler, error in
                self.checkNewFalls()
                handler()
            }
            store.execute(query)
        }
        
        private func checkNewFalls() {
            let query = HKAnchoredObjectQuery(type: falls, predicate: nil, anchor: lastAnchor, limit: HKObjectQueryNoLimit) { query, sample, deleted, anchor, error in
                defer { self.lastAnchor = anchor }
                guard self.lastAnchor != nil else { return }
                guard sample?.isEmpty == false else { return }
                self.presentFallAlert()
            }
            store.execute(query)
        }
        
        private func presentFallAlert() {
            DispatchQueue.main.async {
                WKExtension.shared().rootInterfaceController?.presentController(withName: "Fall Detected", context:  WKExtension.shared().rootInterfaceController?.contentSafeAreaInsets)


//                let okAction = WKAlertAction(title: "OK",
//                                             style: WKAlertActionStyle.default) { () -> Void in
//                    print("default tapped")
//                       }
//
//                       let cancelAction = WKAlertAction(title: "Cancel",
//                           style: WKAlertActionStyle.cancel) { () -> Void in
//                        print("cancel tapped")
//                       }
//
//                       let abortAction = WKAlertAction(title: "Abort",
//                           style: WKAlertActionStyle.destructive) { () -> Void in
//                        print("abort tapped")
//                       }
//                WKExtension.shared().rootInterfaceController?.presentAlert(withTitle: "Title", message: "message", preferredStyle: WKAlertControllerStyle.alert, actions: [okAction, cancelAction, abortAction])

                
            
            }
        }

}
