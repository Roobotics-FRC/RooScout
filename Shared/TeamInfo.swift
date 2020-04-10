//
//  TeamInfo.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import RealmSwift

struct TeamInfo: Codable {
    var name: String
    var number: String

    static func empty() -> TeamInfo {
        return TeamInfo(name: "", number: "")
    }

    func toRealmObject() -> TeamInfoRealmModel {
        return TeamInfoRealmModel(value: [
            name,
            number
        ])
    }
}

@objcMembers
class TeamInfoRealmModel: Object, Codable {
    dynamic var name: String = ""
    dynamic var number: String = ""

    required init() {}

    func toDataModel() -> TeamInfo {
        return TeamInfo(name: name, number: number)
    }
}
