//
//  ViewController.swift
//  Artist_Top_Albums-iOS
//
//  Created by Med Salmen Saadi on 5/27/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var albumsData = Array<Album>()
    @IBOutlet weak var tv_AlbumsList: UITableView!
    @IBOutlet weak var tf_ArtistName: UITextField!
    
    let api_key = "7c4f02dc7b7d8379dc5a7b1fc68381d5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchAlbums(ArtistName: "cher")
        
        tv_AlbumsList.dataSource=self
        tv_AlbumsList.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAlbums(ArtistName:String) {
        DispatchQueue.main.async {
            Alamofire.request("https://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=\(ArtistName)&api_key=\(self.api_key)&format=json").responseJSON(completionHandler: { (response) in
                
                print("Progress: \(response.timeline.totalDuration)")
                
                switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    let topalbums = json["topalbums"]
                    
                    topalbums["album"].array?.forEach({ (album) in
                        
                        var imgsData: [Image] = []
                        
                        album["image"].array?.forEach({ (img) in
                            let img = Image(text: img["#text"].stringValue)
                            imgsData.append(img)
                        })
                        
                        let art = album["artist"]
                        let artist = Artist(name: art["name"].stringValue)
                        
                        let alb = Album(name: album["name"].stringValue, playcount: album["playcount"].stringValue, artist: artist, images: imgsData)
                        self.albumsData.append(alb)
                    })
                    self.tv_AlbumsList.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TVCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TVCell
        
        cell.la_AlbumName.text=albumsData[indexPath.row].name
        cell.la_Playcount.text =  albumsData[indexPath.row].playcount
        cell.la_ArtistName.text =  albumsData[indexPath.row].artist.name
        
        Alamofire.request(albumsData[indexPath.row].images[2].text).responseImage { response in
            if let image = response.result.value {
                cell.iv_Album.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animate(withDuration: 0.5,
                       animations: {cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)},
                       completion: nil)
    }
    
    @IBAction func bt_Search(_ sender: Any) {
        albumsData.removeAll()
        
        //remove spaces from a String
        let resultSpace = tf_ArtistName.text?.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range:nil)
        
        //remove diacritics from a String
        let resultDiacritic = resultSpace?.folding(options: .diacriticInsensitive, locale: .current)
        
        fetchAlbums(ArtistName: resultDiacritic!)
        print(resultDiacritic!)
    }
}

