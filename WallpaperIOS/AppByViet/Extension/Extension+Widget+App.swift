//
//  Extension+Widget+App.swift
//  eWidget
//
//  Created by MAC on 22/12/2023.
//

import SwiftUI

//extension View {
//    func cornerRadiusWithBorder(radius: CGFloat, borderLineWidth: CGFloat = 1, borderColor: Color = .gray, antialiased: Bool = true) -> some View {
//        modifier(ModifierCornerRadiusWithBorder(radius: radius, borderLineWidth: borderLineWidth, borderColor: borderColor, antialiased: antialiased))
//    }
//}

fileprivate struct ModifierCornerRadiusWithBorder: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(self.radius, antialiased: self.antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: self.radius)
//                    .inset(by: self.borderLineWidth)
                    .strokeBorder(self.borderColor, lineWidth: self.borderLineWidth, antialiased: self.antialiased)
            )
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    var backroundColorLottie: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }
    
    static let primaryBlue = UIColor(rgb: 0x499AE9)
}

extension String {
    
    func hexStringToInt() -> Int {
        // Remove the "0x" prefix if it exists
        let cleanString = self.replacingOccurrences(of: "#", with: "")

        // Convert the cleaned string to an integer
        return Int(cleanString, radix: 16) ?? 0xFFFFFF
    }
    
}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    var pathExtension: String {
        return fileURL.pathExtension
    }
    
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
    var fileName: String {
        return fileURL.lastPathComponent
    }
}

extension Font {
     func SVNAvoFont(_ type: SVNAvoFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(type.rawValue, size: size)
     }
    
    func AmaranthFont(size: CGFloat = 16) -> SwiftUI.Font {
       SwiftUI.Font.custom("Amaranth", size: size)
    }
}

extension View {
    
    var titleColor: Color {
        Color(red: 0.2, green: 0.2, blue: 0.2)
    }
    
    var backroundColorLottie: Color {
        return Color.black.opacity(0.1)
    }
    
    func SVNAvoFont(_ type: SVNAvoFont,
                    size: CGFloat,
                    textColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
    ) -> some View {
        self
            .foregroundColor(textColor)
            .font(.custom(type.rawValue, size: size))
    }
    
    func SFUFuturaFont(_ type: SFUFuturaFont,
                    size: CGFloat,
                    textColor: Color = Color(red: 0.27, green: 0.27, blue: 0.27)
    ) -> some View {
        self
            .foregroundColor(textColor)
            .font(.custom(type.rawValue, size: size))
    }
    
    func orbitronFont(_ type: OrbitronFont,
                    size: CGFloat,
                      textColor: Color = .white
    ) -> some View {
        self
            .foregroundColor(textColor)
            .font(.custom(type.rawValue, size: size))
    }
    
    func AmaranthFont(size: CGFloat = 16,
                      textColor: Color = Color(red: 0.27, green: 0.27, blue: 0.27)
    ) -> some View {
        self
            .foregroundColor(textColor)
            .font(.custom("Amaranth", size: size))
    }
}

enum OrbitronFont: String {
    case bold = "Orbitron-Bold"
    case medium = "Orbitron-Medium"
    case regular = "Orbitron-Regular"
    case semibold = "Orbitron-SemiBold"
}

enum SVNAvoFont: String {
    case avo = "SVN-Avo"
    case bold = "SVN-Avobold"
    case boldItalic = "SVN-Avobolditalic"
}

enum SFUFuturaFont: String {
    case bold = "SFUFuturaBold"
    case book = "SFUFuturaBook"
    case extraBook = "SFUFuturaExtraBold"
    case light = "SFUFuturaLight"
    case regular = "SFUFutura"
}

enum RighteousFont: String {
    case regular = "Righteous-Regular"
}

extension UIFont {
    
    static func fontSFUFuturaBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUFuturaBold", size: size)
    }
    
    static func fontSFUFuturaBook(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUFuturaBook", size: size)
    }
    
    static func fontSFUFuturaRegular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUFutura", size: size)
    }
    
    static func fontSFUFuturaLight(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUFuturaLight", size: size)
    }
    
    static func fontSVNAVoBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SVN-Avobold", size: size)
    }
    
    static func fontSVNAVoRegular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SVN-Avo", size: size)
    }
    
    
}



extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: Int(CGFloat(r)),
            green: Int(CGFloat(g)),
            blue: Int(CGFloat(b)))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
