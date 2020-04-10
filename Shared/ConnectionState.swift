//
//  ConnectionState.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

enum ConnectionState: CustomStringConvertible {
    case notConnected
    case searching
    case connecting
    case connected

    var color: Color {
        switch self {
        case .connected:
            return .green
        case .connecting:
            return .yellow
        case .searching:
            return .blue
        case .notConnected:
            return .red
        }
    }

    var description: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .searching:
            #if os(macOS)
            return "Hosting"
            #else
            return "Searching"
            #endif
        case .notConnected: return "Not Connected"
        }
    }

    init(_ c: MCSessionState) {
        switch c {
        case .connected: self = .connected
        case .connecting: self = .connecting
        case .notConnected: self = .notConnected
        @unknown default:
            fatalError("Unknown MCSessionState")
        }
    }
}
