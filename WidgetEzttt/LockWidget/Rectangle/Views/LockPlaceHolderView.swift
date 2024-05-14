//
//  File.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI


struct LockPlaceHolderView: View {
    
    var size: CGSize
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4)
                .cornerRadius(16)
                
            Image("defaultLock")
                .resizable()
                .renderingMode(.original)
                .frame(width: 40, height: 40)
            
            
        }
    }
}

