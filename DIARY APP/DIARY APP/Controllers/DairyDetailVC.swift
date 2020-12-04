//
//  DairyDetailVC.swift
//  DIARY APP
//
//  Created by Bhavik Darji on 03/12/20.
//

import UIKit

class DairyDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtviewDescription: UITextView!
    var DiaryDetail: DiaryJSONModel!
    var Index: Int!
    
    var onSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "\(DiaryDetail.title ?? "")"
        txtTitle.text = "\(DiaryDetail.title ?? "")"
        txtviewDescription.text = "\(DiaryDetail.content ?? "")"
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIButton
    @IBAction func BackClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SaveClicked(_ sender: UIButton)
    {
        dismiss(animated: true) { [self] in
            if (onSave != nil) {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") 
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.string(from: Constants.kDateToday)
                
                var Array: [[String:Any]] = []
                Array = Constants.kUserDefaults .object(forKey: "DiaryJSONModel") as! [[String:Any]]
                Array[Index!] = ["id":"\(DiaryDetail.id ?? "")","title":"\(txtTitle.text ?? "")","content":"\(txtviewDescription.text ?? "")","date":"\(date)","displaydate":"\(date)"]
                Constants.kUserDefaults .set(Array, forKey: "DiaryJSONModel")
                Constants.kUserDefaults .synchronize()
                
                onSave!()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
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
