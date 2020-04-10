//
//  DataSendingView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity
import SwiftyHUDView

struct DataSendingView: View {
    @Binding var status: ConnectionState

    @State private var isLoading: Bool = false

    var body: some View {
        SwiftyHUDView(isShowing: $isLoading) {
            VStack {
                MPCConnectionView(status: self.$status)
                Divider()
                Button(action: {
                    self.send()
                }) {
                    Text("Send")
                }.disabled(self.status != .connected)
                Spacer()
            }
        }
    }

    func send() {
        guard let realm = Application.shared.realm else {
            return
        }
        let pits = realm.objects(PitScoutingDataRealmModel.self).map { $0.toDataModel()! } as [PitScoutingData]
        let matches = realm.objects(MatchScoutingDataRealmModel.self).map { $0.toDataModel()! } as [MatchScoutingData]
        let data = DataTransmission(pitData: pits, matchData: matches)
        MPC.shared.send(try! JSONEncoder().encode(data))
        try? realm.write {
            realm.deleteAll()
        }

        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            self.isLoading = false
        }
    }
}
