//
//  SaveVideoViewModel.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 18/03/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import Firebase
import AVFoundation

class SaveVideoViewModel{

func SaveVideoViewModel(Title : String, selectedVideoUrl : URL, completion: @escaping (_ uploadImageUrl: String?,_ Status : Bool,_ errorMsg : String?)->()){
    
//
//    print(Title)
//    print(selectedImage)
//    print(Auth.auth().currentUser?.uid)
    
     
     
     
    let storage  = Storage.storage()
    let storageRef = storage.reference()
    

  
     let vdoData = NSData(contentsOf: selectedVideoUrl)
     let uploadMetadata = StorageMetadata()
     uploadMetadata.contentType = "video/mp4"
     
     
    // ******* Create Image Reference ************
    let uploadImageRef = storageRef.child("Videos").child((Auth.auth().currentUser?.uid)!).child(Title)
    
    //  upload the image file to respective path
    
   uploadImageRef.putData(vdoData! as Data, metadata: uploadMetadata) { (metaData, err) in
        
        if err  != nil{
            
            completion(nil, false, err?.localizedDescription)
        }
    
        else{
            uploadImageRef.downloadURL(completion: { (downloadUrl, downlodError) in
                
        
                if downlodError == nil{
                completion(downloadUrl?.absoluteString,true,nil)
            }
                else{
                     completion(nil, false, err?.localizedDescription)
                }
                
                
            })
        }
    }
    
    
    
}
}
