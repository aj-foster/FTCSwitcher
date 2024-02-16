import SwiftUI

struct ContentView: View {
    @AppStorage("divisionCount") private var division_count = 1;
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            Picker("", selection: $division_count) {
                Text("1 Division").tag(1)
                Text("2 Divisions").tag(2)
                Text("3 Divisions").tag(3)
                Text("4 Divisions").tag(4)
            }.frame(width: 200, alignment: .leading).padding(20)
            Grid {
                GridRow {
                    DivisionView(division: 1).frame(minWidth: 550).padding(20)
                    if division_count > 1 {
                        HStack { Divider() }
                        DivisionView(division: 2).frame(minWidth: 550).padding(20)
                    }
                }
                if division_count > 2 {
                    Divider()
                    GridRow {
                        DivisionView(division: 3).frame(minWidth: 550).padding(20)
                        if division_count > 3 {
                            HStack { Divider() }
                            DivisionView(division: 4).frame(minWidth: 550).padding(20)
                        }
                    }
                }
            }
            Text("Created by [FTAJ](https://youtube.com/@FTAAJ). If this application helped you, please consider making a [donation](https://donate.stripe.com/eVa8A63oQ0drcF2aEE) to the Orlando Robotics Foundation.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 320)
                .font(.system(size: 10))
                .padding([.top, .bottom], 20)
        }
    }
}

#Preview("FTC Switcher") {
    ContentView()
}
