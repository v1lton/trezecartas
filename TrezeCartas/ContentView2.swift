//
//  ContentView2.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//
import SwiftUI

struct ContentView2: View {
    
    @State var health = 10
    @State var money = 10
    @State var drugs = 0
    @State var leftOption: String = ""
    @State var rightOption: String = ""
    @State var leftBool: Bool = false
    @State var rightBool: Bool = false
    
    /// teste de cards
    @State var cards: [Card] = [
        Card(id: 0, cardImage: UIImage(named: "teste")!, cardName: "O Boy Magia", cardText: "Você está pulando atrás de um bloco com seus amigos e o seu crush aparece no meio da multidão. Calma, ele está te chamando?", leftOption: "Encontrar o boy", rightOption: "Dar um tchauzinho", leftAnswer: "Você foi até o boy e ele já foi te beijando. PQP, o boy beija bem demais! Mas calma, onde foram parar o bloco e seus amigo? Acho que você se perdeu deles.", rightAnswer: "Você vê o boy acenando de volta, ele parece um pouco desapontado. Mas calma, não se desespere, logo ali o latão é 3 é 10! Bom que já afoga a mágoa com os amigos e segue o bloco.", leftStatus: [-2, 0, 0], rightStatus: [1, -1, 1]),
        Card(id: 1, cardImage: UIImage(named: "teste")!, cardName: "O Boy Magia", cardText: "Você está pulando atrás de um bloco com seus amigos e o seu crush aparece no meio da multidão. Calma, ele está te chamando?", leftOption: "meu cu ", rightOption: "Dar um tchauzinho", leftAnswer: "Você foi até o boy e ele já foi te beijando. PQP, o boy beija bem demais! Mas calma, onde foram parar o bloco e seus amigo? Acho que você se perdeu deles.", rightAnswer: "Você vê o boy acenando de volta, ele parece um pouco desapontado. Mas calma, não se desespere, logo ali o latão é 3 é 10! Bom que já afoga a mágoa com os amigos e segue o bloco.", leftStatus: [-2, 0, 0], rightStatus: [1, -1, 1]),
        Card(id: 2, cardImage: UIImage(named: "teste")!, cardName: "O Boy Magia", cardText: "Você está pulando atrás de um bloco com seus amigos e o seu crush aparece no meio da multidão. Calma, ele está te chamando?", leftOption: "Encontrar o boy", rightOption: "Dar um tchauzinho", leftAnswer: "Você foi até o boy e ele já foi te beijando. PQP, o boy beija bem demais! Mas calma, onde foram parar o bloco e seus amigo? Acho que você se perdeu deles.", rightAnswer: "Você vê o boy acenando de volta, ele parece um pouco desapontado. Mas calma, não se desespere, logo ali o latão é 3 é 10! Bom que já afoga a mágoa com os amigos e segue o bloco.", leftStatus: [-2, 0, 0], rightStatus: [1, -1, 1])
    ]
    
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(cards.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(cards.count - 1 - id) * 10
    }
        
    // Compute what the max ID in the given users array is.
    private var maxID: Int {
        return self.cards.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    // aqui entra os status
                    VStack {
                        Text("health: \(health)")
                        Text("money: \(money)")
                        Text("drugs: \(drugs)")
                    }.frame(height: 155)
                    
                    // CardView
                    ZStack {
                    
                        ForEach(self.cards, id: \.self) { cardss in
                        
                            /// Using the pattern-match operator ~=, we can determine if our
                            /// user.id falls within the range of 6...9
                            if (self.maxID)...self.maxID ~= cardss.id {
                                CardView(card: cardss, onRemove: { removedCard in
                                    // Remove that user from our array
                                    self.cards.removeAll { $0.id == removedCard.id }
                                }, leftOption: $leftOption, rightOption: $rightOption, leftBool: $leftBool, rightBool: $rightBool, health: $health, money: $money, drugs: $drugs)
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: cardss.id), height: 450)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: cardss.id))
                            }
                        }
                        
                    }
                    
                    //Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            self.leftBool = !self.leftBool
                        }, label: {
                            HStack {
                                Spacer()
                                Text(leftOption)
                                    //.font(.custom("Raleway-Bold", size: 18))
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding()
                                Spacer()
                            }
                            
                        }).frame(height: 80)
                        .clipped()
                        .background(Color.gray)
                        .cornerRadius(10)
                        
                        Spacer()
                            //.frame(width:)
                        
                        Button(action: {
                            self.rightBool = !self.rightBool
                        }, label: {
                            HStack {
                                Spacer()
                                Text(rightOption)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding()
                                Spacer()
                            }
                            
                        }).frame(height: 80)
                        .clipped()
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    
                    //Spacer()
                                            
                    HStack {
                        HStack {
                            Spacer()
                            Image("lata")
                                .offset(x: -10)
                            Text("Agite para o \nsucesso")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                .padding(0.0)
                            Spacer()
                            
                        }
                    }
                }
            }
        }.padding()
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
