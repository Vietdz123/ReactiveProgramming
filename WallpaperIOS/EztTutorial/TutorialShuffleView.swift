//
//  TutorialShuffleView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI

struct TutorialShuffleView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                    dismiss.callAsFunction()
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
              .overlay(
                NavigationLink(destination: {
                    ShuffleTutoView()
                }, label: {
                    Text("Video")
                        .mfont(14, .regular)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                }).padding(.trailing, 16)
                , alignment: .trailing
              )
            
            Text("How to Set Shuffle Pack")
                .mfont(17, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(Color.main)
              .padding(.top, 16)
           
            
            ScrollView(.vertical, showsIndicators: false){
                Row(pos: 1, text: "Once you saved a shuffle pack in app, touch and hold the Lock Screen", img: "s1")
                Row(pos: 2, text: "Add a new wallpaper.", img: "s2")
                Row(pos: 3, text: "Tap Photo Shuffle.", img: "s3")
                Row(pos: 4, text: "Tap Select Photos Manually.", img: "s4")
                Row(pos: 5, text: "Select Albums.", img: "s5")
                Row(pos: 6, text: "Choose a Shuffle Pack album.", img: "s6")
                Row(pos: 7, text: "Select images to shuffle.", img: "s7")
                Row(pos: 8, text: "Tab Add.", img: "s8")
                Row(pos: 9, text: "Tab Add one more time.", img: "s9")
                Row(pos: 10, text: "Finally, choose how you want to set the wallpaper.", img: "s10")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 16)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .addBackground()
            .onAppear(perform: {
                UserDefaults.standard.set(true, forKey: "show_tuto_shuffleee")
            })
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

struct TutorialShuffleView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialShuffleView()
    }
}
