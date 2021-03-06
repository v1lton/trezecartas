//
//  ProgressBar.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI
import UIKit

struct ProgressBar: View {
    @Binding var health: Int
    @Binding var money: Int
    @Binding var drugs: Int
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                // coracao
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: 60, height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(0.4)
                    Rectangle().frame(width: 60, height: min(CGFloat(Float(health))*5, 50))
                        .foregroundColor(Color.rosaColor)
                        .animation(.linear)
                    Image("coracao1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50)
                }
                
                // dinheiro
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: 60 , height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(0.4)
                    Rectangle().frame(width: 60, height: min(CGFloat(Float(money))*5, 50))
                        .foregroundColor(Color.amareloColor)
                        .animation(.linear)
                    Image("dinheiro1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50)
                }
                
                // noia
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: 60, height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(0.4)
                    Rectangle().frame(width: 60, height: min(CGFloat(Float(drugs))*5, 50))
                        .foregroundColor(Color.azulColor)
                        .animation(.linear)
                    Image("noia1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50)
                }
            }.frame(width: geometry.size.width, height: 50)
            .clipped()
        }
    }
}


