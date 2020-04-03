import UIKit

final class BlackModelHelper {
    func checkColor() -> UIColor {
        switch UITraitCollection.current.userInterfaceStyle {
        case
          .unspecified,
          .light: return .black
        case .dark: return .white
        @unknown default:
            return .white
        }
    }
}
