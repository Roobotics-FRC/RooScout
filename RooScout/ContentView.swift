//
//  ContentView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity
import Combine

struct ContentView: View {
    @State var theAlert: String = ""
    @State var newAlert = false

    @State var status: ConnectionState = .notConnected
    @State private var server: MCPeerID? = nil

    var body: some View {
        VStack {
            Text("RooBotics Scouting").font(.title)
            Divider()
            TabView {
                HomeView(status: $status).tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(1)
                PitScoutingView().tabItem {
                    VStack {
                        Image(systemName: "doc.on.clipboard")
                        Text("Pit Scouting")
                    }
                }.tag(2)
                MatchScoutingView().tabItem {
                    VStack {
                        Image(systemName: "eye")
                        Text("Match Scouting")
                    }
                }.tag(3)
                DataSendingView(status: $status).tabItem {
                    VStack {
                        Image(systemName: "tray.and.arrow.up.fill")
                        Text("Send Data")
                    }
                }.tag(4)
            }
        }.alert(isPresented: $newAlert) {
            Alert(title: Text(theAlert))
        }.onReceive(MPC.shared.statePublisher.receive(on: RunLoop.main)) { peer, state in
            if peer == self.server {
                withAnimation {
                    switch state {
                    case .connected: self.status = .connected
                    case .connecting: self.status = .connecting
                    case .notConnected:
                        self.status = MPC.shared.isSearching ? .searching : .notConnected
                    @unknown default:
                        fatalError("Unknown MCSessionState")
                    }
                }
            } else {
                print("Peer \(peer.displayName) state changed to \(state)")
            }
        }.onReceive(MPC.shared.invitationPublisher.receive(on: RunLoop.main)) { peer, _, join in
            self.server = peer
            join(true)
            MPC.shared.stopSearching()
        }.onReceive(MPC.shared.dataPublisher.receive(on: RunLoop.main)) { peer, data in
            if peer == self.server {
                if data == Data(repeating: 0, count: 1) {
                    MPC.shared.end()
                    self.theAlert = "Server disconnected you!"
                    self.newAlert = true
                    return
                }
                if let str = String(data: data, encoding: .utf8) {
                    self.theAlert = str
                    self.newAlert = true
                }
                print("Server sent non-UTF8 message")
            } else {
                print("Peer \(peer.displayName) sent message:\n\t\(String(data: data, encoding: .utf8) ?? "Non-UTF8 message!")")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
