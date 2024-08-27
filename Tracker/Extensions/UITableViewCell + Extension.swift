import UIKit

extension UITableViewCell {
    func setSeparatorInset(forRowAt indexPath: IndexPath, totalRows: Int) {
        if indexPath.row == totalRows - 1 {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
