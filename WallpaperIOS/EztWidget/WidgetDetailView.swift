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
                    Text("Widget")
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
            
            PreviewWidgetSheet(widget: widget, clickClose: {
                presentaionMode.wrappedValue.dismiss()
            })
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .onViewDidLoad {
            if widget.category_id == 2 {
                for urlStr in widget.getRectangleUrlString(){
                    SDWebImageManager.shared.loadImage(with: URL(string: urlStr), progress: nil, completed: {
                        _,_,_,_,_,_ in
                    })
                }
            }else{
                for urlStr in widget.getButtonCheckUrlString(){
                    SDWebImageManager.shared.loadImage(with: URL(string: urlStr), progress: nil, completed: {
                        _,_,_,_,_,_ in
                    })
                }
            }
        }
    }
}
