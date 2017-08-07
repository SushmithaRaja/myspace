//
//  ViewController.swift
//  google images sush
//
//  Created by sushmitha raja on 06/08/17.
//  Copyright © 2017 sush. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let reachability = Reachability()!
    let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    var imagesArray = [UIImage]()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            typealias jsonObject = [String:AnyObject]
        let googleApi : String = "https://www.googleapis.com/customsearch/v1?q=\(searchBar.text!)&key=AIzaSyCqQhJ-5aAp-ujCc_rQR0UfRIkW7iWt2lI&cx=005041533931235386117:06u2w3qma5c&safe=high&searchType=image"
        guard let myUrl = URL(string: googleApi) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: myUrl)
            urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! jsonObject
                    print(json)
                    if let items = json["items"] as? [jsonObject]
                    {
                        for i in 0..<items.count
                        {
                            let item = items[i] 
                            
                        if let image = item["image"] as? jsonObject
                                 {
                           let thumbnailLink = image["thumbnailLink"]
                                    let imageData = thumbnailLink
                                    let mainImageURL = URL(string: imageData as! String)
                                    let mainImageData = NSData(contentsOf: mainImageURL!)
                                    let mainImage = UIImage(data: (mainImageData as Data?)!)
                                    self.imagesArray.append(mainImage!)
                                    print(self.imagesArray)
                                    if self.imagesArray == [] && self.reachability.whenReachable != nil {
                                        self.label2.center = CGPoint(x: 160, y: 285)
                                        self.label2.textAlignment = .center
                                        self.label2.text = "NO IMAGES FOUND"    // $$$$$$$ if there are no search results $$$$$$
                                        self.view.addSubview(self.label2)
                                        self.label2.isHidden = false
                                    }
                                    else{
                                        self.label2.isHidden = true
                                    }
                                    DispatchQueue.main.async {
                                        self.collectionView?.reloadData()
                                        
                                    }

                                  }
                         }
                    }
                   }
                catch{
                    print("error")
                }}
        })
        task.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.imageView.image = self.imagesArray[indexPath.row]
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
                reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.label1.center = CGPoint(x: 160, y: 285)
                self.label1.textAlignment = .center
                self.label1.text = "NO NETWORK CONNECTION AVAILABLE" // $$$$$$$ if there is no network $$$$$
                self.view.addSubview(self.label1)
                self.label1.isHidden = false
                
            }}
        reachability.whenReachable = { _ in
            DispatchQueue.main.async  {
                self.label1.isHidden = true
            }
        }
    }

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

