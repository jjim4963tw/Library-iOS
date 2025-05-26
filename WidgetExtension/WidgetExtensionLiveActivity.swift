//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by Jim Huang on 2025/5/15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            // 製作鎖定畫面應該顯示的畫面，這也同時支援沒有動態島的iOS裝置。
            HStack(alignment: .center) {
                Text("支付條碼到期時間：")
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                    .foregroundStyle(.white)
            }
            .padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // 製作動態島顯示畫面
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.emoji)")
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Spacer().frame(height: 30)
                    Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                        .foregroundStyle(.white)
                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
//                        .foregroundStyle(.white)
////                     more content
//                }
            } compactLeading: {
                Text("\(context.state.emoji)")
                    .foregroundStyle(.white)
            } compactTrailing: {
                Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                    .foregroundStyle(.white)
            } minimal: {
                Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                    .foregroundStyle(.white)
            }
//            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//#Preview("Notification", as: .content, using: WidgetExtensionAttributes.preview) {
//   WidgetExtensionLiveActivity()
//} contentStates: {
//    WidgetExtensionAttributes.ContentState.smiley
//    WidgetExtensionAttributes.ContentState.starEyes
//}
