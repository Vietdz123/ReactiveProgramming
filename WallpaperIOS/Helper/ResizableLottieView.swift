//
//  ResizableLottieView.swift
//  WallpaperIOS
//
//  Created by Mac on 17/05/2023.
//

import SwiftUI
import Lottie

struct ResizableLottieView: UIViewRepresentable {
    var filename : String
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
      
        let animationView = LottieAnimationView(name: filename, bundle: .main)
    
        animationView.shouldRasterizeWhenIdle = true
        animationView.loopMode = .repeat(.infinity)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ]
        
        view.addSubview(animationView)
        view.addConstraints(constraints)
        animationView.play()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}



struct Z_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ResizableLottieView(filename: "viewmore")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
