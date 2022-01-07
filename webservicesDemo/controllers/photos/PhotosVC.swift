//
//  photosVC.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/6/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit

class photosVC: UIViewController {
    
    fileprivate let cellIdentifier = "photoCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var addButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        return button
    }()
    
    lazy var Refresher : UIRefreshControl  = {
        let Refresher = UIRefreshControl()
        Refresher.addTarget(self, action: #selector(HandleRefresh), for: .valueChanged)
        
        return Refresher
    }()
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = addButton
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(Refresher)
        collectionView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        HandleRefresh()
    }
    
    var picker_image : UIImage?{
        didSet {
            guard let image = picker_image else {return}
            // add images to server
            API.create_Photo(photo: image) { (error:Error?, success:Bool) in
                if success {
                    // update  collection view
                    
                  //  self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func handleAdd() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
    //    picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
   
    var isLoading :Bool = false
    var current_page = 1
    var last_page = 1
    
    @objc  fileprivate func HandleRefresh (){
        self.Refresher.endRefreshing()
        guard  !isLoading else {return}
        isLoading = true
        
        API.photos{(error :Error? , photos: [Photo]? ,last_page:Int) in
            self.isLoading = false
            if photos != nil{
                self.photos = photos!
                
                self.collectionView.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    
    fileprivate func loadMore(){
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        
        API.photos(page : current_page + 1) {( error :Error? , photos: [Photo]?, lastPage :Int) in
            self.isLoading = false
            if let photos = photos{
                self.photos.append(contentsOf: photos)
                print (self.photos)
                self.collectionView.reloadData()
                self.current_page += 1
            }
        }
    }
}

extension photosVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edited_image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.picker_image = edited_image
        }else if let original_image = info[UIImagePickerController.InfoKey.originalImage] as?UIImage {
            self.picker_image = original_image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension photosVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? photoCell
            else { return UICollectionViewCell () }
        cell.photo = photos[indexPath.item]
        return cell
    }
}

extension photosVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        var width = ( screenWidth - 30 ) / 2
        width = width > 200 ? 200 : width
        return CGSize.init(width: width , height: width )
    }
}
