#  Nuvei Mobile SDK
## Requirements
| Platform | Minimum Swift Version | Installation |
| --- | --- | --- |
| iOS 15.0+ | 5.10 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) |

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift project set up, adding NuveiSimplyConnectSDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`. Then you can choose which module you want to add(one or more). You don't need to import Core and PayService explicitly, they will be added automatically if needed.

```swift
dependencies: [
	.package(url: "https://github.com/Nuvei/nuvei-mobile-simply-connect-ios.git", .upToNextMajor(from: "2.1.0"))
]
```

## Documentation
You can Option+Click on the methods and properties to view documentation.

## How to use?
```swift
let amount: String
let currency: String
let userTokenId: String
let merchantId: String
let merchantSiteId: String
let secret: String

let clientRequestId = UUID().uuidString.lowercased()

let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: "en_US_POSIX")
dateFormatter.dateFormat = "yyyyMMddHHmmss"
let timeStamp = dateFormatter.string(from: Date())

let checksum: String = getCheckSum(
	amount: amount,
	currency: currency,
	merchantId: merchantId,
	merchantSiteId: merchantSiteId,
	clientRequestId: clientRequestId,
	timeStamp: timeStamp,
	secret: secret
)

let parameters: [String: Any] = [
	"amount": amount,
	"currency": currency,
	"userTokenId": userTokenId,
	"merchantId": merchantId,
	"merchantSiteId": merchantSiteId,
	"secret": secret,
	"clientRequestId": clientRequestId,
	"timeStamp": timeStamp,
	"checksum": checksum,
	"items": [[
		"price": amount,
		"quantity": "1",
		"name": "Test"
		]],
	"billingAddress": [
		"country": Locale.current.regionCode?.uppercased() ?? "US",
		"email": userTokenId
	]
]

Alamofire.Session.default
	.request("\(NuveiSimplyConnect.getEnvBaseUrl())openOrder.do", method: .post, parameters: parameters, encodingJSONEncoding.default)
	.responseJSON(queue: .main, options: []) { [weak self] (response) in
		var responseJson : JSON?
		switch response.result {
		case .success:
			// do something
		case .failure(let error):
			// handle error
		}
}


func getCheckSum(
    amount: String,
    currency: String,
    merchantId: String,
    merchantSiteId: String,
    clientRequestId: String,
    timeStamp: String,
    secret: String
    ) -> String {
    
    let string = "\(merchantId)\(merchantSiteId)\(clientRequestId)\(amount)\(currency)\(timeStamp)\(secret)"
    let byteData = sha256(data: string.data(using: .utf8)!)
    
    let hash = NSMutableString()
    for i in 0..<byteData.count {
        hash.appendFormat("%02x", byteData[i])
    }
    return hash as String
}

func sha256(data: Data) -> Data {
    var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = digest.withUnsafeMutableBytes { (digestBytes) in
        data.withUnsafeBytes { (stringBytes) in
            CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
        }
    }
    return digest
}
```

To start payment process first you have to create HTTP request openOrder.do. In the example we use Alamofire but you can use whatevere you want. Check if the response has a session token and in this case proceed with the payment flow you want.

### ApplePay
```swift
NuveiSimplyConnect.setup(environment: {NuveiSimplyConnect.Environment})
```
With NuveiSimplyConnect.setup(environment:customization:) you setup the enviroment.

---

```swift
let applePayButton = ApplePayButton(uiOwner: {ViewController}, input: {Input}, auth3dSupported: {Auth3dSupported}, forceWebChallenge: {ForceWebChallenge}, delegate: delegate)
```
This creates instance of `ApplePayButton` pointing to its parent viewController. Auth3dSupported tells if the proccess will go through additional 3d authentication which in most case is unnecessary. You should also pass an object confirming to the `ApplePayDelegate` protocol. The `ApplePayDelegate` protocol defines one method `onSubmitResponse(response:)` that is called when the payment proccess finish either successfully or with an error and will give you the result.

### Fields

```swift
let customization = NuveiFieldCustomization()
let i18n = FieldsI18n()
NuveiFields.setup(environment: {NuveiSimplyConnect.Environment},customization: customization, i18n: i18n,transactionDetails: transactionDetails)
```

```swift
// Configure the NuveiFieldCustomization appearance:
with(NuveiFieldCustomization) {
    // Text input boxes: labels/headings, placeholders, values, and their borders
	with(textBoxCustomization){ 
        headingTextFont         	= UIFont.boldSystemFont(ofSize: 14)   // font of labels/headings above the input fields
        headingTextColor        	= .black                        	  // color of labels/headings above the input fields
		backgroundColor             = .white                        	  // background color of each text field
        textFont                	= UIFont.boldSystemFont(ofSize: 14)   // font of the actual input text
		textColor                   = .black                        	  // color of the actual input text
        placeholderTextColor        = .black                              // color of hint/placeholder text inside fields
        borderColor                 = .black        					  // border color of each text field
        cornerRadius                = 0                                   // corner radius of each text field
        borderWidth                 = 1                                   // border width of each text field
    }
    
    // Error messages under the inputs
	with(errorLabelCustomization){
        textFont                	= UIFont.boldSystemFont(ofSize: 12)   // error text font
        textColor                   = .red                    		 	  // error text color
    }
	backgroundColor 				= .white   							  // Background for the entire NuveiCreditCardField container
    borderColor     				= .black     						  // Border color around the entire NuveiCreditCardField container
    cornerRadius    				= 0                        			  // Corner radius for the outer container border
    borderWidth     				= 1                        			  // Width of the outer container border
}

