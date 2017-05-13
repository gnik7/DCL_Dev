//
//  VideoContentViewController.swift
//  DCL
//
//  Created by Nikita Gil on 17.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class VideoContentViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var videoUrl: String?
    lazy var router :Router = Router(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTapPressed))
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.orientation = [UIInterfaceOrientationMask.landscapeRight , UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeLeft]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createPlayer()
    }
    
    private func createPlayer(){
        guard  let vUrl = videoUrl else { return }
        let newUrl = vUrl.replacingOccurrences(of: "https", with: "http")
        let url = URL(string: newUrl)
        
//        let url = URL(string: "http://develop.dcl.stagesrv.net/media/12/trim.58A82824-0914-423D-94C1-D2B2900CD152.MOV")
        
        let asset: AVURLAsset = AVURLAsset(url: url!)
        let statusKey = "tracks"
        asset.loadValuesAsynchronously(forKeys: [statusKey], completionHandler:  {
            
            var error: NSError? = nil
            DispatchQueue.main.async {
                let status: AVKeyValueStatus = asset.statusOfValue(forKey: statusKey, error: &error)
                if status == AVKeyValueStatus.loaded {
                    
                    let player = AVPlayer(url: url!)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.view.bounds
                    self.containerView.layer.addSublayer(playerLayer)
                    player.play()
                    
                }else {
                    Alert.show(controller: self, title: AlertTitle.Error, message: error!.localizedDescription, action: nil)
                    print(error!.localizedDescription)
                }
            }
        })
    }
 
    func gestureTapPressed() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.orientation = [UIInterfaceOrientationMask.portrait]
        router.popViewController()
    }
}
