//
//  ToggleButtonIntent.swift
//  WallPaper
//
//  Created by MAC on 23/10/2023.
//

import SwiftUI
import WidgetKit
import AppIntents

struct ChangeBackgroundIntent: AppIntent {

    init() {
        
    }
    
    static var title: LocalizedStringResource = "ButtonAppIntent"
    
    @Parameter(title: "Task ID")
    var id_name: String
    
    init(id_name: String) {
        self.id_name = id_name
    }
    
    func perform() async throws -> some IntentResult {
        
        WidgetViewModel.shared.dict[id_name]?.updateCurrentIndex()
        return .result()
    }
    
}
