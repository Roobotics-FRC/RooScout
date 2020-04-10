//
//  MatchScoutingView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import SwiftUI

struct MatchScoutingView: View {

    @State var data: MatchScoutingData = .empty()

    var body: some View {
        ScrollView {
            TeamInfoView(team: $data.team)
            Divider()
            VStack {
                HStack {
                    Toggle(isOn: $data.doesLowGoal) {
                        Text("Does low goal?")
                    }
                    Toggle(isOn: $data.fitsUnderTrench) {
                        Text("Fits under trench?")
                    }
                }
                TextField("Match Number", value: $data.matchNumber, formatter: NumberFormatter()).keyboardType(.numberPad)
                Group {
                    Stepper("Balls Scored", value: $data.ballsScored, in: 0...50)
                    Stepper("Shot Attempts", value: $data.shotAttempts, in: 0...50)
                }
                //            var ballsScored: Int
                //            var shotAttempts: Int
                //
                //            var autonPoints: Int
                //            var climbingPoints: Int
                VStack(alignment: .center) {
                    Text("Defensive Efficiency")
                    Picker("Defensive Efficiency", selection: $data.defensiveEfficiency) {
                        ForEach(1...5, id: \.self) { num in
                            Text(String(num))
                        }
                    }.pickerStyle(SegmentedPickerStyle()).labelsHidden()
                }
            }
            Divider()
            Spacer(minLength: 20)
            Button(action: {
                self.save()
                Application.shared.endEditing()
            }) {
                Text("Save Record")
            }
            Spacer(minLength: 20)
        }.padding(.horizontal)
    }

    func save() {
        do {
            try Application.shared.realm?.write {
                Application.shared.realm?.add(data.toRealmObject())
            }
        } catch {
            print(error.localizedDescription)
        }
        data = .empty()
    }
}
