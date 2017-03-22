# ICGT QR Scanning Checkin App
### iOS App to aid Attendee Checkin at ICGT Events

This is an app interface to checkin attendees and guests at India Club at Georgia Tech affiliated events.

### About
Used by ICGT Checkin members, this app will allows them to see the stats of the event, such as how many people are coming, how many people are checked in, and individual stats relating to the member.

### Pods and Framewords
* `CoreData`
* `AVFoundation`
* `AVCapture`
* `Pulley`
* `Pager`
* `Alamofire`
* `SwiftyJSON`

### Purpose
- Checkin will be more efficient
- ICGT Board Members will have access to event and personal statistics
- System will be easily transportable, without the need of computers and laptops

### Details About Features
- This app uses Core Data to create sessions in which the member's name will be remembered and won't be asked every time. However the pass key will always be asked just as a precautionary measure.
- AVFoundation and AVCapture are used to recognize and scan QR codes
- AudioToolbox.AudioServices is used to vibrate the phone when a code is recognized
- Pulley allows the iOS Pull Up View Controller effect used in the iOS Maps App
- Pager allows for a ScrollView 3 Page Effect used in Snapchat
- Alamofire and SwiftyJSON are used for get/post requests and for parsing through returned data

### Other Details
- App also uses NSNotications to communicate with other view controllers
- Backed and Database systems are built in Python on the ICGT Server
- App connects to the ICGT Server to relay information and checkin
