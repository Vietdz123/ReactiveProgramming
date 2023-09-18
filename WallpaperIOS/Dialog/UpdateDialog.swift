//
//  UpdateDialog.swift
//  WallpaperIOS
//
//  Created by Mac on 26/06/2023.
//

import SwiftUI

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        UpdateDialog(show: .constant(true))
    }
}

struct UpdateDialog: View {
   
    @Binding var show : Bool
   
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            VStack(spacing : 0){
                Text("New version 1.0.6")
                    .mfont(17, .bold)
                    .foregroundColor(.white)
              
                Text("Upgrade to the new version for more amazing experience")
                    .mfont(14, .regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                
                HStack(spacing : 16){
                    Button(action: {
                        
                        
                     
                        
                    }, label: {
                        Text("Update")
                            .mfont(17, .bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Capsule().fill(Color.main)

                            )
                    })
                    
                    Button(action: {
                        withAnimation{
                            show = false
                        }
                    }, label: {
                        Text("Cancel")
                            .mfont(17, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Capsule().fill(.black)
                            )
                    })
                }.padding(.top, 16)
                
            }.frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal, 38)
        }
        
      
        
    }
}
