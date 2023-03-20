//
//  VeriDetayViewController.swift
//  ShopListApp
//
//  Created by Yunus Emre Berdibek on 15.03.2023.
//

import UIKit

class VeriDetayViewController: UIViewController {
    
    @IBOutlet weak var labelEsyaFiyat: UILabel!
    @IBOutlet weak var labelEsyaBeden: UILabel!
    @IBOutlet weak var labelEsyaAd: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var esya:Alisverisler?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let e = esya {
            labelEsyaAd.text = e.esya_isim
            labelEsyaBeden.text = e.esya_beden
            labelEsyaFiyat.text = String(e.esya_fiyat)
            
            imageView.image = UIImage(data: e.esya_gorsel!)
        }
    }

}
