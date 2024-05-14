//
//  LockViewModel.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI


class RectangleViewModel {
    
    var currentCheckImageRoutine: [Int] = Array(repeating: 0, count: 7)
    var category: CategoryLock?

    
    func loadData(category: CategoryLock?) {
        guard let category = category else { return }
        self.category = category
    }
}


