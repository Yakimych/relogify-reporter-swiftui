import SwiftUI

struct Timer: View {
    @State var extraTime: Bool
    
    var body: some View {
        VStack {
            Text("05:00")
        }
        .navigationBarTitle("Timer")
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        Timer(extraTime: false)
    }
}
