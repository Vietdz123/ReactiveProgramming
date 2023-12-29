//
//  GenArtLimitView.swift
//  WallpaperIOS
//
//  Created by Duc on 26/12/2023.
//

import SwiftUI

struct GenArtLimitView: View {
    
    @State var showDialog : Bool = true
    @State var showSubView : Bool = false
    @EnvironmentObject var store : MyStore
    
    
    @Environment(\.presentationMode) var  presentationMode
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("menu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .frame(width: 48, height: 48, alignment: .center)
                    .containerShape(Rectangle())
               
                
                Spacer()
                
                Text("Generation")
                    .mfont(20, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.main)
                
                Spacer()
              
                    Image("search")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                    
             
                
            }.frame(maxWidth: .infinity)
                .frame(height: 48)
            
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .addBackground()
            .onChange(of: showDialog, perform: { value in
                if value == false {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .overlay{
                RemoveLimitView(show: $showDialog, onClickBuySub: {
                    showSubView = true
                })
            }
            .fullScreenCover(isPresented: $showSubView, content: {
                EztSubcriptionView()
                    .environmentObject(store)
            })
    }
    
}

#Preview {
    GenArtLimitView()
}
