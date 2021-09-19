
import Foundation
import UIKit
import SystemConfiguration
import MapKit
import CoreTelephony


class Util : NSObject {
    override init() {
        
        super.init()
    }
    
    ////NSUserDefaultclass function
    // check if a key saved in nsuserdefault or not
    class func isKeyExits(key:String) -> Bool {
        if (UserDefaults.standard.object(forKey: key) != nil) {
            return true
        }else {
            return false
        }
    }
    // get and set object to nsuserdefault
    class func setObject(value:NSObject, forKey key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getObjectForkey(key:String)->NSObject{
        return UserDefaults.standard.object(forKey: key) as? NSObject ?? "nil" as NSObject
    }
    
    class func setBool(value:Bool, forKey key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func getBoolForKey(key:String)->Bool{
        return UserDefaults.standard.bool(forKey: key)
    }
    class func removeObjectForKey(key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // you can check if a string is valid email
    //eg: with a email textfield and you want to validate it before send it to the api
    
    class func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // you can add an underline to your textfield with a color
    class func addUnderlineToTextfield(textfield : UITextField, color:UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width+10, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
 
    // convert date and string with a format
    class func stringFromDateWithFormat(format: String, fromDate date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    class func dateFromStringWithFormat(format: String, fromDate date: String) -> NSDate {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: date)! as NSDate
    }
    // calculate days between 2 date
    class func durationTimeFromDate(date: NSDate)->Double{
        let elapsedTime = NSDate().timeIntervalSince(date as Date)
        let duration = Double(elapsedTime)
        return duration
    }
    // calculate distance between 2 location (cclocationcoordinate2d is get from map, or just put them latitude and longitude)
    class func calculateDisatnceBetweenTwoLocations(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D) -> Double{
        let sourceLocation: CLLocation =  CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation: CLLocation =  CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        let distanceMeters = sourceLocation.distance(from: destinationLocation)
        let distanceKM = distanceMeters / 1000
        
        return distanceKM
        
    }
    
    
    // get a random date before today
    class func randomWithinDaysBeforeToday(days: Int) -> NSDate {
        let today = NSDate()
        
        guard let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) else {
            print("no calendar \"NSCalendarIdentifierGregorian\" found")
            return today
        }
        
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(23))
        let r4 = arc4random_uniform(UInt32(23))
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = gregorian.date(byAdding: offsetComponents as DateComponents, to: today as Date, options: []) else {
            print("randoming failed")
            return today
        }
        return rndDate1 as NSDate
    }
    
    //// SwiftRandom extension
    class func randomDate() -> NSDate {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return NSDate(timeIntervalSince1970: randomTime)
    }
    class ImageSaver: NSObject {
        func writeToPhotoAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        }

        @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            print("Save finished!")
        }
    }
    
    
    
    
    class func SendLocalNotifcationWithScheduleTime(title:String , subtitle:String , body:String ,link:String , badge:Int, hour:Int, minute:Int, second:Int) {
       
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = NSNumber(value: badge)
        content.sound = UNNotificationSound.default
        content.userInfo = ["link" : link]
        
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        components.hour = hour
        components.minute = minute
        components.second = second
        
        let date = gregorian.date(from: components)!
        
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
        
    }
    
    class func SendLocalNotifcationWithTimer(title:String , subtitle:String , body:String ,link:String , badge:Int, timeInterval:Int) {
       
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = NSNumber(value: badge)
        content.sound = UNNotificationSound.default
        content.userInfo = ["link" : link]
        
        
        // timeInterval = 1 = 1 second, 60 = 1 minute , 3600 = 1 hours
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
        
    }
    
    class func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
    class func validate(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }

        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }

        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest2.evaluate(with: password) else { return false }

        return true
    }
    
   
 
   
}

