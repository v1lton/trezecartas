//
//  CardData.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI


class GameEnvironment: ObservableObject {
    
    var allCards: [JSONCard] = []
    
    @Published var cards: [JSONCard] = []//(0...15).map{_ in JSONCard.placebo()}
    @Published var maxID = 14
    
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
            allCards = try JSONDecoder().decode([JSONCard].self, from: jsonData)
            
            allCards.shuffle()
            
            
            for i in 0 ..<  allCards.count {
                allCards[i].id = i
            }
//            repeat{
//                allCards.shuffle()
//            }while allCards[allCards.count-1].dependsFrom != nil
            //var c: [JSONCard] = (0...15).map{_ in JSONCard.placebo()}
            
            cards = (0...14).map{allCards[$0]}
                //.append(allCards.shuffled().first(where: {$0.dependsFrom == nil})!)
            
            maxID = 14
                        
            allCards.removeAll(where: {$0.uid == cards[maxID].uid})
            
        } catch{
            print("its a thursday")
            print(error)
        }
        
        //shuffleCards()
        self.objectWillChange.send()
    }

    
    func changeEnvironment(result: Attributtes){
        
        
        self.attributes.healthStats! += result.healthStats!
        self.attributes.moneyStats! += result.moneyStats!
        if result.insanityStats == 0 {
            self.attributes.insanityStats! -= 1
        } else {
            self.attributes.insanityStats! += result.insanityStats!
        }
        
        self.attributes.healthStats! = self.attributes.healthStats!.clamped(to: 0...10)
        self.attributes.moneyStats! = self.attributes.moneyStats!.clamped(to: 0...10)
        self.attributes.insanityStats! = self.attributes.insanityStats!.clamped(to: 0...10)
        
        self.attributes.hasKissed = result.hasKissed
        self.attributes.brokenHeart = result.brokenHeart
        self.attributes.isAmongFriends = result.isAmongFriends
        self.attributes.isDirty = result.isDirty
        self.attributes.isDrunk = result.isDrunk
        self.attributes.isTired = result.isTired
        
        self.attributes.dependsFrom = result.dependsFrom
        
        if let endGame = result.endGame{
            self.attributes.endGame = endGame
        }
        //changeCardPriority()
        
    }
    
    
    func changeCardPriority(){
        //print("My environment")
        //print(self.attributes)
        if self.attributes.dependsFrom != nil{
            if let card = self.allCards.first(where: {
                $0.uid == self.attributes.dependsFrom
            }){
                print(self.attributes)
                print("Índice Selecionado (FAST)", card.uid, ", Carta: ", card.name)
                self.maxID -= 1
                cards[maxID].change(new: card)
//                for index in 0..<cards.count{
//                    cards[index].id = index
//                }
                self.attributes.dependsFrom = nil
                self.objectWillChange.send()
                allCards.removeAll(where: {cardToRemove in
                    cardToRemove.uid == card.uid
                })
            }
            else{
                self.maxID -= 1
                self.attributes.dependsFrom = nil
            }
            return
        }
        print("all cards count: ", allCards.count)
        var cardPriority: [(JSONCard, Double)] = allCards.filter{$0.dependsFrom == nil}.map{ card in
            return(card, 1)
        }
        
//        if attributes.endGame != nil{
//            cardPriority.removeAll(where: {$0.0.endGame != nil})
//        }
        
        let cardsCount = cardPriority.count
        print("Count of priorities", cardsCount)
        //print("Environment Properties")
        let enviromentProperties = self.attributes.mirror()
        //for propierty in enviromentProperties{
        //    print("\"\(propierty.key)\": \(propierty.value)")
        //}
        for index in 0..<cardPriority.count{
            let card = cardPriority[index]
            let cardProperties = card.0.mirror()
            
            for property in enviromentProperties{
                if cardProperties[property.key] == property.value{
                    cardPriority[index].1 += (Double(cardsCount) * 0.5)
                }
            }
        }
        
        if let selectedIndex = randomNumber(probabilities: cardPriority.map{$0.1}){
            print("Índice Selecionado ", cardPriority[selectedIndex].0.uid, ", Carta: ", cardPriority[selectedIndex].0.name)
            self.maxID -= 1
            cards[maxID].change(new: cardPriority[selectedIndex].0)
//            for index in 0..<cards.count{
//                cards[index].id = index
//            }
            allCards.removeAll(where: {cardToRemove in
                cardToRemove.uid == cardPriority[selectedIndex].0.uid
            })
            
            self.objectWillChange.send()
        }
        //cards[cards.count-2] = cardPriority[selectedIndex].0.with(id: cards.count-2)
        
            
    }
    
    func randomNumber(probabilities: [Double]) -> Int? {
        if probabilities.count == 0{ return nil}
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
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
