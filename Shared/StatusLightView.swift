//
//  StatusLightView.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI

struct StatusLightView: View {
    let status: ConnectionState

    var body: some View {
        ZStack {
            Circle().frame(width: 18, height: 18, alignment: .center).foregroundColor(Color.black)
            Circle().frame(width: 13, height: 13, alignment: .center).foregroundColor(status.color)
        }
    }
}
