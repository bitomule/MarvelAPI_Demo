import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  private lazy var appCoordinator: AppCoordinator = {
    return AppCoordinator(window: self.window!)
  }()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    
    appCoordinator.start()
    
    return true
  }
  
}
