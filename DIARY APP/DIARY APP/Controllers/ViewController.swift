//
//  ViewController.swift
//  DIARY APP
//
//  Created by Bhavik Darji on 03/12/20.
//

import UIKit
import ObjectMapper
//public let Arr_DiaryList: [DiaryJSONModel] = []


class ViewController: UIViewController {
    
    var Arr_DiaryList: [DiaryJSONModel] = []
    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GetData()
    }
    
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arr_DiaryList.count;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MyDiaryHeaderCell")!
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDiaryCell", for: indexPath) as! MyDiaryCell
        
        cell.lblTitle.text = "\(Arr_DiaryList[indexPath.row].title ?? "")"
        cell.lblDescription.text = "\(Arr_DiaryList[indexPath.row].content ?? "")"
        cell.lblTime.text = "\(Arr_DiaryList[indexPath.row].displaydate!.timeAgo())"
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditTapped(sender:)), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped(sender:)), for: .touchUpInside)
        
        ViewAddShadow(shadowView: cell.viewBgShadow)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    // MARK: - UIButton
    @objc func btnEditTapped(sender:UIButton)
    {
        let vc = StoryBoard.instantiateViewController(withIdentifier: "DairyDetailVC") as! DairyDetailVC
        vc.DiaryDetail = Arr_DiaryList[sender.tag]
        vc.Index = sender.tag
        vc.onSave = {
            self.GetData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnDeleteTapped(sender:UIButton)
    {
        let DeleteAlert = UIAlertController(title: "Delete Diary", message: "Do you really want to delete this Diary?", preferredStyle: .alert)
        DeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .`default`, handler: nil))
        DeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            var Array: [AnyObject] = []
            Array = Constants.kUserDefaults .object(forKey: "DiaryJSONModel") as! [AnyObject]
            Array.remove(at: sender.tag)
            Constants.kUserDefaults .set(Array, forKey: "DiaryJSONModel")
            Constants.kUserDefaults .synchronize()
            self.GetData()
        }))
        
        self.present(DeleteAlert, animated: true, completion: nil)
        
    }
    
}
// MARK: - API
extension ViewController
{
    func DiaryList()
    {
        let Urlstring = ""
        API.api_callMethodPostNew(Constants.notes, withparams: Urlstring, withloder: true, withController:self, sucess: {(_ response: Any) -> Void in
            DispatchQueue.main.async
            {
                var Array: [AnyObject] = []
                Array = response as! [AnyObject]
                Constants.kUserDefaults .set(Array, forKey: "DiaryJSONModel")
                Constants.kUserDefaults .synchronize()
                self.SetUIData(Data: Array)
            }
        }, failure: {(_ error: Error?) -> Void in
            print ("error \(String(describing: error))")
            self.GetData()
        })
        
    }
    func GetData()
    {
        if (Constants.kUserDefaults .object(forKey: "DiaryJSONModel") != nil)
        {
            var Array: [AnyObject] = []
            Array = Constants.kUserDefaults .object(forKey: "DiaryJSONModel") as! [AnyObject]
            if Array.count > 0
            {
                self.SetUIData(Data: Array)
            }else
            {
                DiaryList()
            }
            
        }else
        {
            DiaryList()
        }
        
    }
    func SetUIData(Data:Array<Any>)
    {
        self.Arr_DiaryList.removeAll()
        if let objects = Mapper<DiaryJSONModel>().mapArray(JSONObject: Data){
            self.Arr_DiaryList = objects
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            for diary in objects {
                let isoDate = "\(diary.date ?? "")".replacingOccurrences(of: ".303Z", with: "")
                let isoDate1 = isoDate.replacingOccurrences(of: "T", with: " ")
                
                let date: Date? = dateFormatter.date(from: isoDate1)
                if let date = date {
                    diary.displaydate = date
                    diary.date = isoDate1
                }
            }
            
            self.tblList.reloadData()
        }
    }
}
