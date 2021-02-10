//
//  CardView.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//

import SwiftUI

struct CardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LeftRight = .none
    @State private var cardStatus: Cards = .front
    @State var degrees: Double = 0.0
    
    @Binding var leftOption: String
    @Binding var rightOption: String
    @Binding var health: Int
    @Binding var money: Int
    @Binding var drugs: Int
    
    private var card: Card
    private var onRemove: (_ user: Card) -> Void
    
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 30% the width of the screen in either direction
    
    private enum LeftRight: Int {
        case right, left, none
    }
    
    private enum Cards: Int {
        case back, front, none
    }
    
    init(card: Card, onRemove: @escaping (_ user: Card) -> Void, leftOption: Binding<String>, rightOption: Binding<String>, health: Binding<Int>, money: Binding<Int>, drugs: Binding<Int>) {
        self.card = card
        self.onRemove = onRemove
        self._leftOption = leftOption
        self._rightOption = rightOption
        self._health = health
        self._money = money
        self._drugs = drugs
    }
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.0)]), startPoint: .bottom, endPoint: .top)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if cardStatus == .front {
                    /// card pergunta
                    ZStack(alignment: self.swipeStatus == .right ? .bottomLeading : .bottomTrailing) {
                        /// chamada do codigo para a arte da carta
                        CardArt(complete: false)
                        
                        VStack(alignment: .center, spacing: 0) {
                            Image(uiImage: card.cardImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 176)
                                .clipped()
                                .cornerRadius(10)
                                //.cornerRadius(10, corners: [.topLeft, .topRight])
                                .padding([.top, .leading, .trailing])
                                .padding([.top, .leading, .trailing], 10)
                            Spacer()
                            VStack(alignment: .center, spacing: 0){
                                Text("\(card.cardName)")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text("\(card.cardText)")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 70.0)
                                    .padding(.bottom)
                            }
                            Spacer()
                        }
                        /// swipe
                        if self.swipeStatus == .left {
                            Rectangle()
                                .fill(gradient)
                            Text("\(card.leftOption)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.leading, 50)
                                .padding(.bottom, 100)
                                .rotationEffect(Angle.degrees(-25))
                        } else if self.swipeStatus == .right {
                            Rectangle()
                                .fill(gradient)
                            Text("\(card.rightOption)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.trailing, 50)
                                .padding(.bottom, 100)
                                .rotationEffect(Angle.degrees(25))
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                } else if cardStatus == .back {
                    /// card resposta
                    ZStack {
                        CardArt(complete: true)
                        
                        VStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .center, spacing: 0){
                                Text("\(card.cardName)")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text(swipeStatus == .left ? "\(card.leftAnswer)" : "\(card.rightAnswer)")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 70.0)
                                    .padding(.bottom)
                            }.padding(.top, 80)
                            Spacer()
                            HStack {
                                // resposta direita
                                if swipeStatus == .right {
                                    if card.rightStatus[0] != 0 {
                                        HStack{
                                            Image("coracao")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 3)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.rightStatus[0] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                        }.padding(.horizontal, 10)
                                    }
                                    if card.rightStatus[1] != 0 {
                                        HStack{
                                            Image("dinheiro")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 0)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.rightStatus[1] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                                .padding(.leading, -5)
                                        }.padding(.horizontal, 10)
                                    }
                                    if card.rightStatus[2] != 0 {
                                        HStack{
                                            Image("noia")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 1)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.rightStatus[2] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                        }.padding(.horizontal, 10)
                                    }
                                } else {
                                    // resposta esquerda
                                    if card.leftStatus[0] != 0 {
                                        HStack{
                                            Image("coracao")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 3)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.leftStatus[0] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                            
                                        }.padding(.horizontal, 10)
                                    }
                                    if card.leftStatus[1] != 0 {
                                        HStack{
                                            Image("dinheiro")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 0)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.leftStatus[1] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                            
                                        }.padding(.horizontal, 10)
                                    }
                                    if card.leftStatus[2] != 0 {
                                        HStack{
                                            Image("noia")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                            Spacer()
                                                .frame(width: 1)
                                            Image("seta")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 10)
                                                .rotation3DEffect(.degrees(card.leftStatus[2] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
                                            
                                        }.padding(.horizontal, 10)
                                    }
                                    
                                }
                                
                            }.padding(.bottom, 80)
                            
                        }
                    }.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    
                } else {
                    /// card inicial
                    ZStack {
                        CardArt(complete: true)
                    }
                }
            }
            .onAppear(perform: {
                self.leftOption = card.leftOption
                self.rightOption = card.rightOption
            })
            .background(Color.roxoColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: cardStatus == .front ? self.translation.width : -self.translation.width, y: 0)
            .rotationEffect(.degrees(Double((cardStatus == .front ? self.translation.width : -self.translation.width) / geometry.size.width) * 25), anchor: .bottom)
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            //            .onAppear(perform: {
            //                self.op1 = "\(user.leftOption)"
            //            })
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if cardStatus == .front {
                            self.translation = value.translation
                            if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                                self.swipeStatus = .right
                            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                                self.swipeStatus = .left
                            } else {
                                self.swipeStatus = .none
                            }
                        } else if cardStatus == .back {
                            self.translation = value.translation
                        } else {
                            //nao faz nada, nao se desloca
                        }
                        
                    }.onEnded { value in
                        if cardStatus == .back {
                            if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                self.onRemove(self.card)
                            } else {
                                self.translation = .zero
                            }
                        } else if cardStatus == .front {
                            if swipeStatus == .right {
                                self.health += card.rightStatus[0]
                                self.money += card.rightStatus[1]
                                self.drugs += card.rightStatus[2]
                                cardStatus = .back
                                withAnimation {
                                    self.degrees -= 180
                                }
                            } else if swipeStatus == .left {
                                self.health += card.leftStatus[0]
                                self.money += card.leftStatus[1]
                                self.drugs += card.leftStatus[2]
                                cardStatus = .back
                                withAnimation {
                                    self.degrees += 180
                                }
                            } else {
                                self.translation = .zero
                            }
                            self.translation = .zero
                            
                        }
                        
                    }
            )
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: Card(id: 2, cardImage: UIImage(named: "teste")!, cardName: "O Boy Magia", cardText: "Você está pulando atrás de um bloco com seus amigos e o seu crush aparece no meio da multidão. Calma, ele está te chamando?", leftOption: "Encontrar o boy", rightOption: "Dar um tchauzinho", leftAnswer: "Você foi até o boy e ele já foi te beijando. PQP, o boy beija bem demais! Mas calma, onde foram parar o bloco e seus amigo? Acho que você se perdeu deles.", rightAnswer: "Você vê o boy acenando de volta, ele parece um pouco desapontado. Mas calma, não se desespere, logo ali o latão é 3 é 10! Bom que já afoga a mágoa com os amigos e segue o bloco.", leftStatus: [-2, 0, 0], rightStatus: [10, -1, 1]),
//                 onRemove: { _ in
//                    // do nothing
//                 })
//            .frame(height: 450)
//            .padding()
//    }
//}

/// flip

/// codido da arte
struct CardArt: View {
    var complete: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.amareloColor, lineWidth: 4.0)
                )
            VStack {
                if complete {
                    HStack {
                        Circle()
                            .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.azulColor)
                            .padding(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.amareloColor, lineWidth: 4.0)
                            )
                        Spacer()
                        Circle()
                            .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.azulColor)
                            .padding(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.amareloColor, lineWidth: 4.0)
                            )
                    }
                }
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.azulColor)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.amareloColor, lineWidth: 4.0)
                        )
                    Spacer()
                    Circle()
                        .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.azulColor)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.amareloColor, lineWidth: 4.0)
                        )
                }
            }
        }.padding()
    }
}

/// codigo para selecao de qual borda arrendondar
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
