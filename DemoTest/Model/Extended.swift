

import Foundation
import UIKit


extension UIView {
    
    func makeCircle() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    
    func makeAppImageRoundedWithLine() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 5
        self.clipsToBounds = true
    }
    
    func makeAppImageRounded() {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 5
        self.clipsToBounds = true
    }
}


private var downloadImageDataTaskKey: UInt8 = 0
extension UIImageView {
    // use a private download session
    static private let downloadSession: URLSession = {
        let config = URLSessionConfiguration.default;
        config.httpMaximumConnectionsPerHost = 2;
        config.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024)
        return URLSession(configuration: config);
    }()
    
    var dataTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &downloadImageDataTaskKey) as? URLSessionDataTask
        }
        set(newValue) {
            objc_setAssociatedObject(self, &downloadImageDataTaskKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
 
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, loadingPlaceholder: UIImage? = nil, errorPlaceholder: UIImage? = nil) {
        objc_sync_enter(self)
        contentMode = mode
        if let previousTask = self.dataTask,
           previousTask.state == .running
        {
            if previousTask.originalRequest?.url == url {
                objc_sync_exit(self)
                return; // just let it continues to run
            } else {
                previousTask.cancel();
            }
        }
        
        let dataTask = UIImageView.downloadSession.dataTask(with: url) { [weak self] data, response, error in
            if let _self = self {
                objc_sync_enter(_self)
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    _self.dataTask = nil;
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = errorPlaceholder // TODO: set to a placeholder
                    }
                    objc_sync_exit(_self)
                    return
                }
                _self.dataTask = nil;
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
                objc_sync_exit(_self)
            }
        }
        self.image = loadingPlaceholder; // TODO: set to a placeholder or use a loading view
        dataTask.resume()
        self.dataTask = dataTask
        objc_sync_exit(self)
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func Icondownloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension UITextField{

    func setLeftImage(imageName:String) {

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageName)
        self.leftView = imageView;
        self.leftViewMode = .unlessEditing
    }
}
