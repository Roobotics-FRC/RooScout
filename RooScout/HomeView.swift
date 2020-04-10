//
//  HomeView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct HomeView: View {
    @Binding var status: ConnectionState

    var body: some View {
        VStack {
            MPCConnectionView(status: $status)
            Spacer()
            Text("Hello")
            Spacer()
        }
    }
}
