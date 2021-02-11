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
    
    @State var op1 = "socorro"
    
    @State var teste: Int = 12
    
    @State var cards = CardData().cards

    
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
        VStack (alignment: .center){
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    // status
                    VStack {
                        ProgressBar(health: $health, money: $money, drugs: $drugs).frame(height: 50)
                            .clipped()
                    }.padding()
                    
                    ZStack {
                        ForEach(self.cards, id: \.self) { cardss in
                            /// Using the pattern-match operator ~=, we can determine if our
                            /// user.id falls within the range of 6...9
                            if (self.maxID - 3)...self.maxID ~= cardss.id {
                                CardView(card: cardss, onRemove: { removedCard in
                                    // Remove that user from our array
                                    teste -= 1
                                    self.cards.removeAll { $0.id == removedCard.id }
                                }, health: $health, money: $money, drugs: $drugs, teste: $teste)
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: cardss.id), height: 500)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: cardss.id))
  
                            }
                        }
                    }
                    
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            //self.teste = true
                        }, label: {
                            HStack {
                                Spacer()
                                Text(op1)
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
                            .frame(width: 7)
                        
                        Button(action: {
                            // acao do botao
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Segunda escolha")
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
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }
        .preferredColorScheme(.light)
        .blur(radius: CGFloat(drugs)/2)
        .padding()
        .background(Color.brancoColor)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            self.drugs += 1
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
