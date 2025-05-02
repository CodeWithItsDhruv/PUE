import UIKit

@objc protocol OrientationAware {
    func orientationDidChange()
}

class OrientationHandler {
    
    static func setupOrientationNotifications(for viewController: OrientationAware) {
        NotificationCenter.default.addObserver(viewController, selector: #selector(OrientationAware.orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    static func removeOrientationNotifications(for viewController: OrientationAware) {
        NotificationCenter.default.removeObserver(viewController, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

