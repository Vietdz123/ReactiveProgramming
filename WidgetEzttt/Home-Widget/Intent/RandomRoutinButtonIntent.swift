//
//  RandomRoutinButtonIntent.swift
//  WallPaper
//
//  Created by MAC on 31/10/2023.
//

import SwiftUI
import WidgetKit
import AppIntents

struct RandomRoutinButtonIntent: AppIntent {

    init() {
        
    }
    
    static var title: LocalizedStringResource = "RandomRoutinButtonIntent"
    
    @Parameter(title: "Name ID")
    var id_name: String
    
    @Parameter(title: "Day ID")
    var id_day: Int
    
    init(id_day: Int, id_name: String) {
        self.id_day = id_day
        self.id_name = id_name
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue {
        print("DEBUG: goto perform RandomRoutinButtonIntent")

        guard let category = CoreDataService.shared.getCategory(name: id_name) else {return .result()}
        let numberCheckedImages = category.numberCheckedImages
        
        if category.isCheckedRoutine.count < id_day {
            return .result()
        }
        
        if !category.isCheckedRoutine[id_day] {
            
            category.isCheckedRoutine[id_day].toggle()
            CoreDataService.shared.saveContext()
            
            return .result()
        }
        
        if category.currentCheckImageRoutine[id_day] < numberCheckedImages - 1 {
            category.currentCheckImageRoutine[id_day] += 1
        } else {
            category.isCheckedRoutine[id_day].toggle()
            category.currentCheckImageRoutine[id_day] = 0
        }
        CoreDataService.shared.saveContext()

        return .result()
    }
    
}
