//
//  UserConnectionListItem.swift
//  RooScoutMac
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct UserConnectionListItem: View {
    @State var enabled: Bool = true

    let peer: MCPeerID
    let state: ConnectionState

    @Binding var blacklist: [MCPeerID]

    var body: some View {
        HStack {
            StatusLightView(status: state)
            Text(peer.displayName)
        }.onTapGesture {
            if self.enabled {
                MPC.shared.disconnect(self.peer)
                self.enabled = false
                self.blacklist.append(self.peer)
            } else {
                if let i = self.blacklist.firstIndex(of: self.peer) {
                    self.blacklist.remove(at: i)
                }
                self.enabled = true
                if self.state == .searching {
                    MPC.shared.add(peer: self.peer)
                }
            }
        }.opacity(enabled ? 1 : 0.5)
    }
}
