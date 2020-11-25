import SwiftUI

struct ChooseCommunity: View {
    @State private var communityName: String = ""
    @Binding var isAddingPlayerInCommunity: Bool

    private func canProceed() -> Bool {
        return communityName != ""
    }

    private func getNextButtonColor() -> Color {
        if canProceed() {
            return Color.blue
        }
        return Color(UIColor.lightGray)
    }

    var body: some View {
        ZStack {
            RelogifyColors.relogifyLight

            VStack {
                VStack {
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .foregroundColor(Color.blue)
                            .frame(
                                minWidth: 10,
                                idealWidth: 50,
                                maxWidth: 50,
                                minHeight: 10,
                                idealHeight: 50,
                                maxHeight: 50,
                                alignment: .center)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)

                        Text("The community name is the last part of your Relogify URL")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 40, trailing: 0))


                VStack(alignment: .leading) {
                    Text("Community name")
                        .font(.callout)
                        .bold()
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("https://relogify.com/").font(.subheadline)
                        TextField("communityname", text: $communityName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                }

                NavigationLink(
                    destination: ChoosePlayer(communityName: communityName, isAddingPlayerInCommunity: $isAddingPlayerInCommunity)
                ) {
                    withIconButtonStyle(Image(systemName: "arrow.right.circle"), color: getNextButtonColor())
                }
                .isDetailLink(false)
                .disabled(!canProceed())
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("Choose community", displayMode: .inline)
        .navigationBarColor(UIColor(RelogifyColors.relogifyBlue))
    }
}

struct ChooseCommunity_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCommunity(isAddingPlayerInCommunity: .constant(true))
            .environmentObject(PlayersInCommunitiesStorage())
    }
}
