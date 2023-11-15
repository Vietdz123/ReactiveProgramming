//
//  DialogUpdateIOS.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import SwiftUI

struct DialogUpdateIOS: View {
    
    @Binding var show : Bool
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark)).ignoresSafeArea()
            
            VStack(spacing : 0){
                Text("Update Needed".toLocalize())
                    .mfont(15, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .padding(.top, 16)
                
                Text("To access this feature, please update\nyour device to iOS 17.".toLocalize())
                    .mfont(13, .regular, line : 2)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, 32) .padding(.top, 8)
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 295, height: 1)
                  .background(.white) .padding(.top, 16)
                  .opacity(0.7)
                
                Button(action: {
                    show.toggle()
                }, label: {
                    Text("OK".toLocalize())
                        .mfont(15, .regular)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.15, green: 0.7, blue: 1))
                      .frame(maxWidth: .infinity)
                      .contentShape(Rectangle())
                      .padding(.top, 16)
                      .padding(.bottom, 20)
                })
                
               
            }.background(
                Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7)
            
            )
            .cornerRadius(16)
            .padding(.horizontal, 40)
            
        }
        
       
    }
}