```

```swift
with(FieldsI18N) {
    cardHolderNameTitle         = "Cardholder Name"
    cardHolderNamePlaceholder   = "John Smith"
    cardNumberTitle             = "Card Number"
    cardNumberPlaceholder       = "1234-5678-1234-5678"
    expirationDateTitle         = "Expiry Date"
    expirationDatePlaceholder   = "12/23"
    cvvTitle                    = "CVV"
    cvvPlaceholder              = "123"

	errors						= [numberEmpty 		 = "Please fill the credit card number"
								   creditCardInvalid = "Please enter a valid card number"
								   expiryEmpty       = "Please fill the expiry date"
								   expiryInvalid     = "Invalid expiration date"
								   cvvEmpty          = "Please fill the CVV"
								   cvvInvalid        = "CVV is invalid"
								   holderNameEmpty   = "Please fill the card holder name"
								   holderNameInvalid = "Invalid cardholder name"]
}
```

This creates instance of `NuveiFieldCustomization` with your own customization preferences.

This creates instance of `FieldsI18n` with your own localized texts. You can initialize it with the properties and text you want to modify.

You should also pass a `CheckoutTransactionDetails` object which you can create from `NVInput` object. If you want to use only `NuveiFields.createPayment` you can skip the transaction details.

---

```swift
do {
    creditCardField = try NuveiFields.createCreditCardField()
    creditCardField?.onInputUpdated = {}
    creditCardField?.onInputValidated = {}
	creditCardField?.onCardDetailsUpdated = {
		creditCardField?.showCardNumberError(message: {ERROR_MESSAGE})
	}
} catch {
    // handle error
}
```
This creates instance of `NuveiCreditCardField`.

OnInputUpdated is callback that tells you when a field text is modified and when it loses focus. It also gives you expiration month and year if they are filled.

OnInputValidated is callback that gives you list of error if there is any after validation of a field.

OnCardDetailsUpdated is callback that gives you detailed information about the card after the card number is valid. Then based on your requirements you can call `creditCardField.showCardNumberError(message:)` and your error message will be shown under the card number field.

---

```swift
creditCardField?.validate { result, error in
	// do something
}
creditCardField?.tokenize() { result, error in
	// do something
}
creditCardField?.createPayment(viewController: {ViewController}) { output in
	// do something
} declineFallbackDecision: { [weak self] output, viewController, completion in
	// do something
}
```
Validate method will validate the card filled in the fields. The closure tells you whether the validation was successful or there was some error.

Tokenize method will create token with which you can create payment. In the closure you can get the token or handle an error if there is so.

CreditCardField.createPayment method will create payment with the card that the user have filled in. The callback tells you when the proccess is finished either successfully or with an error. DeclineFallbackDecision tells you when there is an error.

---

```swift
let paymentOption = try? NVPaymentOption(card: NVCardDetails(ccTempToken: {TOKEN}, cardHolderName: {NAME}))
NuveiFields.createPayment(uiOwner: {ViewController}, input: {Input}) { output in
	// do something
}
```

NuveiFields.createPayment will create payment with a token. For this method you don't need the fields. You have to pass an object of type `NVInput` in which you have to put the token and optionally the card holder name. The closure tells wheter the payment was successful or there was some error.

### SimplyConnect 
```swift
let customization = NuveiUICustomization(logo: {Your logo},toolbarCustomization: {NuveiToolbarCustomization},textBoxCustomization: {NuveiTextBoxCustomization},errorLabelCustomization: {NuveiLabelCustomization},tableViewCustomization: {NuveiTableViewCustomization})
customization.setButtonCustomization({NuveiButtonCustomization}, for: .pay)
customization.setButtonCustomization({NuveiButtonCustomization}, for: .checkbox)
customization.setButtonCustomization({NuveiButtonCustomization}, for: .close)
NuveiSimplyConnect.setup(environment: {NuveiSimplyConnect.Environment}, customization: customization)
```
This creates instance of `NuveiUICustomization` with your own customization preferences.

With NuveiSimplyConnect.setup(environment:customization:) you setup the enviroment and the customization. You can pass empty customization NuveiUICustomization(). The customization also can be set later but before NuveiSimplyConnect.checkout(...).

```swift
with(NuveiUICustomization) {
    // Styles the top app bar of the Checkout screen:
    logo							= NuveiUICustomization.defaultCheckoutToolbarLogo  // logo shown in the toolbar
    with(toolbarCustomization){ 
		headerText                  = "Checkout"                        // title text (e.g. "Checkout")
		textFont                	= UIFont.boldSystemFont(ofSize: 22) // toolbar title font.
        textColor                   = .white              				// toolbar title color
        backgroundColor             = .nuveiDefaultColor                // toolbar background
    }
    // Controls all text fields in the checkout form:
    with(textBoxCustomization){ 
        headingTextFont         	= UIFont.boldSystemFont(ofSize: 14)   // font for section titles above a text input field.
        headingTextColor        	= .black                        	  // color for section titles above a text input field.
		backgroundColor             = .white                        	  // background of the input area.
        textFont                	= UIFont.boldSystemFont(ofSize: 14)   // font for input text
		textColor                   = .black                        	  // actual input text color
        placeholderTextColor        = .black                              // color for hint/placeholder style inside fields.
        borderColor                 = .black        					  // outline color of the text fields
        cornerRadius                = 0                                   // radius for rounded text field corners
        borderWidth                 = 1                                   // border thickness
    }
    // Styles error messages shown under fields:
    with(errorLabelCustomization){
        textFont                	= UIFont.boldSystemFont(ofSize: 12)  // error text font
        textColor                   = .red                    		 	 // error text color
    }
	// Customization of the SimplyConnect screen
    with(tableViewCustomization) {
		sectionTitleFont    = UIFont.boldSystemFont(ofSize: 13)  // Section header title font (e.g. "My payment methods")
		sectionTitleColor   = .secondaryLabel                    // Section header title color
        backgroundColor     = .systemGray                        // Background color for the whole checkout list (TableView)
		cellBackgroundColor = .white                             // Background color for each cell/row in the list
		textFont    		= UIFont.systemFont(ofSize: 14)      // Text font for the main text inside each cell (card, APM, etc.)
		textColor       	= .black     						 // Text color for the main text inside each cell 
    }
    // Styles for the main payment button:
    with(payButtonCustomization){
        textFont                	= UIFont.systemFont(ofSize: 17) // button label font
        textColor                   = .white                   		// button text color
        backgroundColor             = .sdkColor("Checkout/Purple")  // button background
        cornerRadius                = 0                             // rounded corners for the button
    }
    //Styles checkbox-like actions (e.g. “Save card”, “Remember my details”):
    with(checkboxButtonCustomization){ 
		textFont                	= UIFont.systemFont(ofSize: 17) // checkbox label font
        textColor                   = .white                   		// checkbox text color
        backgroundColor             = .sdkColor("Checkout/Purple")  // checkbox background
    }
	//Style for the close button:
    with(checkboxButtonCustomization){ 
        backgroundColor             = .sdkColor("Checkout/Purple")  // close button tint color
    }
}

