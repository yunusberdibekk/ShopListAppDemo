//
//  VeriEkleViewController.swift
//  ShopListApp
//
//  Created by Yunus Emre Berdibek on 15.03.2023.
//

import UIKit
import CoreData

class VeriEkleViewController: UIViewController {
    
    @IBOutlet weak var textFieldBeden: UITextField!
    @IBOutlet weak var textFieldFiyat: UITextField!
    @IBOutlet weak var textFieldIsim: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let context = appDelegate.persistentContainer.viewContext
    
    var resimSecildiMi = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)//Jest algılayıcı ile boşluğa tıklayınca klavyeyi kapatma.
        
        imageView.isUserInteractionEnabled = true //imageView tıklama özelliği verildi.
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @IBAction func kaydetButonAction(_ sender: Any) {
        veriEkle()
    }
    
    func veriEkle() {
        let esya = Alisverisler(context: context)
        
        if let esya_isim = textFieldIsim.text, let esya_beden = textFieldBeden.text, let esya_fiyat =  Int32(textFieldFiyat.text!){
            
            if resimSecildiMi{
                esya.esya_isim = esya_isim
                esya.esya_beden = esya_beden
                esya.esya_fiyat = esya_fiyat
                esya.esya_gorsel = imageView.image!.jpegData(compressionQuality: 0.5)
                
                appDelegate.saveContext()
            } else {
                print("Kayıt işlemi yapılmadı.Lütfen bir resim seçin.")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension VeriEkleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func gorselSec() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        resimSecildiMi = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
}
