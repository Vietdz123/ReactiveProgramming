////
////  NativeAdCardView.swift
////  NativeAdSwiftuiView
////
////  Created by LNHung on 25/01/2024.
////
//
//
//
//import SwiftUI
//import GoogleMobileAds
//
//struct NativeAdCardView: View {
//    @Binding var nativeAd: GADNativeAd?
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            VStack {
//                HStack {
//                    Image(uiImage: (nativeAd?.icon?.image) ?? UIImage())
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 65, height: 65)
//                        .cornerRadius(5)
//                    
//                    VStack(alignment: .leading) {
//                        Text(nativeAd?.headline ?? "")
//                            .fontWeight(.semibold)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .font(.body)
//                            .lineLimit(2)
//                            .lineSpacing(1)
//
//                        Text(nativeAd?.advertiser ?? "Advert")
//                            .font(.subheadline)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 16)
//                
////                if let image = nativeAd?.mediaContent.mainImage {
////                    Image(uiImage: image)
////                        .scaledToFit()
////                        .frame(height: 200)
////                        .background(.blue)
////                        .padding(.horizontal, 16)
////                        .clipped()
////                }
//                
//    //                Can set frame cho no de hien thi phan media cho dung, khong hieu vi sao
//                GADNativeMediaWrapper(nativeAd: .constant(nativeAd), size: CGSize(width: UIScreen.main.bounds.width - 64, height: 200))
//                    .frame(height: 200)
//                    .padding(.horizontal, 16)
//                
//                HStack(spacing: 16) {
//                    Text(nativeAd?.price ?? "price")
//                    
//                    if let starRating = nativeAd?.starRating {
//                        let rating = starRating.doubleValue
//                        if rating >= 5 {
//                            Image("stars_5")
//                        } else if rating >= 4.5 {
//                            Image("stars_4_5")
//                        } else if rating >= 4 {
//                            Image("stars_4")
//                        } else if rating >= 3.5 {
//                            Image( "stars_3_5")
//                        } else {
//                            Text("no Rating")
//                        }
//                    } else {
//                        Text("no Rating ")
//                    }
//                    
//                    //Spacer()
//                    if let cTA = nativeAd?.callToAction {
//                        Button(action: {
//                            
//                        }, label: {
//                            Text(cTA)
//                                .padding(.horizontal, 10)
//                                .padding(.vertical, 5)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color(.systemBlue))
//                                )
//                                .foregroundColor(.white)
//                        })
//                    }
//                }
//                .font(.subheadline)
//                
//            }
//            .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)
//            .cornerRadius(10)
//            .padding(.bottom, 16)
//            
//            HStack {
//                Text("Ad")
//                    .font(.system(size: 11, weight: .semibold, design: .rounded))
//                    .padding(.horizontal, 5)
//                    .padding(.horizontal, 1)
//                    .foregroundColor(.white)
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)))
//                    )
//                Spacer()
//            }
//        }
//        .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)
//        .background(.cyan.opacity(0.3))
//    //        .cornerRadius(10)
//    }
//}
