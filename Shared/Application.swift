//
//  Application.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

class Application {
    static let shared = Application()

    func endEditing() {
        #if os(macOS)
        NSApplication.shared.sendAction(#selector(NSResponder.resignFirstResponder), to: nil, from: nil)
        #elseif os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }

    var realm: Realm? = try? Realm()
}
