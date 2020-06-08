//
//  ShareViewController.swift
//  SharePic
//
//  Created by Kirti Ahlawat on 06/06/20.
//  Copyright © 2020 Outect. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    var imageType = ""

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        
        print("In Did Post")
            if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
                print("Item \(item)")
                for ele in item.attachments!{
                    print("item.attachments!======&gt;&gt;&gt; \(ele )")
                    let itemProvider = ele
                    print(itemProvider)
                    if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                        imageType = "public.jpeg"
                    }
                    if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
                         imageType = "public.png"
                    }
                    print("imageType\(imageType)")
                    
                    if itemProvider.hasItemConformingToTypeIdentifier(imageType){
                        print("True")
                        itemProvider.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { (item, error) in
                            
                            var imgData: Data!
                            if let url = item as? URL{
                                imgData = try! Data(contentsOf: url)
                            }
                            
                            if let img = item as? UIImage{
                                imgData = img.pngData()
                            }
                            print("Item ===\(item)")
                            print("Image Data=====. \(imgData))")
                            let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                            let savedata =  UserDefaults.init(suiteName: "group.com.outect.photoApp")
                            savedata?.set(dict, forKey: "img")
                            savedata?.synchronize()
                            print("ImageData \(String(describing: savedata?.value(forKey: "img")))")
                        })
                    }
                }
            }
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
