//
//  ItemDetailsVCViewController.swift
//  DreamLister
//
//  Created by Pieter Kuijsten on 01/01/2017.
//  Copyright © 2017 Pieter Kuijsten. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVCViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbIMG: UIImageView!
    
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var countStartups = [Counter]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        let tellertje = Counter(context: context)
        tellertje.counter = "1"
        
        ad.saveContext()
        
        getCounter()
        loadFirstData()
        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
        self.titleField.delegate = self
        self.priceField.delegate = self
        self.detailsField.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFirstData() {
        if countStartups.count == 1 {
            let store = Store(context: context)
            store.name = "Bijenkorf"
            
            let store2 = Store(context: context)
            store2.name = "Apple store"
            
            let store3 = Store(context: context)
            store3.name = "HEMA"
            
            let store4 = Store(context: context)
            store4.name = "V&D"
            
            let store5 = Store(context: context)
            store5.name = "DIRK"
            
            let store6 = Store(context: context)
            store6.name = "Albert Heijn"
            
            let store7 = Store(context: context)
            store7.name = "Jumbo"
            
            let itemType1 = ItemType(context: context)
            itemType1.type = "Elektronica"
            
            let itemType2 = ItemType(context: context)
            itemType2.type = "Eten"
            
            let itemType3 = ItemType(context: context)
            itemType3.type = "Andere gadgets"
            
            ad.saveContext()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        }
        if component == 1 {
            let itemType = itemTypes[row]
            return itemType.type
        }
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        }
        if component == 1 {
            return itemTypes.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // nog nix
    }
    
    func getCounter() {
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()
        
        do {
            self.countStartups = try context.fetch(fetchRequest)
        } catch {
            //handle error
        }
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //handle error
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //handle error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbIMG.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title.uppercased()
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = NSString(format: "%.2f", item.price) as String
            detailsField.text = item.details
            thumbIMG.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
                
                if let itemType = item.toItemType {
                    var index = 0
                    repeat {
                        let i = itemTypes[index]
                        if i.type == itemType.type {
                            storePicker.selectRow(index, inComponent: 1, animated: false)
                            break
                        }
                        index += 1
                        
                    } while (index < itemTypes.count)
                }
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbIMG.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        priceField.resignFirstResponder()
        detailsField.resignFirstResponder()
        return(true)
    }
    
}
