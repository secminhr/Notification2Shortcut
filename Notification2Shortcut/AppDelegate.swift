//
//  AppDelegate.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/6/13.
//


import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
   func applicationDidFinishLaunching(_ notification: N2SNotification) {
       UNUserNotificationCenter.current().delegate = self
   }

   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.banner, .banner, .sound])
   }
}
