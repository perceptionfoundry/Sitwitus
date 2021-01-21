//
//  ParentFaqVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase

class ParentFaqVC: UIViewController {


                                    //******** OUTLETS ***************
 @IBOutlet weak var faqTable : UITableView!


                                   //******** VARIABLES *************
 var selectIndex = -1
var cellHeight: CGFloat = 80.0
     var faqList = [[String:String]]()
     let dbStore = Firestore.firestore()
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     faqTable.delegate = self
     faqTable.dataSource = self
     
     
     
     let faqNib = UINib(nibName: "FAQTableViewCell", bundle: nil)
     faqTable.register(faqNib, forCellReuseIdentifier: "FAQ")
     
     self.getFAQ()
     
    }

     
     func getFAQ(){
          
          dbStore.collection("FAQ").document("Parents").collection("queries").getDocuments { (faqSnap, faqErr) in
               
               guard let fetchValue = faqSnap?.documents else{return}
               
               fetchValue.forEach { (value) in
                    
                    let query = value.data() as! [String:String]
                    
                    self.faqList.append(query)
                    self.faqTable.reloadData()
               }
          }
          
     }

     
     
      func heightForView(text:String, width:CGFloat) -> CGFloat{
          let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
         label.numberOfLines = 0
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.text = text

         label.sizeToFit()
         return label.frame.height
     }

                                    //*************** OUTLET ACTION ******************

         @IBAction func backButton(){
          
          self.navigationController?.popViewController(animated: true)
          
     }

}




                                      //*************** EXTENSION ******************

extension ParentFaqVC: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return faqList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "FAQ", for: indexPath) as! FAQTableViewCell
          
          
          cell.questionaireText.text = "\(indexPath.row + 1) : \((faqList[indexPath.row]["Question"])!)"
          
          cell.answerView.isHidden = true
          
          if self.selectIndex == indexPath.row {
               
               cell.answerView.isHidden = false
               cell.answerText.text = faqList[indexPath.row]["Answer"]
              
               let answer = cell.answerText.text!
               let checkHeight = heightForView(text: answer, width: cell.answerView.frame.width)
               self.cellHeight = checkHeight
               
//               cell.answerView.frame.size.height = checkHeight
               
          }
          return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          
          
          self.selectIndex = indexPath.row
          
          
          faqTable.reloadData()

        
         
          
          
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
          

          if self.selectIndex == indexPath.row{
               
               
//               if cellHeight < 80 {
//                    return CGFloat(self.cellHeight + 100)
//
//               }
//               else{
                    return CGFloat(self.cellHeight + 100)

//               }
               
         
          }
          
          else{
               return 70
               
          }
      
     }
     
     
     
     
}


