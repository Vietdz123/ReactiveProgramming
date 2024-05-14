//
//  IntentHandler.swift
//  WidgetIntentIOS16
//
//  Created by Duc on 07/05/2024.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

// MARK: - Rect Lock
extension IntentHandler: LockRectangleConfigurationAppIntentIOS16IntentHandling {
    func resolveName(for intent: LockRectangleConfigurationAppIntentIOS16Intent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
    }
    
    func provideNameOptionsCollection(for intent: LockRectangleConfigurationAppIntentIOS16Intent, searchTerm: String?, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        let names =  CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .rectangle)
        completion(INObjectCollection(items: names as [NSString] ), nil)
    }
}


// MARK: - Square Lock
extension IntentHandler: LockSquareConfigurationAppIntentIOS16IntentHandling {
    func resolveName(for intent: LockSquareConfigurationAppIntentIOS16Intent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
    }
    
    func provideNameOptionsCollection(for intent: LockSquareConfigurationAppIntentIOS16Intent, searchTerm: String?, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        let names =  CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .square)
        print("DEBUG: \(names) qqqq")
        completion(INObjectCollection(items: names as [NSString] ), nil)
    }
    
 
}

// MARK: - Inline Lock
extension IntentHandler: LockInlineConfigurationAppIntentIOS16IntentHandling {
    func resolveName(for intent: LockInlineConfigurationAppIntentIOS16Intent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
    }
    
    func provideNameOptionsCollection(for intent: LockInlineConfigurationAppIntentIOS16Intent, searchTerm: String?, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        let names =  CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .inline)
        completion(INObjectCollection(items: names as [NSString] ), nil)
    }
    

    
 
}
