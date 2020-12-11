import SwiftUI

enum RelogifyColors {
    static let relogifyDark = Color(UIColor(red: 27 / 255.0, green: 20 / 255.0, blue: 100 / 255.0, alpha: 1))
    static let relogifyBlue = Color(UIColor(red: 63 / 255.0, green: 81 / 255.0, blue: 181 / 255.0, alpha: 1))
    static let relogifyRed = Color(UIColor(red: 245 / 255.0, green: 0 / 255.0, blue: 86 / 255.0, alpha: 1))
    static let relogifyLight = Color(UIColor(red: 247 / 255.0, green: 244 / 255.0, blue: 198 / 255.0, alpha: 1))
    static let darkGreen = Color(UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1))
}

func withIconButtonStyle(_ image: Image, color: Color) -> some View {
    return image
        .resizable()
        .foregroundColor(color)
        .frame(
            minWidth: 20,
            idealWidth: 50,
            maxWidth: 100,
            minHeight: 20,
            idealHeight: 100,
            maxHeight: 100,
            alignment: .center)
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
        .padding()
}

struct GlobalTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.black)
    }
}
