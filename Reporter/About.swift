import SwiftUI

let relogifyUrl = "https://relogify.com"

let featureList = """
• Weekly Results and Leaderboards
• Head-to-Head results and statistics
• Individual player results, stats and winning streaks
• All-time history and Elo ratings
"""

struct About: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Relogify Reporter").font(.title2).padding()
                Text("Manage multiple Relogify communities and add results against other players.")
                    .multilineTextAlignment(.center)

                Link("Additional features at relogify.com:", destination: URL(string: relogifyUrl)!)
                    .font(.title3)
                    .padding()
                Text(featureList).font(.subheadline)

                Link(destination: URL(string: relogifyUrl)!, label: {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                })
            }.navigationBarTitle("About", displayMode: .inline)
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
