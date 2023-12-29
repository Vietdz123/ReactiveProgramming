//
//  ConditionalWidgetView.swift
//  WallpaperIOS
//
//  Created by Duc on 25/12/2023.
//

import SwiftUI

struct ConditionalWidgetView: View {
    
    let widgetType : FetchWidgetType
    
    @StateObject var newestVM : WidgetMainViewModel = .init(sort : .NEW)
    @StateObject var popularVM : WidgetMainViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    
    
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeVM : MyStore
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    var body: some View {
        VStack(spacing: 0, content: {
            HStack(spacing : 0){
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .containerShape(Rectangle())
            })
                Text(widgetType.rawValue)
                .foregroundColor(.white)
                .mfont(22, .bold)
                .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing : 0){
                    Newset().padding(.bottom, 16)
                    Popular().padding(.bottom, 16)
                    Spacer()
                        .frame(height: 152)
                }

            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .addBackground()
        .refreshable {
           
           
        }
        .onAppear(perform: {
            newestVM.type = widgetType
            popularVM.type = widgetType
            if newestVM.widgets.isEmpty{
                newestVM.getWidgets()
            }
            
            if popularVM.widgets.isEmpty{
                popularVM.getWidgets()
            }
        })
    }
    
    
    
    
    
    
}



extension ConditionalWidgetView {
    func Newset() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    

                Spacer()
            
                
                
            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            
            
            ZStack{
                if !newestVM.widgets.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){

                            LazyHStack(spacing: 8, content: {
                                ForEach(newestVM.widgets.indices, id: \.self ) {
                                    i in
                                    let widget = newestVM.widgets[i]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widget)
                                            .environmentObject(storeVM)
                                            .environmentObject(reward)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widget)
                                    })

                                }
                            })
                            
                            
                        }
                        
                        
                    }
                  
                    .padding(.horizontal, 16)
                }
               


            }
           
              
            
            
        }
       
    }
    
    
    func Popular() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("sparkle")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Popular".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                   
                Spacer()
            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            
            
            LazyVStack(spacing: 8 ){
                
                if !popularVM.widgets.isEmpty {
                    ForEach(0..<popularVM.widgets.count, id: \.self){
                        i in
                        let  widget = popularVM.widgets[i]
                      
                        
                        NavigationLink(destination: {
                            WidgetDetailView(widget: widget)
                                .environmentObject(storeVM)
                                .environmentObject(reward)
                                .environmentObject(interAd)
                        }, label: {
                            ItemWidgetViewFull(widget: widget)

                        })
                        .onAppear(perform: {
                            if i == ( popularVM.widgets.count - 6 ){
                                popularVM.getWidgets()
                            }
                        })
                    }
                }
            }
            .padding(.horizontal, 16)
              
            
            
        }
       
    }
    
}



