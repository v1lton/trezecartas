//
//  Card.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 09/02/21.
//

import Foundation
import SwiftUI

class Attributtes: Codable, ReflectedStringConvertible, CustomStringConvertible{
    
    var healthStats: Int?
    var moneyStats: Int?
    var insanityStats: Int?
    
    var dependsFrom: Int?
    
    var isAmongFriends: Bool?
    var isDrunk: Bool?
    var hasKissed: Bool?
    var isTired: Bool?
    var isDirty: Bool?
    var brokenHeart: Bool?
    
    var endGame: String?
    
    enum CodingKeys: String, CodingKey {
        case healthStats = "health_stats"
        case moneyStats = "money_stats"
        case insanityStats = "insanity_stats"
        case dependsFrom = "depends_from"
        case isAmongFriends = "is_among_friends"
        case isDrunk = "is_drunk"
        case hasKissed = "has_kissed"
        case isTired = "is_tired"
        case isDirty = "is_dirty"
        case brokenHeart = "broken_heart"
        case endGame = "end_game"
    }
    
    init(){
        self.healthStats = 10
        self.moneyStats = 10
        self.insanityStats = 0
    }
    
    func isGameOver()->Bool{
        return healthStats == 0 && moneyStats == 0 &&  insanityStats == 0
    }
    
    func mirror() -> [String : Bool]{
        
        let properties = Mirror(reflecting: self).children
        
        let boolNonNullProperties = properties.compactMap{($0.label , $0.value) as? (String , Bool)}
        
        let dict = boolNonNullProperties.reduce([String : Bool]()){dict, item in
            var dict = dict
            dict[item.0] = item.1
            return dict
        }
        
        return dict
    }
    
}



class JSONCard: Attributtes{
    
    
    var uid: Int
    
    var id: Int = 0
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
        case uid = "ID"
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
        self.uid = try container.decode(Int.self, forKey: .uid)
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
        
    }
    
    private override init(){
        self.id = 0
        self.uid = Int(randomString(length: 5))!
        self.name = randomString(length: 5)
        self.text = randomString(length: 5)
        self.leftText = randomString(length: 5)
        self.rightText = randomString(length: 5)
        self.leftResult = randomString(length: 5)
        self.rightResult = randomString(length: 5)
        self.leftResultText = randomString(length: 5)
        self.rightResultText = randomString(length: 5)
        self.imageName = "XeroV1_Ilu_19Sede"
        super.init()
    }
    class func placebo() -> JSONCard{
        return JSONCard()
    }
    
    
    func change(new: JSONCard){
        self.uid = new.uid
        self.name = new.name
        self.text = new.text
        self.leftText = new.leftText
        self.rightText = new.rightText
        self.leftResult = new.leftResult
        self.rightResult = new.rightResult
        self.leftResultText = new.leftResultText
        self.rightResultText = new.rightResultText
        self.imageName = new.imageName
        self.healthStats = new.healthStats
        self.moneyStats = new.moneyStats
        self.insanityStats = new.insanityStats
        self.endGame = new.endGame
        
    }
    
    func getResult(direction: CardView.LeftRight) throws -> Attributtes{
        
        if direction == .left{
            let jsonData = leftResult.data(using: String.Encoding.utf8)!
            let json = try JSONDecoder().decode(Attributtes.self, from: jsonData)
            
            return json
        }
        else if direction == .right{
            let jsonData = rightResult.data(using: String.Encoding.utf8)!
            let json = try JSONDecoder().decode(Attributtes.self, from: jsonData)
            
            return json
        }
        else{
            return Attributtes()
        }
    }
    
    var description: String {
        return "\(name), id: \(id)"
    }
    
    func with(id: Int) -> JSONCard{
        self.id = id
        return self
    }
}
func randomString(length: Int) -> String {
  let letters = "0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

