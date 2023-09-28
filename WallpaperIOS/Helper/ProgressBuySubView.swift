//
//  ProgressBuySubView.swift
//  WallpaperIOS
//
//  Created by Duc on 21/09/2023.
//

import SwiftUI

extension View{
    func showProgressSubView() {
        DispatchQueue.main.async {
            if getRootViewController().view.subviews.contains(where: {
                view in
                return view.tag == 134
            }){
                return
            }
            
            let rootview = ProgressBuySubView()
            
            let toastViewController = UIHostingController(rootView: rootview)
            
            toastViewController.view.frame.size = CGSize(width: getRect().width, height: getRect().height)
            toastViewController.view.backgroundColor = .clear
            toastViewController.view.frame.origin = CGPoint(x: 0 , y:  0)
            toastViewController.view.tag = 134
            getRootViewController().view.addSubview(toastViewController.view)
        }
    }
    
    func hideProgressSubView(){
        print("Hide Progress View")
        DispatchQueue.main.async {
            getRootViewController().view.subviews.forEach({
                view in
                print("Hide Progress View \(view.tag)")
                if view.tag == 134 {
                    view.removeFromSuperview()
                }
                
              
                
            })
        }
    }
}

struct ProgressBuySubView: View {
    var body: some View {
        VStack(spacing : 0){
            ResizableLottieView(filename: "loadingcat")
                .frame(width : 250 , height: 250)
            
            Text("Starting your wonderful journey...")
                .mfont(17,  .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Please don’t close the page")
                .mfont(15, .regular)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Spacer()
                .frame(height: 200)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea()
            )
//            .onTapGesture {
//                hideProgressSubView()
//            }
    }
}

#Preview {
    ProgressBuySubView()
}
