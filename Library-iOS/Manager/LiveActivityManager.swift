//
//  LiveActivityManager.swift
//  Carrefour-Universal-App
//
//  Created by Jim Huang on 2025/5/15.
//  Copyright © 2025 Jim Huang. All rights reserved.
//
import Foundation
import ActivityKit

@available(iOS 16.1, *)
@objc class LiveActivityManager: NSObject {
    @objc static let sharedInstance = LiveActivityManager()
    
    deinit {
        self.cancelLiveActivity()
    }
    
    @objc func createLiveActivity(accumulatedTime: Int) {
        if (!ActivityAuthorizationInfo().areActivitiesEnabled) {
            return;
        }
        
        let nowDate = Date()
        let components = DateComponents(second: accumulatedTime)
        let futureDate = Calendar.current.date(byAdding: components, to: nowDate)!
        let dateRange = nowDate...futureDate

        let initialContentState = WidgetExtensionAttributes.ContentState(emoji: "😀", deliveryTimer: dateRange)
        let activityAttributes = WidgetExtensionAttributes(name: "Test Activity")

        do {
            _ = try Activity.request(
                attributes: activityAttributes,
                contentState: initialContentState
            )
        } catch {

        }
    }
    
    @objc func updateLiveActivity(accumulatedTime: Int) {
        let nowDate = Date()
        let components = DateComponents(second: accumulatedTime)
        let futureDate = Calendar.current.date(byAdding: components, to: nowDate)!
        let dateRange = nowDate...futureDate

        let updatedDeliveryStatus = WidgetExtensionAttributes.ContentState(emoji: "😀", deliveryTimer: dateRange)
//        let alertConfiguration = AlertConfiguration(title: "Delivery Update", body: "Your pizza order will arrive in 25 minutes.", sound: .default)

        Task {
            for activity in Activity<WidgetExtensionAttributes>.activities {
                await activity.update(using: updatedDeliveryStatus)
            }
        }
    }
    
    @objc func cancelLiveActivity() {
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            for activity in Activity<WidgetExtensionAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
    }
}
