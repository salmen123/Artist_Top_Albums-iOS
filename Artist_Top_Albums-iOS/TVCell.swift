//
//  TVCell.swift
//  Artist_Top_Albums-iOS
//
//  Created by Med Salmen Saadi on 5/27/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {

    @IBOutlet weak var iv_Album: UIImageView!
    @IBOutlet weak var la_AlbumName: UILabel!
    @IBOutlet weak var la_Playcount: UILabel!
    @IBOutlet weak var la_ArtistName: UILabel!
    
    func SetImage(url:String){
        //paralel process
        DispatchQueue.global().async {
            
            do{
                // load json server
                let AppURL=URL(string: url)!
                let data=try Data(contentsOf: AppURL)
                
                // access to UI
                DispatchQueue.global().sync {
                    self.iv_Album.image = UIImage(data: data)
                }
                
            }
            catch {
                print("cannot load from server")
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
