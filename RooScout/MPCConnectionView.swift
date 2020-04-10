//
//  MPCConnectionView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct MPCConnectionView: View {
    @Binding var status: ConnectionState

    var body: some View {
        HStack {
            StatusLightView(status: status)
            Text(status.description)
            if status == .notConnected {
                Spacer()
                Button(action: {
                    MPC.shared.startSearching()
                    withAnimation {
                        self.status = .searching
                    }
                }) {
                    Text("Connect")
                }
            } else if status == .searching {
                Spacer()
                Button(action: {
                    MPC.shared.stopSearching()
                    withAnimation {
                        self.status = .notConnected
                    }
                }) {
                    Text("Cancel")
                }
            }
        }.padding([.horizontal])
    }
}
