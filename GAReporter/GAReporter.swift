//
//  GAReporter.swift
//  GAReporter
//
//  Copyright © 2018年 dengli. All rights reserved.
//

open class GAReporter {
    
    open class func configure(_ trackID: String, verbose: Bool) {
        guard let gai = GAI.sharedInstance() else {
            print("Google Analytics not configured correctly")
            return
        }
        gai.defaultTracker = gai.tracker(withTrackingId: trackID)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        gai.dispatchInterval = 20
        if verbose {
            gai.logger.logLevel = .verbose
        }
        gai.defaultTracker.allowIDFACollection = true
    }
    
    open class func sendScreenView(_ screen: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screen)
        if let screenDict = GAIDictionaryBuilder.createScreenView().build() as? [AnyHashable: Any] {
            tracker?.send(screenDict)
        }
    }
    
    open class func sendScreenView(_ screen: String, customDimension: [String: String]) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screen)
        if let screenDict = GAIDictionaryBuilder.createScreenView()?.setAll(customDimension)?.build() as? [AnyHashable: Any]  {
            tracker?.send(screenDict)
        }
    }
    
    open class func sendEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        if let eventDict = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: value).build() as? [AnyHashable: Any] {
            tracker?.send(eventDict)
        }
    }
    
    open class func get(_ parameterName: String) -> String? {
        let tracker = GAI.sharedInstance().defaultTracker
        return tracker?.get(parameterName)
    }
    
    open class func set(_ parameterName: String, value: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(parameterName, value: value)
    }
}
