//
//  LoginView.swift
//  iSolarGrow
//
//  Created by Bushra on 9/4/25.
//

import SwiftUI
import AVKit

struct LoginView: View {
    var body: some View {
        
        if let url = Bundle.main.url(forResource: "LogoVideo", withExtension: "mp4") {
                    VideoPlayer(player: AVPlayer(url: url))
                    .onAppear {
                                   // Force play
                                   let player = AVPlayer(url: url)
                                   player.play()
                               }
                } else {
                    
                    Text("Video not found")
                    
                }
        
        
        
        
        
    }//view
}//struct

#Preview {
    LoginView()
}
