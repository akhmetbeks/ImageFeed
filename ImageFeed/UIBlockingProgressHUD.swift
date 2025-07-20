//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 21.06.2025.
//
import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
    private var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
