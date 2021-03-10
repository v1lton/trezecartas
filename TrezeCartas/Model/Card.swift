//
//  Card.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 09/02/21.
//

import Foundation
import SwiftUI

class Attributtes: Codable, ReflectedStringConvertible{
    
    var healthStats: Int?
    var moneyStats: Int?
    var insanityStats: Int?
    
    var dependsFrom: Int?
    var isAmongFriends: Bool?
    var isDating: Bool?
    var hasKissed: Bool?
    var isHurt: Bool?
    var isDirty: Bool?
    var hasLostPhone: Bool?
    
    enum CodingKeys: String, CodingKey {
        case healthStats = "health_stats"
        case moneyStats = "money_stats"
        case insanityStats = "insanityStats"
        case dependsFrom = "depends_from"
        case isAmongFriends = "is_among_friends"
        case isDating = "is_dating"
        case hasKissed = "has_kissed"
        case isHurt = "is_hurt"
        case isDirty = "is_dirty"
        case hasLostPhone = "has_lost_phone"
    }
    
    init(){
        self.healthStats = 10
        self.moneyStats = 10
        self.insanityStats = 0
    }
    
    func isGameOver()->Bool{
        return healthStats == 0 && moneyStats == 0 &&  insanityStats == 0
    }
    
}

class JSONCard: Attributtes{
    var id: Int
    var name: String
    var text: String
    var leftText: String
    var rightText: String
    var leftResult: String
    var rightResult: String
    var rightResultText: String
    var leftResultText: String
    var imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name
        case text = "description"
        case leftText = "left_text"
        case rightText = "right_text"
        case leftResult = "left_result"
        case rightResult = "right_result"
        case leftResultText = "left_result_text"
        case rightResultText = "right_result_text"
        case imageName = "image_name"
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.text = try container.decode(String.self, forKey: .text)
        self.leftText = try container.decode(String.self, forKey: .leftText)
        self.rightText = try container.decode(String.self, forKey: .rightText)
        self.leftResult = try container.decode(String.self, forKey: .leftResult)
        self.rightResult = try container.decode(String.self, forKey: .rightResult)
        self.leftResultText = try container.decode(String.self, forKey: .leftResultText)
        self.rightResultText = try container.decode(String.self, forKey: .rightResultText)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        
        try super.init(from: decoder)
        
        translateResults()
    }
    
    func translateResults(){
        do{
            let jsonData = leftResult.data(using: String.Encoding.utf8)!
            let json = try JSONDecoder().decode(Attributtes.self, from: jsonData)
            print(json)
            
            
        }
        catch{
            print(error)
        }
    }
}

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
