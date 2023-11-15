//
//  EztWidgetView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

class EztWidgetViewModel : ObservableObject {
    @Published var showPreview : Bool = false
    @Published var currentWidgetSelected : EztWidget?
}

struct EztWidgetView: View {
    
    @StateObject var ctrlVM : EztWidgetViewModel  = .init()
    @StateObject var newWidgetVM : WidgetMainViewModel = .init()
    @StateObject var popularWidgetVM : WidgetMainViewModel = .init()
    @StateObject var digitalWidgetVM : WidgetMainViewModel = .init()
    @StateObject var rountineWidgetVM : WidgetMainViewModel = .init()
    
    @EnvironmentObject var storeVM : MyStore
    var body: some View {
        ScrollView(.vertical, showsIndicators : false){
            LazyVStack(spacing : 0 ,content: {
                
                WidgetNEW()
                WidgetPOPULAR()
                WidgetDIGITAL()
                WidgetROUNTINE()
                Spacer()
                    .frame( height: 152)
                
            })
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .addBackground()
        .refreshable {
            newWidgetVM.currentOffset = 0
            popularWidgetVM.currentOffset = 0
            digitalWidgetVM.currentOffset = 0
            rountineWidgetVM.currentOffset = 0
            
            newWidgetVM.widgets.removeAll()
            popularWidgetVM.widgets.removeAll()
            digitalWidgetVM.widgets.removeAll()
            rountineWidgetVM.widgets.removeAll()
            
            newWidgetVM.getWidgets()
            popularWidgetVM.getWidgets()
            digitalWidgetVM.getWidgets()
            rountineWidgetVM.getWidgets()
            
            
          
        }
    }
    
}

extension EztWidgetView{
    func WidgetNEW() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("New Trending".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(newWidgetVM)
                        .environmentObject(storeVM)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.padding(.horizontal, 16)
            ZStack{
                if newWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<4, id: \.self) { count in
                                    let widgetObj = newWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                            .overlay(alignment : .topTrailing){
                                                if !storeVM.isPro(){
                                                    Image("crown")
                                                        .resizable()
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .padding(8)
                                                }
                                            }
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if newWidgetVM.widgets.isEmpty{
                    newWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    
    
    func WidgetPOPULAR() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Popular".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(popularWidgetVM)
                        .environmentObject(storeVM)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.padding(.horizontal, 16)
            ZStack{
                if popularWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<4, id: \.self) { count in
                                    let widgetObj = popularWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                            .overlay(alignment : .topTrailing){
                                                if !storeVM.isPro(){
                                                    Image("crown")
                                                        .resizable()
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .padding(8)
                                                }
                                            }
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if popularWidgetVM.widgets.isEmpty{
                    popularWidgetVM.sort = .POPULAR
                    popularWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    
    
    func WidgetDIGITAL() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Digital Friend")
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(digitalWidgetVM)
                        .environmentObject(storeVM)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.padding(.horizontal, 16)
            ZStack{
                if digitalWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<4, id: \.self) { count in
                                    let widgetObj = digitalWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                            .overlay(alignment : .topTrailing){
                                                if !storeVM.isPro(){
                                                    Image("crown")
                                                        .resizable()
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .padding(8)
                                                }
                                            }
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if digitalWidgetVM.widgets.isEmpty{
                    digitalWidgetVM.type = .DigitalFriend
                    digitalWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    
    func WidgetROUNTINE() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Rountine monitor".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(rountineWidgetVM)
                        .environmentObject(storeVM)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.padding(.horizontal, 16)
            ZStack{
                if rountineWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<4, id: \.self) { count in
                                    let widgetObj = rountineWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                            .overlay(alignment : .topTrailing){
                                                if !storeVM.isPro(){
                                                    Image("crown")
                                                        .resizable()
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .padding(8)
                                                }
                                            }
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if rountineWidgetVM.widgets.isEmpty{
                    rountineWidgetVM.type = .Routine
                    rountineWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    
    
}


#Preview {
    EztWidgetView()
}
