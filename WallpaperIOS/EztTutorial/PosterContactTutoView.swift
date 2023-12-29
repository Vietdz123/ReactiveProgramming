//
//  PosterContactTutoView.swift
//  WallpaperIOS
//
//  Created by Duc on 26/12/2023.
//

import SwiftUI

struct PosterContactTutoView: View {
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
                
                Text("How to Poster Contact".toLocalize())
                    .mfont(17, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                    .padding(.top, 16)
                
                Row(pos: 1, text: "Once you’ve saved a poster, open the Contacts app and tap the contact you want to set it for.", img: "")
                Row(pos: 2, text: "Select Contact Photo & Poster.", img: "pt2")
                Row(pos: 3, text: "Tab + to add a poster and select Photos.", img: "pt3")
                Row(pos: 4, text: "Choose the downloaded poster and tap Done.", img: "pt4")
                Row(pos: 5, text: "Tap Continue. Then customize the contact photo or tap Skip.", img: "pt5")
                Row(pos: 5, text: "Tap Done to set the contact poster.", img: "pt6")
                   
                
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
            if !img.isEmpty{
                Image(img)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
          
            
            
        }.padding(.horizontal, 16)
            .padding(.bottom , 16)
    }
}

#Preview {
    PosterContactTutoView()
}
