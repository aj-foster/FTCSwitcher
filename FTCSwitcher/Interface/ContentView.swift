import SwiftUI

struct ContentView: View {
    @AppStorage("divisionCount") private var division_count = 1;
    
    var body: some View {
        VStack {
            HStack {
                ForEach(1...division_count, id: \.self) { division in
                    DivisionView()
                    if division < division_count { Divider() }
                }
            }
            Text("Created by [FTAJ](https://youtube.com/@FTAAJ). If this application helped you, please consider making a [donation](https://donate.stripe.com/eVa8A63oQ0drcF2aEE) to the Orlando Robotics Foundation.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 320)
                .font(.system(size: 10))
                .padding([.bottom], 20)
        }
    }
}

#Preview("FTC Switcher") {
    ContentView()
}
