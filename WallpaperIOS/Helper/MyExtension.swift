//
//  MyExtension.swift
//  WallpaperIOS
//
//  Created by Mac on 26/04/2023.
//

import SwiftUI

extension View{
    
    
    @ViewBuilder
    func EZProgressView() -> some View{
        ResizableLottieView(filename: "progress")
            .frame(width: 36, height: 36)
    }
    
    func getTag(wl : Wallpaper) -> String {
        var str : String = ""
        for tag in wl.tags{
            str.append(tag)
            str.append(" ")
        }
        return str
    }
    
    func getTag(wl : LiveWallpaper) -> String {
        var str : String = ""
        for tag in wl.tags{
            str.append(tag)
            str.append(" ")
        }
        return str
    }
    
    
    
    
    func decimaPriceToStr( price : Decimal,chia : Double) -> String{
        let decimalChia = Decimal(chia)
        let newPrice = price / decimalChia
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: newPrice)) ?? ""
    }
    
    func removeDigits( string: String) -> String {
        let characterSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
           let filteredCharacters = string.unicodeScalars.filter { !characterSet.contains($0) }
           return String(filteredCharacters)
    }
    
    
    func addBackground() -> some View{
        self.background(
            Image("BGIMG")
                .resizable()
                .ignoresSafeArea()
        ).navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
    
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    
    func placeHolderImage() -> some View{
        Image("place_holder")
            .resizable()
        
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
    
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first   as? UIWindowScene
        else{
            return .init()
        }
        guard let root = screen.windows.last?.rootViewController else{
            return .init()
        }
        return root
    }
    
    func showToastWithContent(image : String, color : Color, mess : String){
        if getRootViewController().view.subviews.contains(where: {
            view in
            return view.tag == 1008
        }){
            return
        }
        
        let rootview = ToastView(image: image, mess: mess, color: color)
        
        let toastViewController = UIHostingController(rootView: rootview)
        let size  = toastViewController.view.intrinsicContentSize
        toastViewController.view.frame.size = size
        toastViewController.view.backgroundColor = .clear
        toastViewController.view.frame.origin = CGPoint(x: ( getRect().width - size.width ) / 2 , y: getRect().height - 150)
        toastViewController.view.tag = 1008
        getRootViewController().view.addSubview(toastViewController.view)
    }
    
}
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ToastView : View{
    var image : String = "checkmark"
    var mess : String   = "Added Successfully"
    var color : Color = .green
    @State var showToast = false

    var body: some View{
        HStack(spacing: 10){
            Image(systemName: image)
                .resizable()
                .frame(width: 18, height: 18, alignment: .center)
                .foregroundColor(color)
            Text(mess)
                .mfont(16, .regular)
                .foregroundColor(.black)
            
        }
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.8))
              //  .shadow(color : .white, radius: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .offset(y : showToast ? 0 : getRect().height + 200)
        .onAppear{
            withAnimation(.easeInOut(duration: 0.5)){
                showToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                withAnimation(.easeInOut(duration: 0.5)){
                    showToast = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6){
                getRootViewController().view.subviews.forEach({
                    view in
                    if view.tag == 1008 {
                        view.removeFromSuperview()
                    }
                })
            }
            
            
        }
        
    }
}


extension View {

    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
