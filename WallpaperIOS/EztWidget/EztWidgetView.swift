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
    
    @Published var healthWidgets : [EztWidget] = [
        EztWidget(id: 67 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 68 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 69 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 70 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 71 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: [])

    ]
    
}

enum HealthDisplayType : String, CaseIterable{
    case step = "Step Counter"
    case distance = "Distance"
    case water = "Water Tracker"
    case sleep = "Sleep Tracker"
    case energy = "Energy Tracker"
}

struct EztWidgetView: View {
    
    @StateObject var ctrlVM : EztWidgetViewModel  = .init()
    
    
    @StateObject var newWidgetVM : WidgetMainViewModel = .init(type : .ALL, sort: .NEW)
    @StateObject var popularWidgetVM : WidgetMainViewModel = .init(type : .ALL, sort: .POPULAR, sortByTop: .TOP_MONTH)
    @StateObject var digitalWidgetVM : WidgetMainViewModel = .init(type : .DigitalFriend, sort: .NEW, sortByTop: .TOP_MONTH)
    @StateObject var rountineWidgetVM : WidgetMainViewModel = .init(type : .Routine,sort: .NEW, sortByTop: .TOP_MONTH)
    @StateObject var soundWidgetVM : WidgetMainViewModel = .init(type : .Sound, sort: .NEW, sortByTop: .TOP_MONTH)
    @StateObject var gifWidgetVM : WidgetMainViewModel = .init(type : .Gif, sort: .NEW, sortByTop: .TOP_MONTH)
    @StateObject var makeDecisionWidgetVM : WidgetMainViewModel = .init(type : .DecisionMaker, sort: .NEW, sortByTop: .TOP_MONTH)
    
    
    @EnvironmentObject var storeVM : MyStore
    @EnvironmentObject  var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    let widgetHeight : CGFloat = 320 / 2.2
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators : false){
            LazyVStack(spacing : 0 ,content: {
                
                WidgetNEW()
                WidgetPOPULAR()
                WidgetDIGITAL()
                WidgetHEALTH()
                WidgetSound()
                WidgetGIF()
                WidgetMakeDicision()
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
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    
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
                    
                    let itemCountShow = min(4, newWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = newWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
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
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                    
                    let itemCountShow = min(4, popularWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = popularWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if popularWidgetVM.widgets.isEmpty{
                   // popularWidgetVM.sort = .POPULAR
                    popularWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    func WidgetHEALTH() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Health Widget".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    HealthWidgetListView(widgetList: ctrlVM.healthWidgets)
                        .environmentObject(storeVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing : 0){
                        Spacer().frame(width: 16)
                        LazyHStack(spacing : 16,content: {
                            ForEach(ctrlVM.healthWidgets, id: \.id) { widgetObj  in
                                
                                NavigationLink(destination: {
                                    WidgetDetailView(widget: widgetObj)
                                        .environmentObject(storeVM)
                                        .environmentObject(rewardAd)
                                        .environmentObject(interAd)
                                }, label: {
                                    Image("\(widgetObj.id)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 320, height: widgetHeight)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.4), lineWidth : 1)
                                        }
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 16)
                                        )

                                })
                                
                                
                            }
                        })
                     }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
           
            
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
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                    let itemCountShow = min(4, digitalWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = digitalWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if digitalWidgetVM.widgets.isEmpty{
                   // digitalWidgetVM.type = .DigitalFriend
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
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                    
                    let itemCountShow = min(4, rountineWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = rountineWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)

                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if rountineWidgetVM.widgets.isEmpty{
                  //  rountineWidgetVM.type = .Routine
                    rountineWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    
    func WidgetSound() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Sound".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(soundWidgetVM)
                        .environmentObject(storeVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                if soundWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, soundWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = soundWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)

                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if soundWidgetVM.widgets.isEmpty{
                //    soundWidgetVM.type = .Sound
                    soundWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    func WidgetGIF() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("GIF".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(gifWidgetVM)
                        .environmentObject(storeVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                if gifWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, gifWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = gifWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if gifWidgetVM.widgets.isEmpty{
                  //  gifWidgetVM.type = .Gif
                    gifWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    func WidgetMakeDicision() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Make Decision".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(makeDecisionWidgetVM)
                        .environmentObject(storeVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
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
                if makeDecisionWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, makeDecisionWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = makeDecisionWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(storeVM)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)

                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: widgetHeight)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: widgetHeight)
            .onAppear(perform: {
                if makeDecisionWidgetVM.widgets.isEmpty{
                  //  makeDecisionWidgetVM.type = .DecisionMaker
                    makeDecisionWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
}


#Preview {
    EztWidgetView()
}
