//
//  ProgressBar.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI
import UIKit

struct ProgressBarView: View {
    
    @ObservedObject var environment: GameEnvironment
    
    var showAttributes: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                // coracao
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: geometry.size.height*1.15, height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(showAttributes ? 0.4 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Rectangle().frame(width: geometry.size.height*1.15, height: min(CGFloat(Float(environment.attributes.healthStats!))*(0.1*geometry.size.height), geometry.size.height))
                        .foregroundColor(Color.rosaColor)
                        .animation(.linear)
                        .opacity(showAttributes ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Image("coracao1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: geometry.size.height)
                    
                }
                
                // dinheiro
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: geometry.size.height*1.15 , height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(showAttributes ? 0.4 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Rectangle().frame(width: geometry.size.height*1.15, height: min(CGFloat(Float(environment.attributes.moneyStats!))*(0.1*geometry.size.height), geometry.size.height))
                        .foregroundColor(Color.amareloColor)
                        .animation(.linear)
                        .opacity(showAttributes ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Image("dinheiro1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: geometry.size.height)
                    
                }
                
                // insanidade
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: geometry.size.height*1.15, height: geometry.size.height)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(showAttributes ? 0.4 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Rectangle().frame(width: geometry.size.height*1.15, height: min(CGFloat(Float(environment.attributes.insanityStats!))*(0.1*geometry.size.height), geometry.size.height))
                        .foregroundColor(Color.azulColor)
                        .animation(.linear)
                        .opacity(showAttributes ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Image("noia1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: geometry.size.height)
                }
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(red: 0xf5/0xff, green: 0xf5/0xff, blue: 0xf5/0xff))
            .clipped()
        }
    }
}


struct ProgressBarView_PreviewProvider: PreviewProvider{
    static var previews: some View{
        ProgressBarView(environment: GameEnvironment(), showAttributes: true).frame(height: 50)
            .clipped()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        
        ProgressBarView(environment: GameEnvironment(), showAttributes: true).frame(height: 50)
            .clipped()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
