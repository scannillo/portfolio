# Samantha Cannillo's Portfolio

## _iOS Apps in Swift4_


1. **ChiMusiciansConnect: D.I.Chi App** 
<p align="center">
<img src="/images/orange_logo.png?raw=true" height="75px" width="75px" >
</p>

- Date: 3/14/2018
- What: iOS app to create and store musician profiles based in Chicago, IL
- Description: The D.I.CHI app is built for the DIY Musician based in Chicago, IL. This app provides a one-stop-shop for listening to and communicating with the ever-growing plethora of talented musicians in the windy city. With the ability to showcase a song from Soundcloud, to create a succinct musician profile,  and to chat in real time, musicians and fans alike are able to stay up to date on the endless stylings of Chicago’s most talented locals. 
- **Tools used**: Firebase, Firebase/Storage, Facebook SDK, CocoaPods, Alamofire, Custom Splashscreen, custom design/graphics, Auto-layout, SideMenu (Hamburger), UINavigationControllers, UITableViewControllers, UITabBarControllers, Network activity indication, Network connection indication, Network post/fetch procedures

- <img src="/images/simulator_front.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_table.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_profile.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_edit.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_message.png?raw=true" height="245px" width="138px" >


2. **Children's Book: Halloween Theme**

- Date: 4/11/2018
- What: iOS Interactive Children's Book app built to display on iPad landscape
- Description: Designed a Children's Book that tells the story of a yound Candy Corn. 
	- The app uses NSUserDefaults to store user preferences regarding auto-read functionality. It alloww pages to be read aloud to the user upon each page turn. If the setting is off, there is a button allowing users to enable read/speach functionality per page.
	- User Defaults is also used to load the app from the terminated state based on the page it was last terminated from. This is a common feature of longer children's books used in school settings.
	- App simulates a 'Parental Gate' requiring a specific shape to be drawn well. This permits access to specific view controller.
	- Various interactive elements are created in the book through UIDynamics, UIPropertyAnimators, and AVAudioPlayer. 
- **Tools used**: PageViewControllers, External .nib files, UIGestureRecognizers, AVSpeechSynthesizer, custom ErrorTypes, AVAudioPlayer, UIViewPropertyAnimator, NSUserDefaults, Objective-C and Swift integration
- <img src="/images/homeScreenBook.png?raw=true" height="192px" width="256px" > <img src="/images/pageBBook.png?raw=true" height="192px" width="256px" > <img src="/images/pageABook.png?raw=true" height="192px" width="256px" > <img src="/images/parentalGate.png?raw=true" height="192px" width="256px" >


3. **Fun And Games: Tic-Tac-Toe App**

- Date: 2/11/2018
- What: iOS Tic-Tac-Toe app built to display on iPhone 8
- Description: Designed a gesture-driven Tic-Tac-Toe game for 2 players. Application limited to iPhone 8 portrait mode.
- **Tools used**: UIGestureRecognizers, AudioToolbox, Storyboard and Programatic design


4. **Journal App** 

- Date: 5/20/2018
- What: Journal app that syncs photo entires & metadata across devices using CloudKit.
- Description: This app uses CloudKit to sync data between devices, but also persists data to a local JSON file to enhance performance and usability. The app utilizes photos as the foundation for all journal entries, but also logs metadata associated with each photo, such as date, location, and weather. In addition, Apple's Vision Framework is used to generate tags based on the image uploaded. The user can edit these automatically-generated tags if they so desire. The user is able to query their collection of photos through a text search or through a search from a map view based on image locations as pins on a map. The app also utilizes the Dark Sky Weather API to show a user weather data for the day the photo was taken.
- This app was built to fulfil specifics requirements for an assignment in graduate school.
- **Tools used**: CloudKit, UISearchBarController, Map View, Apple's Vision Framework (image recognition), Weather API Requests, CloudKit Subscriptions, Today Widget Extension

- <img src="/images/journal_table.png?raw=true" height="270px" width="133px" > <img src="/images/journal_map.png?raw=true" height="270px" width="133px" > <img src="/images/journal_edit.png?raw=true" height="270px" width="133px" > <img src="/images/journal_sync.png?raw=true" height="270px" width="133px" >


## _Database Design in MySQL_

1. **MySQL - Chicago Musicians Connect Database**

- Date: 3/14/2018
- What: A simple but complete web application powered by a relational database using MySQL and SQL.
- Description: Designed and developed a relational database to faciliate connections between musicians, bookers, and venues in Chicago, IL based on a variety of factors/attributes.
- **Tools used**:
    - Created an Entity Relationship Diagram (ERD) for relational modeling.
    - Examined the relational model and functional dependencies and their application to the methods for improving database design: normal forms and normalization.
    - Utilized subqueries (correlated and uncorrelated), aggregation, various types of joins including outer joins and syntax alternatives, functions and stored procedures.
    - Created a basic web site powered by the database using the php and a web server.
- Working website : https://mpcs53001.cs.uchicago.edu/~scannillo/
- See git directory for MySQL scripts used to create the database. See WebAppFiles for queries used in the website.
