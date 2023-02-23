//
//  FaqViewModel.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 19/04/22.
//

import UIKit

class FaqViewModel: NSObject {
    var faqList : [FaqResponseModel]?
    var isRememberMe:Bool = false
    
    override init() {}
}

extension FaqViewModel {
    func getFaqDetail(_ completion: @escaping (_ result: Bool) -> Void) {
        APIServiceAlamofire<[FaqResponseModel]>.responseObject(BaseAPIRequest(.faqs)) { result in
            switch result {
                case .success(let responseList):
                    self.faqList = responseList
                    completion(true)
                case .failure(let error):
                    AppUtility.shared.printToConsole(error)
                    completion(false)
            }
        }
    }
    
    func getContactUs(_ contactRequest: ContactRequestModel,  completion: @escaping (_ result: Bool) -> Void) {
        APIServiceAlamofire<[FaqResponseModel]>.responseObject(BaseAPIRequest(.faqs)) { result in
            switch result {
                case .success(let responseList):
                    self.faqList = responseList
                    completion(true)
                case .failure(let error):
                    AppUtility.shared.printToConsole(error)
                    completion(false)
            }
        }
    }
    
    func updateProfilePicture(_ profileRequest: updateProfileRequestModel,  completion: @escaping (_ result: Bool) -> Void) {
        
        let mediaRequest = MediaAPIRequest(.updateProfile(parameters: profileRequest.dictionary), mediaType: .image, mediaData: profileRequest.file, mediaFileURL: profileRequest.fileURL, mediaFileName: profileRequest.fileName, uploadParamName: "file")
        
        APIServiceAlamofire<UserResponseModel>.uploadMedia(request: mediaRequest) { result in
            switch result {
                case .success(let responseData):
                    print(responseData as Any)
                    completion(true)
                case .failure(let error):
                    AppUtility.shared.printToConsole(error)
                    completion(false)
            }
        } progressCompletion: { progressStatus in
            print("Progress ==>\(progressStatus)")
        }
        
    }
}
