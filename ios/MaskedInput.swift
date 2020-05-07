//
//  MaskedInput.swift
//  InputMasking
//
//  Created by Macbook on 07/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import AVFoundation



  extension UIColor {
      func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
          // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
          let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
          let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
          let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
          let alpha = alpha!
          // Create color object, specifying alpha as well
          let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
          return color
      }
    
    func intFromHexString(hexStr: String) -> UInt32 {
         var hexInt: UInt32 = 0
         // Create scanner
      let scanner: Scanner = Scanner(string: hexStr)
         // Tell scanner to skip the # character
      scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
         // Scan hex value
      scanner.scanHexInt32(&hexInt)
         return hexInt
     }
  }

class MaskedInput : UIView,  UITextFieldDelegate  {
  
  
  
  
  
  let someFrame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 30.0)
  
  @objc var disabled : Bool = true;
  @objc var numericErrorText : String = "Digit required";
  @objc var alphaErrorText : String = "Aplhabet required";
  @objc var maskFormat = "DD/DD/DD";
  private var maskIdentifier : String = "/";
  private var isMasking : Bool = false
  @objc var value: String = ""
  @objc var textSize: CGFloat = 15
  @objc var textColor: String = "#fffff"
  @objc var placeholder: String = "Type something"
  @objc var textAlign: String = "left"
  @objc var keyboardType: String = "default"
  @objc var returnKeyType: String = "done"
  @objc var placeholderTextColor: String = "#fffff"
  @objc var onChangeText:RCTDirectEventBlock?
  @objc var onFocusText:RCTDirectEventBlock?
  @objc var onErrorForMasking:RCTDirectEventBlock?
  @objc var onSubmitText:RCTDirectEventBlock?

  

  private var textField : UITextField = UITextField.init(frame: CGRect(x: 0, y: 350, width:350, height: 50))
  
//  private var initialIndex : String.Index = "teeam".firstIndex(of: "a")!;
  private var initialIndexOfSeperator : Int = 3;
  private var lastIndexOfSeperator : Int = 6;


  private var preText : String = "";
  
