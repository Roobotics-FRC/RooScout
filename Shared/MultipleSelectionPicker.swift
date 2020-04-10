//
//  MultipleSelectionPicker.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import SwiftUI

struct MultipleSelectionPicker: View {
    let label: String

    @Binding var selections: [String]

    @State private var modal: Bool = false
    @State private var input: String = ""

    let selectionOptions: [String]
    let allowsOther: Bool

    var body: some View {
        Button(action: {
            self.modal = true
        }) {
            Text(label)
        }.sheet(isPresented: $modal) {
            List {
                ForEach((self.selectionOptions + self.selections).unique, id: \.self) { option in
                    SelectionRow(selection: option, selected: Binding(get: {
                        return self.selections.contains(option)
                    }, set: { newVal in
                        self.selections = self.selections.filter { str in str != option } + (newVal ? [option] : [])
                    }))
                }
                if self.allowsOther {
                    TextField("Other...", text: self.$input) {
                        self.selections.append(self.input)
                        self.input = ""
                    }
                }
            }
        }
    }
}

struct SelectionRow: View {
    let selection: String

    @Binding var selected: Bool

    var body: some View {
        Button(action: {
            self.selected.toggle()
        }) {
            HStack {
                Text(selection)
                Spacer()
                if selected {
                    #if os(macOS)
                    Text("􀆅")
                    #else
                    Image(systemName: "checkmark")
                    #endif
                }
            }
        }
    }
}
