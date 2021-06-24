# Nathan's Fan App

`https://github.com/nalarkin/nathan_fan_page.git`

url is `https://github.com/nalarkin/nathan_fan_page`

## How to run the App:

1. Have all requirements downloaded
2. copy dependencies in `pubspec.yaml` file.
3. In CLI, type`flutter pub get` to install required plugins that were listed in the new `pubspec.yaml file`
4. To run android, in CLI type `flutter run`
5. To run web version instead. In CLI type `flutter run -d chrome --web-hostname localhost --web-port 5000`

## Build ID: 

`com.nlarkin1.fanpage`

## Requirements:

* flutter 2.0+ is downloaded and installed
* files that were edited within `android/app/scr/main/res/  (necessary for splash screen)
* update contents in `android/app/src/AndroidManifest.xml`
* have all files in `/lib` downloaded
* Android SDK >= 21
* compatible on Android and Web (Chrome OS)



## Admin Account Credentials (for testing)

username: `abc@gmail.com`

password: `arstarst`



## Web app specific requirements:

* download and copy the contents within the `/web/` folder. The most important are the contents of the `index.html`file.

  

## Video Examples.

### [Splash Screen](https://youtu.be/0cjgtCA01m0)

### [Admin View + Message Creation + Google Sign In](https://youtu.be/JXGyWYnpMxc)

### [Register with Email + Sign Out](https://youtu.be/oW0Cyc04Glo)

### [BONUS FEATURE: Change Existing Users First and Last Name](https://youtu.be/2m-U1FX08Kk)

### [Web App Demonstration](https://youtu.be/gV0z4_HS40o)



## Areas of Improvement

The organization and design principles in this project need improvement. I wasn't able to address these design issues because of the insane time crunch. To improve the program I would probably implement a `Multiprovider` and/or `FutureBuilder`, and the value that would change from my custom user model to the `Firebase.instance.currentUser`. I would possibly implement a more solid MVC design model and create toJson and fromJson methods to serialize communication between Firebase and the custom Class objects that represent the users/messages. I would also change the floating action button test to be based off a `Query` of the current user and see if they have the `userRole: admin`. This would allow for multiple admins to exist, and allow users to change roles easily.

## Troubleshooting issues

* Clone the entire repository instead of copying certain files
* try `flutter clean` then `flutter pub get`
* install the plugins by doing `flutter get <addon>`, this was how I installed my addons. So it could have changed some config code somewhere in the project that I was unaware of.
* Web app issue, make sure you are using local host 5000 as this is the only client id authorized.

