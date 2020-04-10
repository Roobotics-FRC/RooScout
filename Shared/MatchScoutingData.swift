//
//  MatchScoutingData.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import RealmSwift

struct MatchScoutingData: Codable {
    var team: TeamInfo

    var doesLowGoal: Bool

    var fitsUnderTrench: Bool

    var matchNumber: Int

    var ballsScored: Int
    var shotAttempts: Int

    var autonPoints: Int
    var climbingPoints: Int

    var defensiveEfficiency: Int

    static func empty() -> MatchScoutingData {
        return MatchScoutingData(team: TeamInfo.empty(), doesLowGoal: false, fitsUnderTrench: false, matchNumber: 0, ballsScored: 0, shotAttempts: 0, autonPoints: 0, climbingPoints: 0, defensiveEfficiency: 0)
    }

    func toRealmObject() -> MatchScoutingDataRealmModel {
        return MatchScoutingDataRealmModel(value: [
            team.toRealmObject(),
            doesLowGoal,
            fitsUnderTrench,
            matchNumber,
            ballsScored,
            shotAttempts,
            autonPoints,
            climbingPoints,
            defensiveEfficiency
        ])
    }
}

@objcMembers
class MatchScoutingDataRealmModel: Object, Codable {
    dynamic var team: TeamInfoRealmModel? = TeamInfoRealmModel()

    dynamic var doesLowGoal: Bool = false

    dynamic var fitsUnderTrench: Bool = false

    dynamic var matchNumber: Int = 0

    dynamic var ballsScored: Int = 0
    dynamic var shotAttempts: Int = 0

    dynamic var autonPoints: Int = 0
    dynamic var climbingPoints: Int = 0

    dynamic var defensiveEfficiency: Int = 0

    required init() {}

    func toDataModel() -> MatchScoutingData? {
        guard let t = team?.toDataModel() else {
            return nil
        }
        return MatchScoutingData(team: t, doesLowGoal: doesLowGoal, fitsUnderTrench: fitsUnderTrench, matchNumber: matchNumber, ballsScored: ballsScored, shotAttempts: shotAttempts, autonPoints: autonPoints, climbingPoints: climbingPoints, defensiveEfficiency: defensiveEfficiency)
    }
}
