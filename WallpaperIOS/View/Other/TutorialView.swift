//
//  TutorialView.swift
//  WallpaperIOS
//
//  Created by Mac on 08/05/2023.
//

import SwiftUI

import SwiftUI

// MARK: - Tutorial Step
struct TutorialStep {
    let title: String
    let subtitle: String?
}

let steps: [TutorialStep] = [
    .init(title: "Open Photos on your iPhone.", subtitle: ""),
    .init(title: "Choose an image.", subtitle: ""),
    .init(title: "Tap lower-left button.", subtitle: ""),
    .init(title: "Swipe up.", subtitle: ""),
    .init(title: "Tap User as Wallpaper.", subtitle: ""),
    .init(title: "Move the image and choose a display option. Tap Set. ", subtitle: ""),
    .init(title: "Set the wallpaper and choose where you want it to show up.", subtitle: "")
]

/// Show app tutorial flow
struct TutorialContentView: View {
    
    @Environment(\.presentationMode) var presentation
    @State private var selectedIndex: Int = 0
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
           
  
              
        
    
            VStack(spacing: 0) {
                HeaderTitleView
                TabView(selection: $selectedIndex) {
                    ForEach(0..<steps.count, id: \.self) { step in
                        TutorialStepView(atIndex: step)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack {
                    ForEach(0..<steps.count, id: \.self) { dot in
                        Circle().frame(width: 6, height: 10)
                            .foregroundColor(.white)
                            .opacity(dot == selectedIndex ? 1 : 0.3)
                    }
                }.padding(.top, 20)
                Spacer()
            }
            
            /// Close navigation button
           
        }
    }
    

    
    /// Header title view
    private var HeaderTitleView: some View {
        
        VStack{
            HStack {
                Spacer()
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .padding(16)
                })
                
                
               
            }
            
            Text("Wallpaper Guide".toLocalize())
                .mfont(20, .bold)
                .foregroundColor(.yellow)
                .padding(.bottom)
        }
            
      
        
      
        
    
    }
    
    private func TutorialStepView(atIndex index: Int) -> some View {
        VStack(spacing: 20) {
           
            Image("Step\(index+1)")
                .resizable().aspectRatio(contentMode: .fit)
            
            VStack {
               
                VStack(alignment: .center) {
           
                    Text( String(format: NSLocalizedString("Step %@", comment: ""), "\(index + 1)") )
                        .mfont(16, .bold)
                    
                    Text(steps[index].title.toLocalize())
                        .mfont(14, .regular)
                  
                }
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            }.foregroundColor(.white)
            
        }.padding([.leading, .trailing])
    }
}

// MARK: - Preview UI
struct TutorialContentView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialContentView()
    }
}

