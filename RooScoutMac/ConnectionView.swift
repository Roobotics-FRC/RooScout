//
//  ConnectionView.swift
//  RooScoutMac
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    init(connections: [MCPeerID: ConnectionState], status: ConnectionState, blacklist: Binding<[MCPeerID]>) {
        self.connections = connections
        self.sorted = self.connections.sorted
        self.status = status
        self._blacklist = blacklist
    }
    let connections: [MCPeerID: ConnectionState]

    private var sorted: [(MCPeerID, ConnectionState)]

    var status: ConnectionState

    @State private var isPopping: Bool = false
    @Binding var blacklist: [MCPeerID]

    var body: some View {
        HStack {
            StatusLightView(status: status)
            Text(status.description).onTapGesture {
                self.isPopping = true
            }.popover(isPresented: $isPopping) {
                List {
                    ForEach(self.sorted, id: \.0) { (peer, state) in
                        UserConnectionListItem(peer: peer, state: state, blacklist: self._blacklist)
                    }
                }
            }
        }
    }
}
