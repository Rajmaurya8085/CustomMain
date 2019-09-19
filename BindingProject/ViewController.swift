//
//  ViewController.swift
//  BindingProject
//
//  Created by Raunaque Quaiser on 18/09/19.
//  Copyright © 2019 Rajmaurya_Personal_inc. All rights reserved.
//

import UIKit

var cache = NSCache<NSString, UIImage>()
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataModel:[DataModel] = [DataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getDataFromApi { [weak self](dataModel) in
            self?.dataModel = dataModel +  dataModel + dataModel
            DispatchQueue.main.sync {
            self?.tableView.reloadData()
            }
        }
    }
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(tableView, forKey: "tableViewData")
    }

   
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
    }
    
  
}


extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath)
        as? ListTableViewCell
        cell?.setDataOnCell(data:dataModel[indexPath.row])
        cell?.selectionStyle = .none
        return cell!
    }
}


class ListTableViewCell:UITableViewCell{
    
    @IBOutlet weak var imageLbl: UIImageView!
    @IBOutlet weak var contextLbl: UILabel!
    
    func setDataOnCell(data:DataModel){
        contextLbl.text = data.content
//        imageLbl.trailingAnchor.constraint(equalTo:contextLbl.leftAnchor.cc).isActive = false
        guard let imageUrl = data.image_url, let url = URL(string: imageUrl) else{
            if imageLbl != nil{
       // imageLbl.removeFromSuperview()
            }
            return}
        //  URLSession.shared.delegate = self
        if let   image =   cache.object(forKey: url.absoluteString as NSString){
            if imageLbl != nil{
         self.imageLbl.image = image
            }
      }else{
        URLSession.shared.dataTask(with:url) {[weak self] (data, response, error) in
            guard let responseData = data, error == nil else{return}
            DispatchQueue.main.async {
            self?.imageLbl.image = UIImage(data: responseData)
            cache.setObject((self?.imageLbl.image!)!, forKey: response?.url?.absoluteString as! NSString )
            }
        }.resume()
    }
    }
    override func prepareForReuse() {
        if imageLbl != nil{
        imageLbl.image = nil
        }
        contextLbl.text = ""
       
    }
}


extension ListTableViewCell:URLSessionDelegate{
    
}

@IBDesignable
extension UIView{

    @IBInspectable var coRedius:CGFloat{
    set{
       self.layer.cornerRadius = newValue
        }get{
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var boderCoder:UIColor{
        set{
            
            self.layer.borderColor = newValue.cgColor
        }
        get{
            return UIColor(cgColor: (self.layer.borderColor)!)
        }
    }
    
    @IBInspectable var borderWith:CGFloat{
        set{
            self.layer.borderWidth = newValue
        }
        get{
           return self.layer.borderWidth
        }
    }
}
