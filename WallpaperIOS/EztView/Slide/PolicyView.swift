//
//  PolicyView.swift
//  WallpaperIOS
//
//  Created by Mac on 30/05/2023.
//

import SwiftUI

struct PolicyView: View {
    let policyText =
   " Privacy Policy: \n" +
    
   " – Personal information: We do NOT collect any Personal Information about you. “Personal Information” means personally identifiable information, such as your name, email address, physical address, calendar entries, contact entries, files, photos, etc. \n" +
  "  – Non-personal information: non-personal information about your use of our apps is collected and aggregated without being able to identify yourself specifically. “Non-Personal Information” means information that is of an anonymous nature, such as the type of mobile device you use, your mobile devices unique device ID, your mobile operating system, the length of a session when you use the app and potential crashes. We do not store this data.  \n" +
  "  – Face data: we do not collect or store face data in our apps. \n " +
   " – Security: We are very concerned about safeguarding the confidentiality of your information. We do not collect Personal Information, and we employ administrative, physical and electronic measures designed to protect your Non-Personal Information from unauthorized access and use.  \n" +
  "  – Your privacy: We do not store or retain any personal information that can be used to identify you (the end-user). No data specific to the end-user will be shared or sold to third parties. We have no interest in housing and storing users’ personal information or data.  \n" +
  "  – Crashlytics: We use Crashlytics to collect crash reports and anonymous statistical information. This helps us to fix bugs. If you do have a crash, then we may upload logging information to help diagnose the crash.  \n" +
 "   – Contact: If you have any questions or comments about this Privacy Policy or any other issues regarding our apps or services, please contact us at phonexlaucher@gmail.com "


  
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("light_mode", store: .standard) var isLight : Bool = false
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing : 0){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Image( "back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    
                }).frame(width: 44, height: 44)
                Spacer()
                Text( "Privacy Policy" )
                    .foregroundColor(.main)
                    .mfont(20, .bold)
                
                Spacer()
               
                Rectangle().fill(Color.clear).frame(width: 44, height: 44)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height : 44)
            ScrollView(.vertical, showsIndicators: false){
                Text(policyText)
                    .font(.system(size: 14))
                     .multilineTextAlignment(.leading)
                     .foregroundColor(Color.white)
                     .padding(16)
            }
          
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
         
            .addBackground()
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}

