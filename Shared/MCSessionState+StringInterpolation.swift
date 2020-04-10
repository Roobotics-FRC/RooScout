//
//  MCSessionState+StringInterpolation.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: MCSessionState) {
        switch value {
        case .connected:
            appendLiteral("MCSessionState(connected)")
        case .connecting:
            appendLiteral("MCSessionState(connecting)")
        case .notConnected:
            appendLiteral("MCSessionState(not connected)")
        @unknown default:
            fatalError("Unknown MCSessionState")
        }
    }
}

extension MCSessionState: CustomStringConvertible {
    var color: Color {
        switch self {
        case .connected:
            return .green
        case .connecting:
            return .yellow
        case .notConnected:
            return .red
        @unknown default:
            fatalError("Unknown MCSessionState")
        }
    }

    public var description: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .notConnected: return "Not Connected"
        @unknown default: fatalError("Unknown MCSessionState")
        }
    }
}
