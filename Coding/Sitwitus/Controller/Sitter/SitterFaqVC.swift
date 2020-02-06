//
//  SitterFaqVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SitterFaqVC: UIViewController {


                                    //******** OUTLETS ***************
 @IBOutlet weak var faqTable : UITableView!


                                   //******** VARIABLES *************
 var selectIndex = -1
     var cellHeight: CGFloat = 80.0
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     faqTable.delegate = self
     faqTable.dataSource = self
     faqTable.reloadData()
     
     
     let faqNib = UINib(nibName: "FAQTableViewCell", bundle: nil)
     faqTable.register(faqNib, forCellReuseIdentifier: "FAQ")
     
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
               self.dismiss(animated: true, completion: nil)
          }

}




                                      //*************** EXTENSION ******************

extension SitterFaqVC: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "FAQ", for: indexPath) as! FAQTableViewCell
          
          
          cell.answerView.isHidden = true
          
          if self.selectIndex == indexPath.row {
               
               cell.answerView.isHidden = false

               let test = cell.answerText.text!
               
               let checkHeight = heightForView(text: test, width: cell.answerView.frame.width)
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


