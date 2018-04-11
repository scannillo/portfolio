# Samantha Cannillo's Portfolio

## _iOS Apps in Swift4_

1. **ChiMusiciansConnect: D.I.Chi App** 
<p align="center">
<img src="/images/orange_logo.png?raw=true" height="75px" width="75px" >
</p>

- Date: 3/14/2018
- What: iOS app to create and store musician profiles based in Chicago, IL
- Description: The first part of a potential long-term personal project. The goal of the project is to connect musicians, show bookers, and artists alike in the Chicago DIY Music scene. This phase of the app focused on the creation of and presentation of musician profiles (including a user profile image, sound description, bio, and in-app song via Soundcloud) in an iPhone compatible app.
- **Tools used**: Firebase, Firebase/Storage, CocoaPods, Alamofire, Custom Splashscreen, custom design/graphics, Auto-layout, UINavigationControllers, UITableViewControllers, UITabBarControllers, Network activity indication, Network connection indication, Network post/fetch procedures

- <img src="/images/simulator_front.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_table.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_profile.png?raw=true" height="245px" width="138px" > <img src="/images/simulator_edit.png?raw=true" height="245px" width="138px" >

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
