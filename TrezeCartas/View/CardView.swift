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
    @State private var cardStatus: Cards = .none
    @State var degrees: Double = 0.0
    
    @ObservedObject var environment: GameEnvironment

    @State var isPresented = false
    @Binding var leftOption: String
    @Binding var rightOption: String
    @Binding var isCardShowingBack: Bool
    @Binding var leftButton: Bool
    @Binding var rightButton: Bool
    @Binding var pass: Bool
    @Binding var end : Bool
    
    private var card: Card
    private var onRemove: (_ user: Card) -> Void
        
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 30% the width of the screen in either direction
    
    enum LeftRight: Int {
        case right, left, none
    }
    
    private enum Cards: Int {
        case back, front, none
    }
    

    init(card: Card, onRemove: @escaping (_ user: Card) -> Void, environment: GameEnvironment, leftOption: Binding<String>, rightOption: Binding<String>, end: Binding<Bool>, isCardShowingBack: Binding<Bool>, leftButton: Binding<Bool>, rightButton: Binding<Bool>, pass: Binding<Bool>) {

        self.card = card
        self.onRemove = onRemove
        
        self.environment = environment
        
        self._leftOption = leftOption
        self._rightOption = rightOption
        self._end = end
        self._isCardShowingBack = isCardShowingBack
        self._leftButton = leftButton
        self._rightButton = rightButton
        self._pass = pass
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
    
    func choice(direction: LeftRight){
        
        var sideChoice: [Int]
        
        if(direction == .left){
            sideChoice = card.leftStatus
        } else {
            sideChoice = card.rightStatus
        }
        
        self.environment.attributes.healthStats! += sideChoice[0]
        self.environment.attributes.moneyStats! += sideChoice[1]
        if sideChoice[2] == 0 {
            self.environment.attributes.insanityStats! -= 1
        } else {
            self.environment.attributes.insanityStats! += sideChoice[2]
        }
        
        self.environment.attributes.healthStats! = self.environment.attributes.healthStats!.clamped(to: 0...10)
        self.environment.attributes.moneyStats! = self.environment.attributes.moneyStats!.clamped(to: 0...10)
        self.environment.attributes.insanityStats! = self.environment.attributes.insanityStats!.clamped(to: 0...10)
        
        if environment.attributes.healthStats! == 0 || environment.attributes.moneyStats! == 0 || environment.attributes.insanityStats! == 10 {
            self.end.toggle()
        }
        cardStatus = .back
        withAnimation {
            let rotation: Double = (direction == .left ? 180 : -180)
            
            self.degrees += rotation
            self.isCardShowingBack = true
        }
        
        environment.objectWillChange.send()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                if cardStatus == .front {
                    /// card pergunta
                    ZStack(alignment: self.swipeStatus == .right ? .bottomLeading : .bottomTrailing) {
                        /// chamada do codigo para a arte da carta
                        CardArt(complete: false)
                        
                        VStack(alignment: .center) {
                            VStack {
                                Image(uiImage: card.cardImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.797, height: UIScreen.main.bounds.height * 0.223, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(10)
                                    .padding([.top, .leading, .trailing])
                                    .padding([.top, .leading, .trailing], 10)
                                    .clipShape(Rectangle(), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                            }
                            .clipped()
                           
                                
                            Spacer()
                            VStack(alignment: .center, spacing: 0){
                                Text("\(card.cardName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.amareloColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text("\(card.cardText)")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.15)
                                    .padding(.bottom)
                                    .minimumScaleFactor(0.5)
                            }
                            Spacer()
                        }
                        /// swipe
                        if self.swipeStatus == .left {
                            Rectangle()
                                .fill(gradient)
                            Text("\(card.leftOption)")
                                .font(.body)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.leading, 55)
                                .padding(.bottom, geometry.size.height*0.20)
                                .rotationEffect(Angle.degrees(-25))
                        } else if self.swipeStatus == .right {
                            Rectangle()
                                .fill(gradient)
                            Text("\(card.rightOption)")
                                .font(.body)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.trailing, 55)
                                .padding(.bottom, geometry.size.height*0.20)
                                .rotationEffect(Angle.degrees(25))
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    
                } else if cardStatus == .back {
                    /// card resposta
                    ZStack {
                        CardArt(complete: true)
                        
                        VStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .center, spacing: 0){
                                Text("\(card.cardName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.amareloColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text(swipeStatus == .left ? "\(card.leftAnswer)" : "\(card.rightAnswer)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.15)
                                    .padding(.bottom)
                                    .minimumScaleFactor(0.5)
                            }.padding(.top, geometry.size.height*0.16)
                            Spacer()
                            HStack(alignment: .center) {
                                
                                if swipeStatus == .right {
                                    if card.rightStatus[0] != 0 {
                                        CardBackStatus(imageStatus: "coracao", arrowDegrees: (card.rightStatus[0] <= 0 ? 180 : 0), spacerFrameWidth: 3)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("coracao")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 3)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.rightStatus[0] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//                                        }.padding(.horizontal, 10)
                                    }
                                    if card.rightStatus[1] != 0 {
                                        CardBackStatus(imageStatus: "dinheiro", arrowDegrees: (card.rightStatus[1] <= 0 ? 180 : 0), spacerFrameWidth: 0)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("dinheiro")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 0)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.rightStatus[1] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//                                                .padding(.leading, -5)
//                                        }.padding(.horizontal, 10)
                                    }
                                    if card.rightStatus[2] != 0 {
                                        CardBackStatus(imageStatus: "noia", arrowDegrees: (card.rightStatus[2] <= 0 ? 180 : 0), spacerFrameWidth: 1)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("noia")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 1)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.rightStatus[2] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//                                        }.padding(.horizontal, 10)
                                    }
                                } else {
                                    // resposta esquerda
                                    if card.leftStatus[0] != 0 {
                                        CardBackStatus(imageStatus: "coracao", arrowDegrees: (card.leftStatus[0] <= 0 ? 180 : 0), spacerFrameWidth: 3)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("coracao")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 3)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.leftStatus[0] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//
//                                        }.padding(.horizontal, 10)
                                    }
                                    if card.leftStatus[1] != 0 {
                                        CardBackStatus(imageStatus: "dinheiro", arrowDegrees: (card.leftStatus[1] <= 0 ? 180 : 0), spacerFrameWidth: 0)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("dinheiro")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 0)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.leftStatus[1] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//
//                                        }.padding(.horizontal, 10)
                                    }
                                    if card.leftStatus[2] != 0 {
                                        CardBackStatus(imageStatus: "noia", arrowDegrees: (card.leftStatus[2] <= 0 ? 180 : 0), spacerFrameWidth: 1)
                                            .frame(width: geometry.size.width*0.20, height: geometry.size.height*0.08)
//                                        HStack{
//                                            Image("noia")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.08)
//                                            Spacer()
//                                                .frame(width: 1)
//                                            Image("seta")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(height: geometry.size.height*0.02)
//                                                .rotation3DEffect(.degrees(card.leftStatus[2] <= 0 ? 180 : 0), axis: (x: 0, y: 0, z: 1))
//
//                                        }.padding(.horizontal, 10)
                                    }
                                    
                                }
                                
                            }.padding(.bottom, geometry.size.height*0.16)
                            
                        }
                    }.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .onChange(of: pass) { newValue in
                        if end {
                            self.isPresented.toggle()
                        }
                        self.onRemove(self.card)
                    }
                    
                } else {
                    /// card inicial
                    ZStack {
                        Rectangle().fill(Color.black).opacity(0.25)
                        CardArt(complete: true)
                    }.onChange(of: environment.maxID) { newValue in
                        if card.id == environment.maxID {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.isCardShowingBack = false
                            }
                            cardStatus = .front
                            self.leftOption = card.leftOption
                            self.rightOption = card.rightOption
                        }
                        
                    }
                    
                }
            }
            .onChange(of: leftButton) { newValue in
                if card.id == environment.maxID {
                    self.swipeStatus = .left
                    self.choice(direction: .left)
                }
            }
            .onChange(of: rightButton) { newValue in
                if card.id == environment.maxID {
                    self.swipeStatus = .right
                    self.choice(direction: .right)
                }
            }
            .background(end ? Color.pretoColor : Color.roxoColor)
            //.saturation(end ? 0 : 1)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: cardStatus == .front ? self.translation.width : -self.translation.width, y: 0)
            .rotationEffect(.degrees(Double((cardStatus == .front ? self.translation.width : -self.translation.width) / geometry.size.width) * 25), anchor: .bottom)
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                if card.id == environment.maxID {
                    cardStatus = .front
                    self.leftOption = card.leftOption
                    self.rightOption = card.rightOption
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if cardStatus == .front {
                            self.translation = value.translation
                            if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                                //self.isCardShowingBack = true
                                self.swipeStatus = .right
                            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                                //self.isCardShowingBack = true
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
                                if end {
                                    self.isPresented.toggle()
                                }
                                self.onRemove(self.card)
                            } else {
                                self.translation = .zero
                            }
                        } else if cardStatus == .front {
                            if swipeStatus == .right {
                                self.choice(direction: .right)
                            } else if swipeStatus == .left {
                                self.choice(direction: .left)
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

/// CardBackStatus
struct CardBackStatus: View {
    var imageStatus: String
    var arrowDegrees: Double
    var spacerFrameWidth: CGFloat
        
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Image(imageStatus)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geometry.size.height)
                Spacer()
                    .frame(width: spacerFrameWidth) 
                Image("seta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geometry.size.height*0.25)
                    .rotation3DEffect(.degrees(arrowDegrees), axis: (x: 0, y: 0, z: 1))
                    .padding(.leading, self.imageStatus == "dinheiro" ? -5 : 0) // pra ficar mais juntinho quando for dinheiro
            }.padding(.horizontal, 10)
        }
    }
}


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
                        CardCircle()
                        Spacer()
                        CardCircle()
                    }
                }
                Spacer()
                HStack {
                    CardCircle()
                    Spacer()
                    CardCircle()
                }
            }
            
        }.padding()
    }
}

struct CardCircle: View {
    
    var body: some View {
        Circle()
            .frame(width: 12, height: 12, alignment: .center)
            .foregroundColor(Color.azulColor)
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.amareloColor, lineWidth: 4.0)
            )
    }
}
