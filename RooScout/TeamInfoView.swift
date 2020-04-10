//
//  TeamInfoView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import SwiftUI

struct TeamInfoView: View {

    @Binding var team: TeamInfo

    var body: some View {
        HStack {
            TextField("Team Name", text: $team.name)
            TextField("Team Number", text: $team.number).keyboardType(.numberPad)
        }.padding().background(Color.gray).cornerRadius(10)
    }
}
