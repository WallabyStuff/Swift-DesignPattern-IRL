//
//  SettingsView.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

struct SettingsView: View {
  
  var body: some View {
    NavigationView(content: {
      compositeSettingView()
    })
  }
  
  private func compositeSettingView() -> some View {
    var root = RootSetting(title: "Setting")
    
    // 🗼. 네트워크 설정 그룹
    var networkSetting = NetworkSetting(title: "Network Setting")
    
    // 🗼 > ✈️. 비행기보드 설정
    let airplaneMode = AirplaneModeSetting(title: "AirplainMode", isOn: .constant(true))
    
    // 🗼 > 🛜. Wifi 설정
    var wifiSetting = WifiSetting(title: "Wi-Fi")
    // 🗼 > 🛜 > 💭. 네트워크 접속시 물어보기
    wifiSetting.addComponent(AskToJoinNetworks(title: "Ask to Join Networks"))
    // 🗼 > 🛜 > 🔥. 핫스팟
    wifiSetting.addComponent(Hotspot(title: "Hotspot"))
    
    
    // 🗼 네트워크 설정 조합
    networkSetting.addComponent(airplaneMode)
    networkSetting.addComponent(wifiSetting)
    
    
    
    // 👂. 오디오 설정 그룹
    var audioSetting = AudioSetting(title: "Audio")
    
    // 👂 > 🔔. 알림 설정
    var notifications = NotificationSetting(title: "Notifications")
    
    // 👂 > 🔔 > 📝. Scheduled summary
    let scheduledSummary = ScheduledSummary(title: "Scheduled Summary", isOn: .constant(false))
    notifications.addComponent(scheduledSummary)
    
    // 👂 > 🔔 > 🔍. Show Preview
    let showPreview = ShowPreview(title: "Show Preview")
    notifications.addComponent(showPreview)

    
    // 👂 > 🔊. 사운드 설정
    var sounds = SoundSetting(title: "Sounds")
    
    // 👂 > 🔊 > 🤫 Silent Mode
    let silentMode = SilentMode(title: "Silent Mode", isOn: .constant(true))
    sounds.addComponent(silentMode)
    
    // 👂. 오디오 설정 조합
    audioSetting.addComponent(notifications)
    audioSetting.addComponent(sounds)
    
    
    
    // 루트 설정 조합
    root.addComponent(networkSetting)
    root.addComponent(audioSetting)
    return root.render()
  }
}

#Preview {
  SettingsView()
}
