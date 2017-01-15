//
//  AppDelegate.swift
//  Flicks
//
//  Created by William Huang on 12/28/16.
//  Copyright © 2016 William Huang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingViewController.pageTitle = "Now Playing"
        nowPlayingNavigationController.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(named: "now_playing"), tag: 0)
        
        let upcomingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let upcomingViewController = upcomingNavigationController.topViewController as! MoviesViewController
        upcomingViewController.endpoint = "upcoming"
        upcomingViewController.pageTitle = "Upcoming"
        upcomingNavigationController.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(named: "upcoming"), tag: 0)
        
        let topRatedNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedViewController.pageTitle = "Top Rated"
        topRatedNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.topRated, tag: 0)
        
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = UIColor(red: 70/255, green: 87/255, blue: 117/255, alpha: 1)
        tabBarController.tabBar.tintColor = UIColor(red: 70/255, green: 87/255, blue: 117/255, alpha: 1)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [nowPlayingNavigationController, upcomingNavigationController, topRatedNavigationController]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.flicks.nowPlaying" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let moviesVC = sb.instantiateViewController(withIdentifier: "MoviesVC")
            let root = UIApplication.shared.keyWindow?.rootViewController
            root?.present(moviesVC, animated: true, completion: { 
                completionHandler(true)
            })
        }
    }


}

