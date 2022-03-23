//
//  FaceIDViewModel.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation
import LocalAuthentication

class FaceIDViewModel: ObservableObject {
    /// @Published：允許創建出能夠被自動觀察的對象屬性，如此參數發生改變，會自動修改該屬性綁定的UI 元件。
    @Published var buttonText: String = "Using Face ID"
    
    func doCheckFaceIDFunction() {
        let context = LAContext()
        
        // 當 FaceID 或 指紋辨識 第一次驗證失敗, 彈跳系統制式alert, alert上的取消button文字描述
        context.localizedCancelTitle = "Cancel"
        
        var error: NSError?
        // 判斷是否可以用 FaceID, 指紋辨識, 裝置密碼登入 -> Bool
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // 使用 FaceID, 指紋辨識, 裝置密碼登入驗證
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "setting to unlock your app") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.buttonText = "Binding Success"
                    }
                } else {
                    DispatchQueue.main.async {
                        // 驗證失敗
                        guard let nsError = error as NSError? else { return }
                        let errorCode = Int32(nsError.code)
                        switch errorCode {
                        case kLAErrorAuthenticationFailed: print("驗證資訊出錯")
                        case kLAErrorUserCancel: print("使用者取消驗證")
                        case kLAErrorUserFallback: print("使用者選擇其他驗證方式")
                        case kLAErrorSystemCancel: print("被系統取消")
                        case kLAErrorPasscodeNotSet: print("iPhone沒設定密碼")
                        case kLAErrorTouchIDNotAvailable: print("使用者裝置不支援Touch ID")
                        case kLAErrorTouchIDNotEnrolled: print("使用者沒有設定Touch ID")
                        case kLAErrorTouchIDLockout: print("功能被鎖定(五次)，下一次需要輸入手機密碼")
                        case kLAErrorAppCancel: print("在驗證中被其他app終止")
                        default: print("驗證失敗")
                        }
                    }
                }
            }
        } else {
            // error handle
        }
    }

}
