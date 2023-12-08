//
//  ItemExtension.swift
//  WallPaper-CoreData
//
//  Created by MAC on 13/11/2023.
//

import SwiftUI

extension ItemHome {
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }
    
    public var unwrappedFamily: String {
        family ?? "Unknown name"
    }
    
    public var unwrappedRountineType: String {
        routine_type ?? "Unknown name"
    }
    
    public var absolutepath: URL? {
        relativePath?.appendingPathComponent(unwrappedName)
    }
    

    
    
}

extension ItemHome {
    
    private var relativePath: URL? {
        FileService.shared.relativePath
    }
    
}
