//
//  Sub_3_View.swift
//  WallpaperIOS
//
//  Created by Mac on 29/08/2023.
//

import SwiftUI

struct Sub_3_View: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store : MyStore
    @State private var timeRemaining: TimeInterval = 60.0
      @State private var timer: Timer?
    
    @State private var showBtnClose : Bool = false
    
    var body: some View {
        VStack(spacing : 0){
            HStack{
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack{
                        if showBtnClose{
                            Image("close.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .opacity(0.7)
                        }
                    } .frame(width: 24, height: 24)
                })
                
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            Spacer()
            Text("This offer will expire in:".toLocalize())
                .mfont(15, .regular)
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            
            HStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.7))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text("\(formatTimeMin(timeRemaining))")
                            .mfont(32, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                        
                    )
                
                Text(":")
                    .mfont(28, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.7))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text("\(formatTimeSecond(timeRemaining))")
                            .mfont(32, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                        
                    )
                
                Text(":")
                    .mfont(28, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.7))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text("\(formatTimeMiliSecond(timeRemaining))")
                            .mfont(32, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                        
                    )
                
            }.padding(.top, 16)
                .onAppear {
                               startTimer()
                           }
                           .onDisappear {
                               stopTimer()
                           }
            
            if let product =  store.yearlv2Sale50Product {
                
           
            
//                Text("ONLY \(decimaPriceToStr(price: product.price , chia:  51))\(removeDigits(string: product.displayPrice ))/\("Week").")
                Text( String(format: NSLocalizedString("ONLY %@/Week", comment: ""), getDisplayPrice(price: product.price, chia: 51, displayPrice: product.displayPrice)) )
                .mfont(24, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
              .padding(.top, 28)
            
                HStack(spacing : 0){
                  //  Text("Total \(product.displayPrice)/\("year") ")
                    Text( String(format: NSLocalizedString("Total %@/year", comment: ""), product.displayPrice ) )
                        .mfont(17, .bold)
                        .foregroundColor(.black)
//                    Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/\("year"))")
                    Text( String(format: NSLocalizedString("(%@/year)", comment: ""), getDisplayPrice(price: product.price, chia: 0.5, displayPrice: product.displayPrice)) )
                        .mfont(17, .bold)
                        .foregroundColor(.black)
                        .overlay(
                            Rectangle()
                                .fill(Color.black.opacity(0.8))
                                .frame(height: 1)

                        )
                }
              .padding(.top, 8)
            
            
            Button(action: {
                
                store.isPurchasing = true
                let log =  "Click_Buy_Sub_In_Promotion_Year_Sale"
                Firebase_log(log)
                store.purchase(product: product, onBuySuccess: {
                    b in
                       if b {
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               presentationMode.wrappedValue.dismiss()
                               showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                               let log1 =  "Buy_Sub_In_Success_Promotion_Year_Sale"
                               Firebase_log(log1)
                           }
                       }else{
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               
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
            }).disabled(store.isPurchasing)
            .padding(.top, 11)
            
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
                        .foregroundColor(.black)
                        .mfont(12, .regular)
                    
                })
                
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.black)
                
                Button(action: {
                    
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    Text("Terms of Use")
                        .underline()
                        .foregroundColor(.black)
                        .mfont(12, .regular)
                    
                })
             
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.black)
                Button(action: {
                    Task{
                        let b = await store.restore()
                        if b {
                            store.fetchProducts()
                            showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                        }
                    }
                    
                }, label: {
                    Text("Restore")
                        .underline()
                        .foregroundColor(.black)
                        .mfont(12, .regular)
                    
                })
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                Image("sub_3")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .onViewDidLoad {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    withAnimation(.easeOut){
                        showBtnClose = true
                    }
                })
            }
            .overlay(
                ZStack{
                    if store.isPurchasing{
                       ProgressBuySubView()
                            .ignoresSafeArea()
                    }
                }
            )
         
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
          let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 1000)
          
          return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
      }
    
    func formatTimeMin(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval / 60)
      
        
        return String(format: "%02d", minutes)
    }
    
    func formatTimeSecond(_ timeInterval: TimeInterval) -> String {
       
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
     
        
        return String(format: "%02d",seconds)
    }
    
    func formatTimeMiliSecond(_ timeInterval: TimeInterval) -> String {
   
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        
        return String(format: "%02d", milliseconds)
    }
    
}

struct Sub_3_View_Previews: PreviewProvider {
    static var previews: some View {
        Sub_3_View()
            .environmentObject(MyStore())
    }
}
