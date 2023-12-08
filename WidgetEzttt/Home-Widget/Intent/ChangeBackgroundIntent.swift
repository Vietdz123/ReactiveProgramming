//
//  ToggleButtonIntent.swift
//  WallPaper
//
//  Created by MAC on 23/10/2023.
//

import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation

struct ChangeBackgroundIntent: AppIntent {
    

    init() {
        
    }
    
    static var title: LocalizedStringResource = "ButtonAppIntent"
    
    @Parameter(title: "Task ID")
    var id_name: String
    
    @Parameter(title: "Task ID")
    var is_rect: Bool
    
    init(id_name: String, is_rect: Bool) {
        self.id_name = id_name
        self.is_rect = is_rect
    }
    
    func perform() async throws -> some IntentResult {
        
        let cate = CoreDataService.shared.getCategory(name: id_name)
        cate?.updateCurrentIndex(isRect: is_rect)
        
        return .result()
    }
    
}
