# expresspay_sdk

![](https://jitpack.io/v/expresspay/expresspay-android-sdk.svg) | [View SDK Wiki](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki) | [Report new issue](https://github.com/ExpresspaySa/expresspay-flutter-sdk/issues/new)

# Expresspay Flutter SDK & [Sample](https://github.com/ExpresspaySa/expresspay-flutter-sdk-sample)

Expresspay is a white-label payment software provider. Thanks to our 15+ years of experience in the payment industry, we’ve developed a state-of-the-art white-label payment system that ensures smooth and uninterrupted payment flow for merchants across industries.

<p align="center">
  <a href="https://expresspay.sa">
      <img src="https://github.com/ExpresspaySa/expresspay-flutter-sdk/blob/main/media/header.png" alt="Expresspay" width="400px"/>
  </a>
</p>

Expresspay Flutter SDK was developed and designed with one purpose: to help the Flutter developers easily integrate the Expresspay API Payment Platform for a specific merchant.


To properly set up the SDK, read [Wiki](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki) first.

## Setup And Installation
This Flutter plugin is based on iOS and Android native libraries.
You need to add the `jitpack` repository support to the gradle to access the secured Android library. `Follow Below`

**Setup Android**

Add to the root build.gradle in Android Project at Path:(${ProjectRoot}/android/build.gradle):

```groovy
allprojects {
    repositories {
        ...
        jcenter()
        maven {
            url 'https://jitpack.io'
        }
    }
}
```

Add below rules to the project proguard configuration file located at path: ${ProjectRoot}/android/app/proguard-rules.pro)

```groovy
-keep class com.expresspay.sdk.model.**.**{ *; }
```

If the `${ProjectRoot}/android/app/proguard-rules.pro` file not existed and your project has **minify** enabled create the file and add the above rules in it.

**Setup iOS**

iOS does not required any setup just install flutter plugin where the `iOS framewework` is embedded within the plugin in iOS plaform directory.
If you need to enable `Apple Pay` in your app it can be enable by following the instructions at [Link](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki/Express-ApplePay-Payment)

## Intalling Flutter Plugin**
In the `dependencies:` section of your `pubspec.yaml`, add the following lines:

```pubspec.yaml
dependencies:
  intl: ^0.17.0
  expresspay_sdk: ^2.1.2
```

Run in to terminal on project path `flutter pub upgrade expresspay_sdk`


## Initialize SDK
```dart
ExpresspaySdk.instance.config(
    key: MERCHANT_CLIENT_KEY, // Your Secret Merchant Key
    password: MERCHANT_CLIENT_PASSWORD,  // Your Secret Merchant Password
    enableDebug: true
);
```
[More Detail](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki)


## Quick Payment Implementation
[**Card Payment for iOS/Android**](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki/Express-Quick-Card-Payment)
Start the card payment with one click, easy and short line of codes. It will help the developer to easily implement the payment using card in thier application. click the [link](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki/Express-Quick-Card-Payment) for easy steps to start payments.


[**Apple Pay Payment for iOS**](https://github.com/ExpresspaySa/expresspay-flutter-sdk/wiki/Express-ApplePay-Payment)
Start the Apple Pay payment with one click, easy and short line of codes. It will help the developer to easily implement the payment using ApplePay in thier application. the developer just need to configure and enable the Apple Pay in thier AppleDeveloper Account and call the simple function. click the [link](https://github.com/ExpresspaySa/expresspay-ios-sdk-framework/wiki/Express-ApplePay-Payment) for easy steps to start payments with ApplePay.


## Getting help

To report a specific issue or feature request, open a [new issue](https://github.com/ExpresspaySa/expresspay-flutter-sdk/issues/new).

Or write a direct letter to the [support@expresspay.sa](mailto:support@expresspay.sa).

## License

MIT License. See the [LICENSE](https://github.com/ExpresspaySa/expresspay-flutter-sdk/blob/master/LICENSE) file for more details.

## Contacts

![](/media/footer.png)

Website: https://expresspay.sa  
Phone: [+966 920033633](tel:+966920033633)  
Email: [support@expresspay.sa](mailto:support@expresspay.sa)  
Address: Expresspay, Olaya Street, Riyadh, Saudi Arabia

© 2022 - 2023 Expresspay. All rights reserved.


