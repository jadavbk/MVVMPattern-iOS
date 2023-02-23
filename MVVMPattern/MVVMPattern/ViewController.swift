//
//  ViewController.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 13/04/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imgUser: UIImageView!
    var viewModel = FaqViewModel()
    var imagePath: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        getFAQ()
//        getContactUS()
    }

    func getFAQ() {
        viewModel.getFaqDetail() { (status) in
            if status {
                AppUtility.shared.printToConsole(self.viewModel.faqList ?? [])
            }
        }
    }
    
    func getContactUS() {
        var request = ContactRequestModel()
        request.emailid = "test@mailnasia.com"
        request.message = "Testing.jpg"
        viewModel.getContactUs(request, completion: { status in
            if status {
                AppUtility.shared.printToConsole("Success")
            }
        })
    }
    
    
    @IBAction func clickUpload() {
        //let soundPath = Bundle.main.path(forResource: "testprofile.png", ofType:nil)!
        let soundURL = URL(fileURLWithPath: imagePath ?? "")
        var request = updateProfileRequestModel()
        //request.file = imgUser.image?.pngData()
        request.fileURL = soundURL
        request.fileName = "testprofile.jpg"
        request.bio = "NewTest Bio bio"
        viewModel.updateProfilePicture(request) { status in
            if status {
                AppUtility.shared.printToConsole("Success")
            }
        }
    }
}

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBAction func btnTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            imagePath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            imgUser.image = image
            let data = image.pngData()! as NSData
            data.write(toFile: imagePath ?? "", atomically: true)
            let photoURL = URL.init(fileURLWithPath: imagePath ?? "")
            let filename = photoURL.lastPathComponent
            print(filename)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

