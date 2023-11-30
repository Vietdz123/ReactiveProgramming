//
//  WatchFaceTutorialView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI

struct WatchFaceTutorialView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing : 0){
            Text("Tutorial".toLocalize())
                .mfont(20, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("back")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .containerShape(Rectangle())
                    }).padding(.leading, 16)
                    , alignment: .leading
                    
                )
            ScrollView(.vertical, showsIndicators: false){
                
                Text("How to Add Widget".toLocalize())
                    .mfont(17, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                    .padding(.top, 16)
                
                Row(pos: 1, text: "Open Apple Watch on your phone", img: "wf1")
                Row(pos: 2, text: "Connect your Apple Watch to your Phone", img: "wf2")
                Row(pos: 3, text: "Select the Face Gallery tab below the bottom bar", img: "wf3")
                    .padding(.bottom, 32)
                Row(pos: 4, text: "Scroll and select the Portraits category", img: "wf4")
                    .padding(.bottom, 32)
                Row(pos: 5, text: "Choose Photos you download from Wallive", img: "wf5")
                    .padding(.bottom, 32)
                
            }
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
    
    
    @ViewBuilder
    func Row(pos : Int, text : String, img : String) -> some View{
        VStack(spacing : 16){
            HStack(alignment: .top, spacing : 16){
                Circle()
                    .fill(Color(red: 0.02, green: 0.52, blue: 1))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text("\(pos)")
                            .mfont(15, .bold)
                            .foregroundColor(Color(red: 0.13, green: 0.11, blue: 0.15))
                    )
                
                Text(text.toLocalize())
                    .mfont(15, .regular, line: 3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(img)
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            
        }.padding(.horizontal, 16)
            .padding(.bottom , 16)
    }
}
#Preview {
    WatchFaceTutorialView()
}
