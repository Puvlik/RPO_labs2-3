import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 0.3,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.8
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.3,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
}
