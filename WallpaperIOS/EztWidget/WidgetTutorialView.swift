//
//  WidgetTutorialView.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import SwiftUI

struct WidgetTutorialView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing : 0){
            Text("Tutorial")
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
                
                Text("How to Add Widget")
                    .mfont(17, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                  .padding(.top, 16)
                
                Row(pos: 1, text: "Long press anywhere on the Home Screen and tap + in the upper left corner.", img: "w1")
                Row(pos: 2, text: "Find and choose Wallive on the list of the widgets.", img: "w2")
                Row(pos: 3, text: "Swipe to set the widget size and tap Add Widget.", img: "w3")
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
                
                Text(text)
                    .mfont(15, .regular)
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
    WidgetTutorialView()
}