```

---

```swift
NuveiSimplyConnect.authenticate3d(uiOwner: {ViewController}, input: {Input}, additionalParams: {AdditionalParams}, forceWebChallenge: {ForceWebChallenge}) { output in
	// do something
}
NuveiSimplyConnect.createPayment(uiOwner: {ViewController}, input: {Input}, additionalParams: {AdditionalParams}, forceWebChallenge: {ForceWebChallenge}) { output in
	// do something
}
```
Authenticate3d will authenticate a payment. For uiOwner you have to pass the presenting view controller. For input you must create instance of `NVInput` with the payment data.

CreatePayment will make a payment. For uiOwner you have to pass the presenting view controller. For input you must create instance of `NVInput` with the payment data.

---

```swift
let installment = Installment(options: {Options}, isNationalIdRequired: {IsNationalIdRequired}, countryCode: {CountryCode})
let i18n = CheckoutI18n()
do {
    try NuveiSimplyConnect.checkout(uiOwner: {ViewController}, authenticate3dInput: {Input}, additionalParams: {AdditionalParams}, installment: installment, 	i18n: i18n, forceWebChallenge: {ForceWebChallenge},
		callback: { output in
			// do something
		},
		declineFallbackDecision: { output, viewController, completion in
			// do something
		}
	)
} catch {
    // Handle error 
    print("Checkout failed with error: \(error)")
}
```

This creates instance of `Installment` with installment options. You can choose which options you will add. If the option is not `SINGLE_PAYMENT` you have to pass list of periods from which the user can choose. You can choose if the national id is required. It depends on the country code. Country codes that we support national id are AR, BR, CL, PE, CO, MX, PY, UY, IL. It is optional.

This creates an instance of CheckoutI18n with your localized texts. You can initialize it with the properties and text you want to modify.For alternative payment methods, use the `apmDictionary` parameter. It maps each payment-method identifier to a dictionary of field entries. Within this dictionary, each field key defines the label text, and the corresponding error message is specified by appending `_error` to the same field key. You can find the keys in the documentation. For example:

```swift
with(CheckoutI18N) {
    cardHolderNameTitle                 = "Cardholder Name"
    cardHolderNamePlaceholder           = "John Smith"
    cardNumberTitle                     = "Card Number"
    cardNumberPlaceholder               = "1234-5678-1234-5678"
    expirationDateTitle                 = "Expiry Date"
    expirationDatePlaceholder           = "12/23"
    cvvTitle                            = "CVV"
    cvvPlaceholder                      = "123"
    installmentsProgramTitle            = "Installments Program"
    singlePaymentText                   = "Single Payment"
    deferredWithInterestText            = "Deferred with interest"
    deferredWithoutInterestText         = "Deferred without interest"
    deferredWithoutInterestAndGraceText = "Deferred without interest and grace period"
    numberOfInstallmentsTitle           = "Number of Installments"
    personalIdTitle                     = "Personal ID"
    personalIdPlaceholder               = "Personal ID"
    saveDetailsText                     = "Save my details for future use"
    payButtonTitle                      = "Pay"
    
    apmDictionary						= ["paymentMethodKey": ["field_key": "text for the field", "field_key_error": "error text"]
    errors								= [numberEmpty 		 = "Please fill the credit card number"
										   creditCardInvalid = "Please enter a valid card number"
										   expiryEmpty       = "Please fill the expiry date"
										   expiryInvalid     = "Invalid expiration date"
										   cvvEmpty          = "Please fill the CVV"
										   cvvInvalid        = "CVV is invalid"
										   holderNameEmpty   = "Please fill the card holder name"
										   holderNameInvalid = "Invalid cardholder name"
										   nationalIDEmpty   = "Please fill the ID number"
										   nationalIDInvalid = "Invalid ID number"]
}
```

```swift
let i18n = CheckoutI18n(apmDictionary: [
							 "paymentMethodKey":
								 ["field_key": "text for the field",
								  "field_key_error": "error text"
								 ]
			])
```

Checkout will load a screen with saved cards and other payment options so the uiOwner must be the presenting view controller. For input you must create instance of `NVInput` with the payment data. If this input doesn't have amount or currency the method throws an error. The callback tells you when the proccess is finished either successfully or with an error. DeclineFallbackDecision tells you when there is an error.
