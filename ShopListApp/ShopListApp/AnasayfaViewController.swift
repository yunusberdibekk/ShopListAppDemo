//
//  ViewController.swift
//  ShopListApp
//
//  Created by Yunus Emre Berdibek on 15.03.2023.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class AnasayfaViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let context = appDelegate.persistentContainer.viewContext
    
    var alisverisList = [Alisverisler]()
    
    var arananKelime:String?
    var aramaYapiliyorMu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if aramaYapiliyorMu {
            aramaYap(arananKelime: arananKelime!)
        } else{
            tumVerileriGetir()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as?  Int
        
        if segue.identifier == "toDetayVC" {
            let gidilecekVC = segue.destination as! VeriDetayViewController
            
            if indeks != nil {
                gidilecekVC.esya = alisverisList[indeks!]
            }
        }
        
    }
    
    @IBAction func ekleButonAction(_ sender: Any) {
        performSegue(withIdentifier: "toEkleVC", sender: nil)
    }
    
    
    func tumVerileriGetir () {
        do {
            alisverisList = try context.fetch(Alisverisler.fetchRequest())
        } catch  {
            print("Verileri alırken hata oluştu.")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func veriSil(indexPath:IndexPath) {
        let esya = alisverisList[indexPath.row]
        self.context.delete(esya)
        appDelegate.saveContext()
        
        DispatchQueue.main.async {
            
            if self.aramaYapiliyorMu {
                self.aramaYap(arananKelime: self.arananKelime!)
            } else{
                self.tumVerileriGetir()
            }
            self.tableView.reloadData()
        }
    }
    
    func aramaYap(arananKelime:String){
        
        let fetchRequest:NSFetchRequest<Alisverisler> = Alisverisler.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "esya_isim CONTAINS %@",arananKelime)
        
        do{
            alisverisList =  try context.fetch(fetchRequest)
        } catch{
            print("Veri okunurken hata oluştu.")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension AnasayfaViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alisverisList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let esya = alisverisList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = esya.esya_isim
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetayVC", sender:indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            veriSil(indexPath: indexPath)
        }
    }
}

extension AnasayfaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arananKelime = searchText
        
        if arananKelime == "" {
            tumVerileriGetir()
            aramaYapiliyorMu = false
        } else{
            aramaYap(arananKelime: arananKelime!)
            aramaYapiliyorMu = true
        }
        
    }
}
