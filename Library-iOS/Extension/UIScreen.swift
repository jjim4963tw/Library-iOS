//
//  UIScreen.swift
//  Library-iOS
//
//  Created by Jim Huang on 2024/12/9.
//

import UIKit

extension UIScreen {
    
    /// 設定螢幕亮度 (漸進式調整)
    /// - Parameters:
    ///   - value: 目標亮度
    ///   - duration: 持續時間
    ///   - ticksPerSecond: 時間間距
    public func setBrightness(to value: CGFloat, duration: TimeInterval = 0.3, ticksPerSecond: Double = 120) {
        let startingBrightness = UIScreen.main.brightness
        let delta = value - startingBrightness
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond
        
        let time = DispatchTime.now()
        
        for i in 1...totalTicks {
            DispatchQueue.main.asyncAfter(deadline: time + delayBetweenTicks * Double(i)) {
                UIScreen.main.brightness = max(min(startingBrightness + (changePerTick * CGFloat(i)),1),0)
            }
        }
    }
}
