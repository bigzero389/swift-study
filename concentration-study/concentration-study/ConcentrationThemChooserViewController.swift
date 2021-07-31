//
//  ConcentrationThemChooserViewController.swift
//  concentration-study
//
//  Created by bigzero on 2021/06/06.
//

import UIKit

class ConcentrationThemChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    // MARK: - Navigation
    
    let themes = [
        "Sports"  : "🏐⚽️⚾️🎾🏉🏈🥎⛸🥊🤺🥋⛳️",
        "Animals" : "🙈🙉🙊💥💦💨💫🐵🐒🦍🐶🐕",
        "Faces"   : "😀😁😂🤣😃😄😅😆😉😊😋😎",
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self;
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true;
            }
        }
        return false;
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme;
            }
        } else if let cvc = lastSequedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme;
            }
            navigationController?.pushViewController(cvc, animated: true);
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender);
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController;
    }
    
    private var lastSequedToConcentrationViewController: ConcentrationViewController?;
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme;
                    lastSequedToConcentrationViewController = cvc;
                }
            }
        }
    }
    

}
