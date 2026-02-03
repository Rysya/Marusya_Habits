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

        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        showLaunchScreen()
    }
    
    private func showLaunchScreen() {
            launchScreenViewController = LaunchScreenViewController()
            window?.rootViewController = launchScreenViewController
            window?.makeKeyAndVisible()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showMainApp()
            }
        }
    
    private func showMainApp() {
        
            let habitsViewController = HabitsViewController()
            let navigationController = UINavigationController(rootViewController: habitsViewController)
        
            UIView.transition(with: window!,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.window?.rootViewController = navigationController
            }, completion: { _ in
                self.launchScreenViewController = nil
            })
        
        self.window?.rootViewController = createTabBar()
        self.window?.makeKeyAndVisible()
    }
}
