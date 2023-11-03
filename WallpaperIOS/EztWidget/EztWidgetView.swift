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
        
        
        
    }
    
    
    
    
    
    
}

extension EztWidgetView{
    func WidgetNEW() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("New Trending")
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(newWidgetVM)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more")
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
                                ForEach(0..<7, id: \.self) { count in
                                    let widgetObj = newWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
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
                Text("Popular")
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(popularWidgetVM)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more")
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
                                ForEach(0..<7, id: \.self) { count in
                                    let widgetObj = popularWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
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
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more")
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
                                ForEach(0..<rountineWidgetVM.widgets.count, id: \.self) { count in
                                    let widgetObj = digitalWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
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
                Text("Rountine monitor")
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(rountineWidgetVM)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more")
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
                                ForEach(0..<rountineWidgetVM.widgets.count, id: \.self) { count in
                                    let widgetObj = rountineWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
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
