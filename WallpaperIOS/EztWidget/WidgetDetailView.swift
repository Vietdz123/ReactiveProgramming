//
//  WidgetDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 27/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct WidgetDetailView: View {
    let widget : EztWidget
    @Environment(\.presentationMode) var presentaionMode
    
    @EnvironmentObject var storeVM : MyStore
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    var body: some View {
        ZStack(alignment: .bottom){
            VStack(spacing : 0){
                HStack(spacing : 0){
                    Image("menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                        .containerShape(Rectangle())
                    Spacer()
                    Text("Widget".toLocalize())
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
                
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(0.9)
            
            PreviewWidgetSheet( widget: widget,clickClose: {
                presentaionMode.wrappedValue.dismiss()
            }).environmentObject(storeVM)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .onViewDidLoad {
            
            
            if widget.category_id == 3 {
                
                for urlStr in widget.getButtonCheckUrlString(){
                    SDWebImageManager.shared.loadImage(with: URL(string: urlStr), progress: nil, completed: {
                        _,_,_,_,_,_ in
                    })
                }
                
               
            }else{
                for urlStr in widget.getRectangleUrlString(){
                    SDWebImageManager.shared.loadImage(with: URL(string: urlStr), progress: nil, completed: {
                        _,_,_,_,_,_ in
                    })
                }
            }
        }
        .onAppear(perform: {
            if !storeVM.isPro(){
                interAd.showAd {
                    
                }
            }
        })
    }
}


extension EztWidget {
    func getRectangleUrlString() -> [String]{
        var listURL : [String] = []
        for thumbnail in self.path {
            if thumbnail.key_type == "rectangle"{
                listURL.append(thumbnail.url.full)
            }
        }
        return listURL
    }
    
    func getButtonCheckUrlString() -> [String]{
        var listURL : [String] = []
        for path in self.path {
            if path.key_type == "check"{
                listURL.append(path.url.full)
            }
        }
        return listURL
    }
    
    func getButtonUnCheckUrlString() -> [String]{
        var listURL : [String] = []
        for path in self.path {
            if path.key_type == "uncheck"{
                listURL.append(path.url.full)
            }
        }
        return listURL
    }
    
    func getURLStringLottie() -> [String]{
        var listURL : [String] = []
        if  let thumbnails = self.thumbnail {
            for thumbnail in thumbnails {
                if thumbnail.key_type == "lottie_rectangle" {
                    listURL.append( thumbnail.url.full)
                }
            }
        }
       
        
        return listURL
    }
}
