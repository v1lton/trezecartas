//
//  Card.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 09/02/21.
//

import Foundation
import SwiftUI

struct Card: Hashable, CustomStringConvertible {
    var id: Int
    
    let cardImage: UIImage
    let cardName: String
    let cardText: String
    let leftOption: String
    let rightOption: String
    let leftAnswer: String
    let rightAnswer: String
    let leftStatus: [Int]
    let rightStatus: [Int]
    
    var description: String {
        return "\(cardName), id: \(id)"
    }
}
