//
//  Sub_1_View.swift
//  WallpaperIOS
//
//  Created by Mac on 29/08/2023.
//

import SwiftUI

struct Sub_1_View: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store : MyStore
    
    @State private var timeRemaining: TimeInterval = 60.0
      @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing : 0){
            HStack{
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            
            Text("Special gift for you!")
                .mfont(32, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.horizontal, 28)
            
            Image("sub_1")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Text("Limited time offer")
                .mfont(24, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
            
            if let product = store.isVer1() ?  store.weekProduct : store.yearlv2SalaProduct {
                
                
                
                HStack(spacing : 0){
                    Text("Total \(product.displayPrice)/\(store.isVer1() ? "week" : "year") ")
                        .mfont(15, .regular)
                        .foregroundColor(.white)
                    Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/\(store.isVer1() ? "week" : "year"))")
                        .mfont(15, .regular)
                        .foregroundColor(.white)
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.8))
                                .frame(height: 1)

                        )
                }
                
                
             
                HStack(spacing : 2){
                    Text("This offer will expire in")
                        .mfont(17, .regular)
                        .foregroundColor(.white)
                    
                    Text(" \(formatTime(timeRemaining))")
                     
                        .mfont(17, .bold)
                        .foregroundColor(.main)
                        .onAppear {
                                       startTimer()
                                   }
                                   .onDisappear {
                                       stopTimer()
                                   }
                     
                }.padding(.top, 27)
                
                Button(action: {
                    store.isPurchasing = true
                    showProgressSubView()
                    store.purchase(product: product, onBuySuccess: {
                        b in
                           if b {
                               DispatchQueue.main.async{
                                   store.isPurchasing = false
                                   hideProgressSubView()
                                   showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                  
                               }
                              
                           }else{
                               DispatchQueue.main.async{
                                   store.isPurchasing = false
                                   hideProgressSubView()
                                   showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                               }
                           }
                    })
                }, label: {
                    Capsule()
                        .fill(
                            LinearGradient(
                            stops: [
                            Gradient.Stop(color: Color(red: 0.15, green: 0.34, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.93, green: 0.42, blue: 1), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0, y: 1),
                            endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                    
                        .overlay(
                            HStack{
                             
                                Text("Claim Offer!")
                                    .mfont(20, .bold)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                  .overlay(
                                    ZStack{
                                        if store.isPurchasing{
                                            ResizableLottieView(filename: "progress_white")
                                                 .frame(width: 36, height: 36)
                                        }
                                      
                                    }.offset(x : -36)
                                    , alignment: .leading
                                  )
                            }
                            
                            
                        )
                        .overlay(
                           Image("a.r")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 20)
                        , alignment: .trailing
                        )
                        .padding(.horizontal, 48)
                })
                .disabled(store.isPurchasing)
                .padding(.top, 16)
            }
         
            
            
            HStack(spacing : 4){
                Spacer()
                
                Button(action: {
                    
                    
                    if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                        UIApplication.shared.open(url)
                    }
                    
                }, label: {
                    Text("Privacy Policy")
                        .underline()
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
                
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.white)
                
                Button(action: {
                    
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    Text("Terms of Use")
                        .underline()
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
             
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.white)
                Button(action: {
                    Task{
                        let b = await store.restore()
                        if b {
                            showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                        }
                    }
                    
                }, label: {
                    Text("Restore")
                        .underline()
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
                Spacer()
            }
            .padding(.top, 34)
            .padding(.bottom, 28)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            .addBackground()
           
    }
    
    func startTimer() {
          timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
              if timeRemaining > 0.2 {
                  timeRemaining -= 0.02
              } else {
                  timeRemaining = 0
                  stopTimer()
              }
          }
      }
      
      func stopTimer() {
          timer?.invalidate()
          timer = nil
      }
      
      func formatTime(_ timeInterval: TimeInterval) -> String {
          let minutes = Int(timeInterval / 60)
          let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
          let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
          
          return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
      }
    
}

struct Sub_1_View_Previews: PreviewProvider {
    static var previews: some View {
        Sub_1_View()
            .environmentObject(MyStore())
    }
}
