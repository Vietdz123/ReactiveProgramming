//
//  HealView.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//

import SwiftUI
import WidgetKit



@available(iOS 17.0, *)
struct HealthWidgetView : View {
    @Environment(\.widgetFamily) var family
    var entry: HealthEntry
    
    
    
    var body: some View {
        ZStack {
            if family == .systemMedium{
                switch entry.healthType{
                case .steps:
                    stepsViewRectangle
                case .distance:
                    distanceRectangle
                case .sleepTime:
                  sleepTimeRectangle
                case .energyBurn:
                   energyRectangle
                case .waterTrack:
                   waterRectangle
                case .placeHolder:
                    Image("bg99")
                        .resizable()
                }
            }else{
                switch entry.healthType{
                case .steps:
                    stepsViewSquare
                case .distance:
                    distanceSquare
                case .sleepTime:
                    sleepTimeSquare
                case .energyBurn:
                    energySquare
                case .waterTrack:
                   waterSquare
                case .placeHolder:
                    Image("bg98")
                        .resizable()
                }
               
            }
        
        }
    }
}



//MARK: - STEP
@available(iOS 17.0, *)
extension HealthWidgetView{
    var stepsViewSquare : some View{
        ZStack{
            Image("step-02")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(spacing : 0){
                Text("STEP COUNTER")
                    .font(
                    Font.custom("Chivo", size: 17)
                    .weight(.bold)
                    )
                  .multilineTextAlignment(.center)
                  .lineLimit(1)
                  .minimumScaleFactor(0.1)
                  .foregroundColor(Color(red: 0.38, green: 0.49, blue: 0.96))
                  .padding(.horizontal, 20)
                  .padding(.top, 16)
                
                HStack(alignment: .bottom, spacing : 0){
                    Text(entry.value)
                        .font(
                        Font.custom("Chivo", size: 24)
                        .weight(.bold)
                        )
                      .lineLimit(1)
                      .minimumScaleFactor(0.1)
                      .foregroundColor(.white)
                      .frame(width: 72, height: 23)
                      .padding(.leading, 12)
                    Spacer()
                    Text("Steps")
                 
                        .font(
                        Font.custom("Chivo", size: 13)
                       
                        )
                      .lineLimit(1)
                      .minimumScaleFactor(0.1)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .frame(width: 28, height: 11)
                      .padding(.trailing, 12)
                    
                }
                .frame( height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(red: 0.38, green: 0.49, blue: 0.96)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                
                Spacer()
                
            }
            
        }
    }
    
    
    var stepsViewRectangle : some View{
        ZStack(alignment: .topTrailing){
            Image("step-01")
                .resizable()
                .scaledToFill()
                .clipped()

                
            
            VStack(spacing: 0, content: {
                Text("STEP COUNTER")
                .font(
                    Font.custom("Chivo", size: 28)
                    .weight(.bold)
                    )
                  .lineLimit(1)
                  .minimumScaleFactor(0.1)
                  .foregroundColor(Color(red: 0.38, green: 0.49, blue: 0.96))
                 
                 // .frame(width: 192, height: 30 ,alignment: .trailing    )
                  .padding(.top, 24)
                Spacer()
                HStack(alignment: .bottom, spacing : 0){
                    Text(entry.value)
//                      .font(
//                        Font.custom("Teko", size: 56)
//                          .weight(.medium)
//                      )
                        .font(
                        Font.custom("Chivo", size: 36)
                        .weight(.bold)
                        )
                     // .lineLimit(1)
                     // .minimumScaleFactor(0.1)
                      .foregroundColor(.white)
                     // .frame(width: 111, height: 35)
                      .padding(.leading, 12)
                    Spacer()
                    Text("Steps")
                  //    .font(Font.custom("Teko", size: 28))
                       // .font(.system(size: 28))
                        .font(Font.custom("Chivo", size: 20))
                      .lineLimit(1)
                      .minimumScaleFactor(0.1)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .frame(width: 46, height: 18)
                      .padding(.trailing, 12)
                      .padding(.bottom, 4)
                }.frame(width: 196, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(red: 0.38, green: 0.49, blue: 0.96)
                            )
                    )
                    .padding(.bottom, 24)
                
            }).frame(width: 196)
           
            .padding(.trailing, 16)

            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//MARK: - SLEEP
@available(iOS 17.0, *)
extension HealthWidgetView{
    var sleepTimeSquare : some View{
        ZStack{
            Image("sleep-bg-02")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(alignment: .trailing, spacing : 0 ,content: {
                Spacer()
                
                Text("Today")
                    .font(
                    Font.custom("Chivo", size: 13)
                   
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                  .foregroundColor(.white)
                //  .padding(.bottom, 16)
                  .padding(.trailing, 16)
                
                Text("\(entry.value) hrs")
                    .font(
                    Font.custom("Chivo", size: 24)
                    .weight(.bold)
                    )
                  .foregroundColor(.white)
                  .padding(.trailing, 16)
                  .padding(.bottom, 4)
                
                
               Button(intent: SleepIntent(id_name: ""), label: {
                    Text("+ 1 hr")
                        .font(
                        Font.custom("Chivo", size: 15)
                        .weight(.bold)
                        )
                       
                   
                      .foregroundColor(.white)
                      .frame(maxWidth: .infinity)
                      .frame(height: 24)
                      .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.49, green: 0.78, blue: 0.89))
                      )
                    
                })
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
               
                    
                
               
                
                
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var sleepTimeRectangle : some View{
        ZStack(alignment: .trailing){
            Image("sleep-bg-01")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(spacing : 0){
                Spacer()
                HStack(alignment: .bottom, spacing: 0){
                    Text("Today")
                        .font(Font.custom("Chivo", size: 17))
                      .lineLimit(1)
                      .minimumScaleFactor(0.1)
                      .foregroundColor(.white)
                      .padding(.bottom, 4)
                   
                    Spacer()
                    Text("\(entry.value) hrs")
                        .font(
                        Font.custom("Chivo", size: 32)
                        .weight(.bold)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                    
                }.frame(width: 134, height: 28)
                    .padding(.bottom, 8)
               
            
                Button(intent: SleepIntent(id_name: "")
                    
                , label: {
                    Text("+ 1 hr")
                        .font(
                        Font.custom("Chivo", size: 20)
                        .weight(.bold)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(width: 134, height: 38)
                      .background(Color(red: 0.49, green: 0.78, blue: 0.89))
                      .cornerRadius(12)
                    
                      
                }).buttonStyle(.plain)
                    .padding(.bottom, 16)
                  
               
                
            }   .frame(width: 134).padding(.trailing, 24)
            
            
            
        }
    }
    
}


//MARK: - WATER
@available(iOS 17.0, *)
extension HealthWidgetView{
    var waterSquare : some View{
        ZStack{
            Image("water-02")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(alignment : .trailing ,spacing : 0){
              Spacer()
                
                Text("Today")
                  .font(Font.custom("Chivo", size: 13))
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(.white)
                  .padding(.trailing, 16)
                Text("\(entry.value) oz")
                  .font(
                    Font.custom("Chivo", size: 24)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(Color(red: 0.33, green: 0.42, blue: 0.84))
                  .padding(.trailing, 16)
                  .padding(.bottom, 8)
                Button(intent: WaterIntent(id_name: "") , label: {
                Text("+ 12 oz")
                  .font(
                    Font.custom("Chivo", size: 15)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .frame(height: 24)
                  .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            Color(red: 0.33, green: 0.42, blue: 0.84)
                            )
                  )
                 
                }).buttonStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
            
        }
    }
    
    var waterRectangle : some View{
        ZStack(alignment: .trailing){
            Image("water-01")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack( spacing: 0, content: {
                Spacer()
                
                HStack(alignment: .bottom ,spacing : 0){
                    Text("Today")
                      .font(Font.custom("Chivo", size: 17))
                      .foregroundColor(.white)
                      .padding(.bottom, 4)
                    Spacer()
                    Text("\(entry.value) oz")
                      .font(
                        Font.custom("Chivo", size: 32)
                          .weight(.bold)
                      )
                      .lineLimit(1)
                      .minimumScaleFactor(0.5)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(Color(red: 0.33, green: 0.42, blue: 0.84))
                    
                }
                
                
                
                Button(intent: WaterIntent(id_name: "") , label: {
                    Text("+ 12 oz")
                      .font(
                        Font.custom("Chivo", size: 20)
                          .weight(.bold)
                      )
                   
                      .foregroundColor(.white)
                      .frame(width: 156, height: 38)
                      .background(Color(red: 0.33, green: 0.42, blue: 0.84))
                      .cornerRadius(12)
                }).buttonStyle(.plain)
                    .padding(.top, 8)
               
                
                
                
            }).frame(width: 156)
                .padding(.vertical,16)
                .padding(.horizontal, 24)
            
        }
    }
}

//MARK: - ENERGY
@available(iOS 17.0, *)
extension HealthWidgetView{
    var energySquare : some View{
        ZStack{
            Image("calo-02")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(spacing : 0){
                Text("ACTIVE ENERGY")
                  .font(
                    Font.custom("Chivo", size: 17)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                
                
                HStack(spacing : 0){
                    Text("\(entry.value)")
                      .font(
                        Font.custom("Chivo", size: 24)
                          .weight(.bold)
                      )
                      .foregroundColor(.white)
                      .padding(.leading, 8)
                    
                    Spacer()
                    
                    Text("Kcal")
                      .font(Font.custom("Chivo", size: 15))
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .padding(.trailing, 8)
                      .padding(.bottom, 2)
                    
                    
                }.frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            Color(red: 0.97, green: 0.47, blue: 0.26)
                        )
                    )
                
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
               .padding(.top, 12)

            
            
            
        }
    }
    
    var energyRectangle : some View{
        ZStack(alignment: .trailing ){
         
            Image("calo-01")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(alignment: .trailing){
                Text("ACTIVE ENERGY")
                  .font(
                    Font.custom("Chivo", size: 28)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing : 0){
                    Text("\(entry.value)")
                      .font(
                        Font.custom("Chivo", size: 36)
                          .weight(.bold)
                      )
                      .foregroundColor(.white)
                      .padding(.leading, 12)
                      
                    Spacer()
                    
                    Text("Kcal")
                      .font(Font.custom("Chivo", size: 20))
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .padding(.trailing, 12)
                      .padding(.bottom, 4)
                }.frame(width: 180, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(red: 0.97, green: 0.47, blue: 0.26)
                            )
                    )
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//MARK: - DISTANCE
@available(iOS 17.0, *)
extension HealthWidgetView{
   
    
    var distanceRectangle : some View{
        ZStack{
            Image("distance-01")
                .resizable()
                .scaledToFill()
                .clipped()
            
            
            VStack(alignment: .trailing){
                Text("DISTANCE TRACKER")
                
                  .font(
                    Font.custom("Chivo", size: 32)
                      .weight(.bold)
                  )
                  .lineLimit(1)
                  .minimumScaleFactor(0.5)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing : 0){
                    Text(entry.value)
                      .font(
                        Font.custom("Chivo", size: 32)
                          .weight(.bold)
                      )
                      .foregroundColor(.white)
                      .padding(.leading, 12)
                    
                    Spacer()
                    Text("Km")
                      .font(Font.custom("Chivo", size: 20))
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .padding(.trailing, 12)
                      .padding(.top, 4)
                   
                    
                }.frame(width: 144, height: 60)
                    .background(
                      RoundedRectangle(cornerRadius: 12)
                          .fill(
                         
                             Color(red: 0.92, green: 0.43, blue: 0.5)
                            
                          )
                    )
            }.padding(.top, 12)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
    }
    
    
    var distanceSquare : some View{
        ZStack{
            Image("distance-02")
                .resizable()
                .scaledToFill()
                .clipped()
            
            VStack(spacing : 0){
                
                Text("DISTANCE TRACKER")
                  .font(
                    Font.custom("Chivo", size: 17)
                      .weight(.bold)
                  )
                  .lineLimit(1)
                  .minimumScaleFactor(0.5)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .padding(.vertical, 8)
                
                HStack(spacing : 0){
                    Text("2345")
                      .font(
                        Font.custom("Chivo", size: 24)
                          .weight(.bold)
                      )
                      .lineLimit(1)
                      .minimumScaleFactor(0.5)
                      .foregroundColor(.white)
                      .padding(.leading, 8)
                    
                    Spacer()
                    
                    Text("Km")
                      .font(Font.custom("Chivo", size: 15))
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .padding(.trailing, 8)
                      .padding(.top, 2)
                    
                }.frame(width: 112, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(red: 0.92, green: 0.43, blue: 0.5)
                            )
                    )
                
                Spacer()
            }
            
        }
    }
    
}
