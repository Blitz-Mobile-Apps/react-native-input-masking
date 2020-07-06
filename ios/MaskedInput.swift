
import UIKit
import AVFoundation

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

  
class SimpleInput : UIView,  UITextFieldDelegate  {
  
  
  
  
  
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
  @objc var fontType: String = "PB"


  

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
  
  
  func insertExplicitMaskValues () -> String {
    var expStr = ""
    var mainStr = self.textField.text
    for (index,each) in maskFormat.enumerated() {
      if(each.isLetter && each.isLowercase){
        expStr = String(each)
//        mainStr! += expStr
          
          
      }
      if(each.isNumber){
        expStr = String(each)
//        mainStr! += expStr
//        mainStr?.insert(each, at: String.Index(encodedOffset: index))
      }
      
    }
    print("New string is",mainStr)
    return mainStr!

  }
  
  func identifySeperator(){
    for each in maskFormat {
      
        if(each == "+" )
//          && maskFormat == "+DD-DDDD-DDDDDD")
        {
          print("Type of masking: Phone number masking")
          self.maskIdentifier = "-"
          if(textField.text?.count == 1){
            preText="+"
//            preText += insertExplicitMaskValues()
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
//    textField.addTarget(self, action:  #selector(toggleEditing), for: .allEditingEvents)
//    self.textField.addTarget(self, action:  #selector(toggleEditing), for: .allEditingEvents)
    
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
//    self.frame = textField.frame
    self.frame = self.bounds
//    intializeEditingEvents()
    self.textField.text = value
    // for testing purposes adding background color
//    textField.backgroundColor = UIColor.systemBlue
    self.textField.adjustsFontSizeToFitWidth = true;
//    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 50, right: 50)
//    self.textRect(forBounds: bounds.inset(by: padding))
    self.textField.font = UIFont.systemFont(ofSize: textSize)
    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.textField.placeholder = "Enter text here"
    self.becomeFirstResponder()
//    self.self.addInteraction(UI)
    self.textField.borderStyle = UITextField.BorderStyle.roundedRect
    self.textField.autocorrectionType = UITextAutocorrectionType.no
    self.textField.keyboardType = UIKeyboardType.default
    self.textField.returnKeyType = UIReturnKeyType.done
    self.textField.clearButtonMode = UITextField.ViewMode.whileEditing
    self.textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//    self.beginTracking, with: <#T##UIEvent?#>)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture(_:)))
    self.addGestureRecognizer(tapGesture)
    self.textField.addTarget(self, action:  #selector(toggleEditing), for: .editingChanged)
//    var frame = self.textField.frame
////    frame.size.height = textField.intrinsicContentSize.height
////    frame.size.width = textField.intrinsicContentSize.width
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
    
          if(_char.isLetter && _char.isLowercase){
            isValidated =  true

          }
          if(_char.isNumber){
          isValidated =  true

          }
    
    
    
    if(!isValidated){
      onErrorForMasking!(["error":"Unknown masking identifier"])
    }

    return isValidated
  }
  
  
 @objc func focus() {
    self.textField.becomeFirstResponder()
    print("Became first responder by js ref focus")
  }
  
  @objc func update(value: NSNumber) {
     print("Getting ref value count from js: ", value)
   }

  override func becomeFirstResponder() -> Bool {
    true
  }
  
   private func prepareMask(){

  
        var newStr = ""
        let test = self.textField.text;
    for (index,each) in test!.enumerated() {
          if(textField.text!.count >= 1){
           
            let test_char = maskFormat[maskFormat.index(maskFormat.startIndex, offsetBy: index)]
            print("Last item is : ",each , test_char , test!.count, index)

            
            if(validateCharacter(_char: test_char)){
          let charIdentifier = test_char
          print(charIdentifier,"here it is")
          newStr += String(charIdentifier)
          self.textField.text = newStr
          }
            
            // temporary as far as i know, cause it stands against the main idea of inputMasking i.e : being able to generalize alphabets and digits rather than merely giving explicit alphas and digits in the mask itself
          
            
            
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
//    else if(textField.text!.count == maskFormat.count){
//      toastMessage = "Max length reached"
//    }
    else{
    print("Toggled editing from js to native")
    identifySeperator()
    prepareMask()
//    print("New", insertExplicitMaskValues())
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
    
//    textField.placeholder = placeholder
//    textField.sendActions(for: .editingChanged)
//    textField.font = UIFont.systemFont(ofSize: textSize)
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
  
  
  private func setFontType() -> UIFont {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
    
    guard let customFont = UIFont(name: fontType, size: textSize) else{
      onErrorForMasking!(["error":"Failed to Load the font provided"])
      print("Failed to find font provided")
      return UIFont(name: "AmericanTypewriter-CondensedBold", size: textSize)!;
    }
    return customFont
    
//    switch fontType {
//    case "PB":
//
//      guard let customFont = UIFont(name: fontType, size: textSize) else {
//              fatalError("""
//                  Failed to load the "CustomFont-Light" font.
//                  Make sure the font file is included in the project and the font name is spelled correctly.
//                  """
//              )
//          }
//          return customFont
//    default:
//      print("Default")
//      guard let customFont = UIFont(name: "AmericanTypewriter-CondensedBold", size: textSize) else {
//          fatalError("""
//              Failed to load the "CustomFont-Light" font.
//              Make sure the font file is included in the project and the font name is spelled correctly.
//              """
//          )
//      }
//      return customFont
//    }
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
//        case "placeholderTextColor":
//          let color = UIColor(hex: placeholderTextColor)
//          self.textField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                                    attributes: [NSAttributedString.Key.foregroundColor: color!])
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
        case "fontType":
          self.textField.font = setFontType()
          print("One prop at a time", prop)
        case "textColor":
          let color = UIColor(hex: textColor)
          self.textField.textColor = UIColor.red
          print("One prop at a time", prop)

        default:
        print("One prop at a time..")

        }
//        if(prop == "textSize"){
//          self.textField.font = UIFont.systemFont(ofSize: textSize)
//          print("One prop at a time", prop)
//        }
//        if(prop == "placeholder"){
//          self.textField.placeholder = placeholder
//          print("One prop at a time", prop)
//        }
//        if(prop == "placeholderTextColor"){
//          let color = UIColor(hex: placeholderTextColor)
//              let paraStyle: NSParagraphStyle = NSParagraphStyle()
//          self.textField.typingAttributes = [NSAttributedString.Key.foregroundColor : color ?? UIColor.purple, NSAttributedString.Key.paragraphStyle : paraStyle, NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue-Bold", size: 16) as Any]
//                 print("One prop at a time", prop)
//               }
        
      }else{
        print("Toggle text found")
      }
      
    }
    
  }
  
//  @objc func setText(){
////    textField.text = !(toggleText != nil)
//
//
//  }
//
  
  
  
}


@objc (SimpleTextRN)
class SimpleTextRN: RCTViewManager {
  override class func requiresMainQueueSetup() -> Bool {
    return true;
  }
  

  
  override func view() -> UIView! {
//    var View  = SimpleInput()
    return SimpleInput()
  }
  
  
  @objc  func focus(_ node:NSNumber) {
      DispatchQueue.main.async {
        let nativeComponent = self.bridge.uiManager.view(forReactTag: node) as! SimpleInput
        nativeComponent.focus()
      }
    }
    
   
    
    @objc func updateFromManager(_ node: NSNumber, count: NSNumber) {
       
       DispatchQueue.main.async {                                // 2
         let nativeComponent = self.bridge.uiManager.view(             // 3
           forReactTag: node                                     // 4
         ) as! SimpleInput                                       // 5
         nativeComponent.update(value: count)                          // 6
       }
     }
}


//@objc (SwiftComponentManager)
//class SwiftComponentManager: RCTViewManager {
//
//  override func view() -> UIView! {
//    let labelView = MyLabelView()
//    labelView.textColor = UIColor.orange
//    labelView.textAlignment = NSTextAlignment.center
//    return labelView
//  }
//
//   func updateValueViaManager(_ node:NSNumber) {
//    DispatchQueue.main.async {
//      let myLabel = self.bridge.uiManager.view(forReactTag: node) as! MyLabelView
//      myLabel.updateValue()
//    }
//  }
//}
//
//class MyLabelView: UILabel {
//
//  private var _myText:String?
//  var myText: String? {
//    set {
//      _myText = newValue
//      self.text = newValue
//    }
//    get {
//      return _myText
//    }
//  }
//
//  func updateValue() {
//    self.backgroundColor = UIColor.red
//    self.myText = "Updated NATIVE value!"
//  }
//
//}
