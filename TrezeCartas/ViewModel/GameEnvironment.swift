//
//  CardData.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI


class GameEnvironment: ObservableObject {
    
    @Published var cards: [JSONCard] = []
    @Published var maxID = 13
    
    @Published var attributes: Attributtes
    
    var blockEndingText: String = ""
    
    
    
    init(){
        attributes = Attributtes()

        reset()


        
    }
    
    func reset() {
        attributes = Attributtes()
        
        guard let jsonPath = Bundle.main.path(forResource: "TeXeroCards", ofType: "txt") else { fatalError() }

        do {
            let jsonData = try String(contentsOfFile: jsonPath, encoding: String.Encoding.utf8).data(using: String.Encoding.utf8)!
            var jsonArray = try JSONDecoder().decode([JSONCard].self, from: jsonData)
            
            jsonArray.shuffle()
            
            
            for i in 0 ..<  jsonArray.count {
                jsonArray[i].id = i
                print(jsonArray[i])
            }
            
            maxID = jsonArray.count - 1
            cards = jsonArray
            
        } catch{
            print("its a thursday")
            print(error)
        }
        
        //shuffleCards()
        self.objectWillChange.send()
    }

    
    public func shuffleCards(){
//        //pegar todas as cartas originais
//        var shuffledCards = GameEnvironment.originalCards.shuffled()
//
//        //adicionar apenas uma carta de bloqueamento
//        let blockCard = GameEnvironment.blockCards.randomElement()!
//        blockEndingText = GameEnvironment.blockEndings[blockCard.id]
//
//        shuffledCards.append(blockCard)
//        shuffledCards.shuffle()
//
//        //limpar para ter apenas 13 cartas de jogo
//        shuffledCards.removeLast(shuffledCards.count - 15)
//
//        //se o ultimo for o block da o shuffle de novo
//        while shuffledCards.last == blockCard{
//            shuffledCards.shuffle()
//        }
//
//        //adicionar cartas iniciais
//        if !UserDefaults.standard.bool(forKey: "has_completed_onboarding_once_key"){
//            shuffledCards.insert(contentsOf: GameEnvironment.onboardingCards.reversed(), at: shuffledCards.count)
//        }
//        else{
//            shuffledCards.insert(GameEnvironment.onboardingCards[0], at: shuffledCards.count)
//        }

//
//        for i in 0 ..<  shuffledCards.count {
//            shuffledCards[i].id = i
//        }
        
        
        self.cards.shuffle() // Colocando caso tenha algum local do código que pegue diretamente de CardData().cards
        self.maxID = cards.count - 1
        
        self.objectWillChange.send()
    }
    
    static let blockEndings: [String] = [
        "Assédio não é brincadeira. Aqui é só um jogo, mas para assédio não existe espaço em nenhum lugar. Você foi cancelado!",
        "Não é mais tempo de ficar reforçando qualquer tipo de estereótipo, dentro ou fora de jogo, viu?! Você foi cancelado!",
        "Já tá na hora de perder esses teus preconceitos, não é? Afinal, preconceito bom é aquele que não existe, nem em jogo. Você foi cancelado!"
        
    ]
    
}
