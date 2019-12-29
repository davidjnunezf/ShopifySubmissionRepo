

import UIKit


protocol ChangeCityDelegate {
    func userEnteredANewCityName(city:String)
}


class ChangeCityViewController: UIViewController {
    
  
    var delegate:ChangeCityDelegate?
    
    
   
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        //  Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        //  If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        // dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
