//
//  ArranqueViewController.swift
//  InternalPoCWebViewTokenJWT
//
//  Created by TECDATA ENGINEERING on 4/5/23.
//

import UIKit

class ArranqueViewController: UIViewController {
    
    @IBAction func GoGlobalPsitionACTION(_ sender: UIButton) {
        let vc = DirectViewControllerCoordinator.view()
        vc.modalPresentationStyle = .formSheet
        
        self.present(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