//  private var thisView : UIView
  override init(frame: CGRect) {
    super.init(frame: frame)
    initilaizeView()
  }
  
  func identifySeperator(){
    for each in maskFormat {
      
        if(each == "+" )
        {
          print("Type of masking: Phone number masking")
          self.maskIdentifier = "-"
          if(textField.text?.count == 1){
            preText="+"
            self.textField.text! = preText
          }
          
          return
        }
        if(each == "/"){
          print("Type of masking: Date masking")
           self.maskIdentifier = "/"
          preText = "";
          return
        }
        if(each == "-"){
          print("Type of masking: Credit card masking")
          self.maskIdentifier = "-"
          return
        }
      
      if(each == "A"){
        print("Type of masking: Id card  masking")
        return
      }
      
      print("None of the above identifiers")
      
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("Editing began")
    onFocusText!(["text":"Focused"])
    isMasking = true;
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    prepareMask()
    onSubmitText!(["text":self.textField.text!])
    print("Editing ended")
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    print("Touch gesture detected")
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return true
  }
  
  
  private func intializeEditingEvents(){
    self.textField.addTarget(self, action: #selector(toggleEditing), for: UIControl.Event.editingDidBegin)
    self.textField.addTarget(self, action: #selector(onTouchInside), for: .touchUpInside)
    self.textField.addTarget(self, action: #selector(onTouchOutside), for: .touchUpOutside)
  }
  
  @objc func onTouchInside(textField: UITextField) {
   //Show AlertView
     print("Touch up inside, start editingk")
   }
  
  @objc func onTouchOutside(textField: UITextField) {
    //Show AlertView
      print("Touch up outside, suspend editing")
    }
  
 
  
  private func initilaizeView(){
    self.frame = self.bounds
//    intializeEditingEvents()
    self.textField.text = value
    // for testing purposes adding background color
    self.textField.adjustsFontSizeToFitWidth = true;
    self.textField.font = UIFont.systemFont(ofSize: textSize)
    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.textField.placeholder = "Enter text here"
    self.becomeFirstResponder()
    self.textField.borderStyle = UITextField.BorderStyle.roundedRect
    self.textField.autocorrectionType = UITextAutocorrectionType.no
    self.textField.keyboardType = UIKeyboardType.default
    self.textField.returnKeyType = UIReturnKeyType.done
    self.textField.clearButtonMode = UITextField.ViewMode.whileEditing
    self.textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture(_:)))
    self.addGestureRecognizer(tapGesture)
    self.textField.addTarget(self, action:  #selector(toggleEditing), for: .editingChanged)
    textField.delegate = self
    self.addSubview(textField)
    self.sizeToFit()
    self.translatesAutoresizingMaskIntoConstraints = true
  
  }
  
  var toggleCount: Int = 0
  
  
  
  func validateCharacter(_char: Character) -> Bool{
    var isValidated = false;
      if(_char == "-" || _char == "(" || _char == ")" || _char == "#" || _char == "@"){
        isValidated =  true
      }
    if(_char == "+" || _char == "*" || _char == "|" || _char == " "){
      isValidated =  true
    }
    if(_char == "/"){
      isValidated =  true
    }
    
    if(!isValidated){
      onErrorForMasking!(["error":"Unknown masking identifier"])
    }

    return isValidated
  }
  
  
  

  
  
   private func prepareMask(){

  
        var newStr = ""
        let test = self.textField.text;
    for (index,each) in test!.enumerated() {
          if(textField.text!.count >= 1){
           
            let test_char = maskFormat[maskFormat.index(maskFormat.startIndex, offsetBy: index)]
            print("Last item is : ",each , test_char , test!.count, index)

            
            if(!test_char.isLetter && !test_char.isNumber && validateCharacter(_char: test_char)){
          let charIdentifier = test_char
          newStr += String(charIdentifier)
          self.textField.text = newStr
          }
            
            
          if(test_char == "A" && each.isLetter){
            newStr += String(each)
            self.textField.text = newStr
          } else if(test_char == "A" && !each.isLetter){
            onErrorForMasking!(["error":alphaErrorText])
//            onChangeText!(["text":self.textField.text!])

            }
            
          if(test_char == "D" && each.isNumber){
            newStr += String(each)
            self.textField.text = newStr
          }else if(test_char == "D" && !each.isNumber){
            onErrorForMasking!(["error":numericErrorText])
          }
            
            
          }else{
            print("Looping seamlessly,", index)
          }
        }
        
    }
    
    
    
  
   
  
  @objc private func toggleEditing(){
    if(textField.text!.count > maskFormat.count){
      textField.deleteBackward()
    }
    else{
    print("Toggled editing from js to native")
    identifySeperator()
    prepareMask()
    }
    onChangeText!(["text":self.textField.text!])
    

  }
  
  
  
  @objc private dynamic func didRecognizeTapGesture(_ gesture: UITapGestureRecognizer) {
      let point = gesture.location(in: gesture.view)
    
    

      guard gesture.state == .ended, self.frame.contains(point) else { return }

    print("Tap gesture detected on self")
    
    self.textField.addTarget(self, action:  #selector(toggleEditing), for: .allEditingEvents)
      //doSomething()
  }
  
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  
  

  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      // return NO to disallow editing.
      print("TextField should begin editing method called")
      return true
  }
  
  private func textFieldDidBeginEditing(textField: UITextField) -> Bool {
      if textField == textField {
        print(" In true Touched....")

          return true // myTextField was touched
      }
    print("Touched....")
    return true
  }
  
  
  
  
  override func didSetProps(_ changedProps: [String]!) {
    
    setProps(propsArray: changedProps)
    
    print("Did set prop", changedProps ?? "not changed")
    
  }
  
  private func setTextAlignment() -> NSTextAlignment {
    switch textAlign {
    case "center":
      return NSTextAlignment.center
    case "left":
      return NSTextAlignment.left
   case "right":
      return NSTextAlignment.right
   case "justified":
      return NSTextAlignment.justified
    default:
     return NSTextAlignment.natural

    }
  }
  
  
  
  private func setKeyboardType() -> UIKeyboardType {
    
    switch keyboardType {
    case "email-address":
      return UIKeyboardType.emailAddress
    case "number-pad":
      return UIKeyboardType.numberPad
    case "decimal-pad":
      return UIKeyboardType.decimalPad
    case "alphabet":
      return UIKeyboardType.alphabet
    case "date-time":
      return UIKeyboardType.phonePad
    case "phone-pad":
      return UIKeyboardType.phonePad
    default:
      return UIKeyboardType.default

    }
    
  }
  
  private func setReturnKeyType() -> UIReturnKeyType {
    
    switch returnKeyType {
    case "go":
      return  UIReturnKeyType.go
    case "next":
       return  UIReturnKeyType.next
    case "search":
       return  UIReturnKeyType.search
    case "done":
      return  UIReturnKeyType.done
    case "google":
      return  UIReturnKeyType.google
    case "continue":
      return  UIReturnKeyType.continue
    case "emergency":
      return  UIReturnKeyType.emergencyCall
    case "send":
      return  UIReturnKeyType.send
    default:
      return UIReturnKeyType.done

    }
    
  }
  
  
  private func setProps(propsArray:[String]!){
    
  
    for prop in propsArray{
      if(prop != "onChangeText"){
        switch prop {
        case "textSize":
           self.textField.font = UIFont.systemFont(ofSize: textSize)
          print("One prop at a time", prop)
        case "placeholder":
           self.textField.placeholder = placeholder
          print("One prop at a time", prop)
         print("One prop at a time", prop)
        case "disabled":
          self.textField.isEnabled = disabled;
          print("One prop at a time", prop)
        case "value":
          self.textField.text = value
          print("One prop at a time", prop)
        case "keyboardType":
          self.textField.keyboardType = setKeyboardType()
          print("One prop at a time", prop)
        case "textAlign":
          self.textField.textAlignment = setTextAlignment()
          print("One prop at a time", prop)
        case "returnKeyType":
          self.textField.returnKeyType = setReturnKeyType()
          print("One prop at a time", prop)
        case "textColor":
          let color = UIColor().HexToColor(hexString: textColor, alpha: 1.0)
          self.textField.textColor = color
          print("One prop at a time", prop)

        default:
        print("One prop at a time..")

        }
        
      }else{
        print("Toggle text found")
      }
      
    }
    
  }

  
  
}


@objc (InputMasking)
class InputMasking: RCTViewManager {
  override class func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  override func view() -> UIView! {
    return MaskedInput()
  }
}

