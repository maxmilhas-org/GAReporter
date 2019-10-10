//
//  GAReporter.swift
//  GAReporter
//
//  Copyright © 2018年 dengli. All rights reserved.
//

open class GAReporter {
    
    // MARK: - Properties
    private static var campaignParameters: [AnyHashable : Any]?
    
    open class func configure(_ trackID: String, verbose: Bool) {
        guard let gai = GAI.sharedInstance() else {
            print("Google Analytics not configured correctly")
            return
        }
        gai.defaultTracker = gai.tracker(withTrackingId: trackID)
        if verbose {
            gai.logger.logLevel = .verbose
        }
    }
    
    open class func sendScreenView(_ screen: String, customDimension: [String: String]? = nil) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screen)
        
        var customParameters: [AnyHashable: Any] = [:]
        if let customDimension = customDimension {
            customParameters = customParameters.merging(customDimension) { (_, new) in new }
        }
        if let campaignParameters = campaignParameters {
            tracker?.allowIDFACollection = true
            customParameters = customParameters.merging(campaignParameters) { (_, new) in new }
        }
        
        let builder = GAIDictionaryBuilder.createScreenView()
        if !customParameters.isEmpty {
            builder?.setAll(customParameters)
        }
        
        if let screenParam = builder?.build() as? [AnyHashable: Any] {
            tracker?.send(screenParam)
            tracker?.allowIDFACollection = false
            campaignParameters = nil
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
    
    open class func trackCampaign(urlString: String) {
        let builder = GAIDictionaryBuilder()
        builder.setCampaignParametersFromUrl(urlString)
        guard let dict = builder.build() as? [AnyHashable : Any] else {
            print("fail to create a builder at trackCampaign with urlString: \(urlString)")
            return
        }
        if let screenDict = GAIDictionaryBuilder.createScreenView()?.setAll(dict)?.build() as? [AnyHashable: Any] {
            campaignParameters = screenDict
        }
    }
}
