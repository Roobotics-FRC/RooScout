//
//  DataTransmission.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation

struct DataTransmission: Codable {
    let pitData: [PitScoutingData]
    let matchData: [MatchScoutingData]
}
