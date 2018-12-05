//
//  FeatureFlagsUI.swift
//  FeatureFlags
//
//  Created by Ross Butler on 11/27/18.
//

import Foundation

public struct FeatureFlagsUI {
    
    private static let notificationsObserver = FeatureFlagsUIObserver()
    
    // Allows FeatureFlags to refresh state information when app foregrounded
    public static var autoRefresh: Bool {
        get {
            return _isObservingNotifications
        }
        set {
            if newValue {
                if !_isObservingNotifications {
                    let observer = FeatureFlagsUI.notificationsObserver
                    NotificationCenter.default.addObserver(observer,
                        selector: #selector(observer.willEnterForeground),
                        name: UIApplication.willEnterForegroundNotification,
                        object: nil)
                    _isObservingNotifications = true
                }
            } else if _isObservingNotifications {
                let observer = FeatureFlagsUI.notificationsObserver
                NotificationCenter.default.removeObserver(observer)
                _isObservingNotifications = false
            }
        }
    }
    
    private static var _isObservingNotifications: Bool = false
    
    /// Presents FeatureFlagsViewController modally
    public static func presentFeatureFlags(delegate: FeatureFlagsViewControllerDelegate? = nil,
                                           animated: Bool = false, shouldRefresh: Bool = true) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else { return }
        let featureFlagsViewController = FeatureFlagsViewController(style: .grouped)
        featureFlagsViewController.delegate = delegate
        featureFlagsViewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: featureFlagsViewController)
        let navigationSettings = FeatureFlagsViewController
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                closeButtonAlignment: .right,
                                isModal: true,
                                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                                shouldRefresh: shouldRefresh)
        featureFlagsViewController.navigationSettings = navigationSettings
        if navigationSettings.shouldRefresh {
            FeatureFlags.refresh()
        }
        presenter.present(navigationController, animated: animated, completion: nil)
    }
    
    public static func presentFeatureFlags(delegate: FeatureFlagsViewControllerDelegate? = nil,
                                           navigationSettings: ViewControllerNavigationSettings) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else { return }
        let featureFlagsViewController = FeatureFlagsViewController(style: .grouped)
        featureFlagsViewController.delegate = delegate
        featureFlagsViewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: featureFlagsViewController)
        featureFlagsViewController.navigationSettings = navigationSettings
        if navigationSettings.shouldRefresh {
            FeatureFlags.refresh()
        }
        presenter.present(navigationController, animated: navigationSettings.animated, completion: nil)
    }
    
    /// Allows FeatureFlagsViewController to be pushed onto a navigation stack
    public static func pushFeatureFlags(delegate: FeatureFlagsViewControllerDelegate? = nil,
                                        navigationController: UINavigationController,
                                        animated: Bool = false,
                                        shouldRefresh: Bool = true) {
        let featureFlagsViewController = FeatureFlagsViewController(style: .grouped)
        let navigationSettings = FeatureFlagsViewController
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                                shouldRefresh: shouldRefresh)
        featureFlagsViewController.delegate = delegate
        featureFlagsViewController.navigationSettings = navigationSettings
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            FeatureFlags.refresh()
        }
        navigationController.pushViewController(featureFlagsViewController, animated: animated)
    }
    
    public static func pushFeatureFlags(delegate: FeatureFlagsViewControllerDelegate? = nil,
                                        navigationController: UINavigationController,
                                        navigationSettings: ViewControllerNavigationSettings) {
        let featureFlagsViewController = FeatureFlagsViewController(style: .grouped)
        featureFlagsViewController.delegate = delegate
        featureFlagsViewController.navigationSettings = navigationSettings
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            FeatureFlags.refresh()
        }
        navigationController.pushViewController(featureFlagsViewController, animated: navigationSettings.animated)
    }
    
}
