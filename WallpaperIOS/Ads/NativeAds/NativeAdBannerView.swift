////
////  NativeAdBannerView.swift
////  NativeAdSwiftuiView
////
////  Created by LNHung on 25/01/2024.
////
//
//import SwiftUI
//import GoogleMobileAds
//
//struct NativeAdBannerView: View {
//    @Binding var nativeAd: GADNativeAd?
//    
//    var body: some View {
//        VStack(spacing: 0) {
////            Rectangle()
////                .foregroundColor(.blue)
////                .frame(height: 5)
//            
//            HStack(spacing: 0) {
//                Image(uiImage: (nativeAd?.icon?.image) ?? UIImage())
//                    .resizable()
//                    .scaledToFill()
////                    .background(.gray)
//                    .frame(width: 44, height: 44, alignment: .center)
//                    
//                
//                VStack(alignment: .leading) {
//                    Text(nativeAd?.headline ?? "")
//                        .foregroundColor(.white)
//                    
//                    Text(nativeAd?.advertiser ?? "Advert")
//                        .foregroundColor(Color(red: 0.65, green: 0.65, blue: 0.65))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                }.padding(.leading, 8)
//                
//                Spacer()
//                
//                if let buttonName = nativeAd?.callToAction {
//                    Text(buttonName)
//                        .foregroundColor(Color("333333"))
//                        .mfont(14, .bold)
//                        .minimumScaleFactor(0.5)
//                        .frame(width: 80, height: 28, alignment: .center)
//                        .background(Color.main)
//                        .clipShape(Capsule())
//                     
//                }
//            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 16)  
//        }
//        .frame(width: UIScreen.main.bounds.width - 32, height: 84, alignment: .top)
//        .background(Color.white.opacity(0.03))
//      
//        .cornerRadius(12)
//        
//    }
//}
