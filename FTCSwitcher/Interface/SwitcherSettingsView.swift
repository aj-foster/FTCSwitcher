import SwiftUI

struct SwitcherSettingsView: View {
    @Binding var division: Division
    @ObservedObject var atem_switcher: ATEM
    @ObservedObject var companion_switcher: Companion
    
    init(division: Binding<Division>) {
        _division = division
        atem_switcher = ATEM.get(division.id)
        companion_switcher = Companion.get(division.id)
    }
    
    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
        
        if division.switcher_settings.type == .atem {
            atem
        } else {
            companion
        }
    }
    
    var atem: some View {
        Section(header: header) {
            HStack {
                TextField(
                    text: $division.switcher_settings.host,
                    prompt: Text("Blank for USB")
                ) {
                    Text("Address")
                }
                Help(text: "Leave blank if connecting to an ATEM switcher via USB. Otherwise, input the IP address of the switcher or host:port of the Companion API.", width: 250)
            }.padding([.bottom], 5)
            HStack {
                Button(atem_switcher.state == .connected ? "Disconnect" : "Connect") {
                    if atem_switcher.state == .disconnected {
                        atem_switcher.connect(division.switcher_settings.host)
                    } else {
                        atem_switcher.disconnect()
                    }
                }
                Text(atem_switcher.error ?? " ")
            }
        }
    }
    
    var companion: some View {
        Section(header: header) {
            HStack {
                TextField(
                    text: $division.switcher_settings.host,
                    prompt: Text("host:port")
                ) {
                    Text("Address")
                }
                Help(text: "Leave blank if connecting to an ATEM switcher via USB. Otherwise, input the IP address of the switcher or host:port of the Companion API.", width: 250)
            }.padding([.bottom], 5)
            HStack {
                Button(companion_switcher.state == .connected ? "Disconnect" : "Connect") {
                    if companion_switcher.state == .disconnected {
                        companion_switcher.connect(division.switcher_settings.host)
                    } else {
                        companion_switcher.disconnect()
                    }
                }
                Text(companion_switcher.error ?? " ")
            }
        }
    }
    
    var header: some View {
        HStack {
            Text(division.switcher_settings.type == .atem ? "ATEM Switcher" : "Companion App")
                .bold()
                .padding([.trailing], 20)
            Button(division.switcher_settings.type == .atem ? "Use Companion" : "Use ATEM") {
                if division.switcher_settings.type == .atem {
                    division.switcher_settings.type = .companion
                } else {
                    division.switcher_settings.type = .atem
                }
            }
            .buttonStyle(.link)
            .disabled(division.switcher_settings.type == .atem ? atem_switcher.state == .connected : companion_switcher.state == .connected)
        }
    }
}

//#Preview("FTC Switcher") {
//    SwitcherSettingsView(settings: .constant(SwitcherSettings()), switcher: Switcher.get(Division()))
//}
