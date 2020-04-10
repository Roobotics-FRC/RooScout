//
//  PitScoutingView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import SwiftUI

struct PitScoutingView: View {

    @State var data: PitScoutingData = .empty()

    var body: some View {
        ScrollView {
            TeamInfoView(team: $data.team)
            Divider()
            Toggle(isOn: $data.fitsUnderTrench) {
                Text("Fits under Trench?")
            }.padding(.horizontal)
            VStack {
                Toggle(isOn: $data.canDoLowGoal) {
                    Text("Can Do Low Goals?")
                }
                MultipleSelectionPicker(label: "Shooting Locations", selections: $data.shootingLocations, selectionOptions: ["Trench", "Goal", "Initiation Line"], allowsOther: true)
                HStack {
                    VStack(spacing: 0) {
                        Text(String(data.twoPointShotPercentage)).font(.caption)
                        Slider(value: Binding<Double>(get: {
                            return Double(self.data.twoPointShotPercentage)
                        }, set: {
                            self.data.twoPointShotPercentage = Int($0)
                            if self.data.twoPointShotPercentage + self.data.threePointShotPercentage > 100 {
                                self.data.threePointShotPercentage = 100 - self.data.twoPointShotPercentage
                            }
                        }), in: 0...100) {
                            Text("2-Point Percentage")
                        }.labelsHidden()
                        Text("2-Point Percentage").font(.caption)
                    }
                    VStack(spacing: 0) {
                        Text(String(data.threePointShotPercentage)).font(.caption)
                        Slider(value: Binding<Double>(get: {
                            return Double(self.data.threePointShotPercentage)
                        }, set: {
                            self.data.threePointShotPercentage = Int($0)
                            if self.data.twoPointShotPercentage + self.data.threePointShotPercentage > 100 {
                                self.data.twoPointShotPercentage = 100 - self.data.threePointShotPercentage
                            }
                        }), in: 0...100) {
                            Text("3-Point Percentage")
                        }.labelsHidden()
                        Text("3-Point Percentage").font(.caption)
                    }
                } //Shooting percentages
            }.padding().background(Color.gray).cornerRadius(10)
            Toggle(isOn: $data.canSpinWheel) {
                Text("Can Spin Wheel?")
            }.padding(.horizontal)
            HStack {
                VStack {
                    Toggle(isOn: $data.canClimb) {
                        Text("Can Climb?")
                    }
                    Toggle(isOn: $data.canShiftCenterOfGravity) {
                        Text("Can Shift Center of Gravity?")
                    }
                }
                VStack {
                    Text(String(data.climbTime)).font(.caption)
                    Slider(value: Binding<Double>(get: {
                        Double(self.data.climbTime)
                    }, set: {
                        self.data.climbTime = Int($0)
                    }), in: 0...30)
                    Text("Time to Climb").font(.caption)
                }
            }.padding().background(Color.gray).cornerRadius(10)
            //            TextField("Auton", text: <#T##Binding<String>#>)
            Divider()
            Spacer(minLength: 20)
            Button(action: {
                self.save()
                Application.shared.endEditing()
            }) {
                Text("Save Record")
            }
            Spacer(minLength: 20)
        }.padding([.horizontal])
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
