//
//  InfoViewController.swift
//  JapaneseVocabulary
//
//  Created by 김기훈 on 2022/03/26.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Developer : Hosung.Kim\n\nEmail : <hyongak516@mail.hongik.ac.kr>"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backOnClick(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
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
