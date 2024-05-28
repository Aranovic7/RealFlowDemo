//
//  AudioSettings.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-20.
//

import SwiftUI

struct AudioSettings: View {
    
    @State var isSoundEnabled: Bool = false
    @State var isVibrationsEnabled: Bool = false
    @State var isNotificationsEnabled: Bool = false
    
    var body: some View {
        
        Form{
            
            Section(header: Text("Audio \nBy default you will hear a sound whenever you receive a message")) {
                Toggle("Sound", isOn: $isSoundEnabled)
            }
            
            Section(header: Text("Vibrations \nBy default you will feel vibrations when receiving a notification")) {
                Toggle("Vibrations", isOn: $isVibrationsEnabled)
            }
            
            Section(header: Text("Notifications \n Determine wether you want to receive notifications or not")) {
                Toggle("Notifications", isOn: $isNotificationsEnabled )
                
            }
            
        }.navigationBarTitle("Audio - and vibrations")
    }
}

#Preview {
    AudioSettings()
}

