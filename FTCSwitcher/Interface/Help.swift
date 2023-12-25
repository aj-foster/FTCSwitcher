//
//  HelpView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct HelpView: View {
    @State var text: String
    @State private var showPopover = false
    @State var width: CGFloat = 300
    
    var body: some View {
        Button("Help", systemImage: "questionmark.circle") {
            showPopover = true
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.link)
        .popover(isPresented: $showPopover) {
            Text(text)
                .padding(10)
                .frame(width: width, alignment: .leading)
        }
    }
}
