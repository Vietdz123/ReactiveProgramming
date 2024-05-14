//
//  PlayButtonIntent.swift
//  WallPaper-CoreData
//
//  Created by MAC on 17/11/2023.
//


import WidgetKit
import AppIntents
import SwiftUI

struct PlayButtonIntent: AppIntent {

    init() {
        
    }
    
    static var title: LocalizedStringResource = "PlayButtonIntent"
    
    @Parameter(title: "Name ID")
    var id_name: String
    
    
    init(id_name: String) {
        self.id_name = id_name
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue {
        
//        GifWidgetViewModel.shared.playGif.toggle()
        return .result()
    }
    
}

