//
//  SceneDelegate.swift
//  Marusya_Habits
//
//  Created by Мария Александрова on 11.01.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var launchScreenViewController: LaunchScreenViewController?
    
    private func habitsVC() -> UINavigationController {
        let nvc = UINavigationController(rootViewController: HabitsViewController())
        nvc.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(named: "habits_tab_icon"), tag: 0)
        return nvc
    }
    
    private func infoVC() -> UINavigationController {
        let nvc = UINavigationController(rootViewController: InfoViewController())
        nvc.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        return nvc
    }
    
    private func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [habitsVC(), infoVC()]
        tabBar.selectedIndex = 0
        tabBar.tabBar.backgroundColor = .systemBackground
        tabBar.tabBar.tintColor = .purpleHabits
        tabBar.tabBar.unselectedItemTintColor = .systemGray
        return tabBar
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        // Создаем окно
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene

        showLaunchScreen()
    }
    
    private func showLaunchScreen() {
            launchScreenViewController = LaunchScreenViewController()
            window?.rootViewController = launchScreenViewController
            window?.makeKeyAndVisible()
            
            // Имитируем загрузку данных (3 секунды)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showMainApp()
            }
        }
    
    // Перейти к основному приложению
    private func showMainApp() {
        
            let habitsViewController = HabitsViewController()
            let navigationController = UINavigationController(rootViewController: habitsViewController)
            // Анимация перехода
            UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = navigationController

            }, completion: { _ in
                
                self.launchScreenViewController = nil // Освобождаем память
            })
        
        
        self.window?.rootViewController = createTabBar()
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

