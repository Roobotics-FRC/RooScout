//
//  Dictionary+Sorted.swift
//  RooScoutMac
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension Dictionary where Key == MCPeerID, Value == ConnectionState {
    var sorted: [(MCPeerID, ConnectionState)] {
        return self.sorted(by: { f, s in//not, connecting, connected
            let first = f.value
            let second = s.value
            switch first {
            case .notConnected:
                return true
            case .searching:
                if second == .notConnected {
                    return false
                } else {
                    return true
                }
            case .connecting:
                if second == .notConnected || second == .searching {
                    return false
                } else {
                    return true
                }
            case .connected:
                if second == .connected {
                    return true
                } else {
                    return false
                }
            }
        })
    }
}
