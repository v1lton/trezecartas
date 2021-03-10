//
//  ExtensionClamped.swift
//  TrezeCartas
//
//  Created by Matheus Andrade on 10/03/21.
//

import SwiftUI

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
