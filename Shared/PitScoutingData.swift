//
//  PitScoutingData.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import RealmSwift

struct PitScoutingData: Codable {
    var team: TeamInfo

    var fitsUnderTrench: Bool

    var canDoLowGoal: Bool
    var canShoot: Bool
    var shootingLocations: [String]

    var twoPointShotPercentage: Int
    var threePointShotPercentage: Int

    var canSpinWheel: Bool

    var canClimb: Bool
    var climbTime: Int
    var canShiftCenterOfGravity: Bool

    var auton: String

    static func empty() -> PitScoutingData {
        return PitScoutingData(team: TeamInfo.empty(), fitsUnderTrench: false, canDoLowGoal: false, canShoot: false, shootingLocations: [], twoPointShotPercentage: 0, threePointShotPercentage: 0, canSpinWheel: false, canClimb: false, climbTime: 0, canShiftCenterOfGravity: false, auton: "")
    }

    func toRealmObject() -> PitScoutingDataRealmModel {
        return PitScoutingDataRealmModel(value: [
            team.toRealmObject(),
            fitsUnderTrench,
            canDoLowGoal,
            canShoot,
            shootingLocations,
            twoPointShotPercentage,
            threePointShotPercentage,
            canSpinWheel,
            canClimb,
            climbTime,
            canShiftCenterOfGravity,
            auton
        ])
    }
}

@objcMembers
class PitScoutingDataRealmModel: Object, Codable {
    dynamic var team: TeamInfoRealmModel? = TeamInfoRealmModel()

    dynamic var fitsUnderTrench: Bool = false

    dynamic var canDoLowGoal: Bool = false
    dynamic var canShoot: Bool = false
    dynamic var shootingLocations: List<String> = List()

    dynamic var twoPointShotPercentage: Int = 0
    dynamic var threePointShotPercentage: Int = 0

    dynamic var canSpinWheel: Bool = false

    dynamic var canClimb: Bool = false
    dynamic var climbTime: Int = 0
    dynamic var canShiftCenterOfGravity: Bool = false

    dynamic var auton: String = ""

    required init() {}

    func toDataModel() -> PitScoutingData? {
        guard let t = team?.toDataModel() else {
            return nil
        }
        return PitScoutingData(team: t, fitsUnderTrench: fitsUnderTrench, canDoLowGoal: canDoLowGoal, canShoot: canShoot, shootingLocations: shootingLocations.map { $0 }, twoPointShotPercentage: twoPointShotPercentage, threePointShotPercentage: threePointShotPercentage, canSpinWheel: canSpinWheel, canClimb: canClimb, climbTime: climbTime, canShiftCenterOfGravity: canShiftCenterOfGravity, auton: auton)
    }
}
