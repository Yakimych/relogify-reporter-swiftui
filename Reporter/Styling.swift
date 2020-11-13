import SwiftUI

struct TimerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
    }
}

func withIconButtonStyle(_ image: Image) -> some View {
    return image
        .resizable()
        .frame(
            minWidth: 20,
            idealWidth: 50,
            maxWidth: 100,
            minHeight: 20,
            idealHeight: 100,
            maxHeight: 100,
            alignment: .center)
        .padding()
}
