# README
Last modified: 12/6/2019

## Content Upload
#### A few Firebase terms to know:
Storage - In the context of Firebase, "Storage" is where you upload files. This is a tab you can see in the Firebase dashboard, and for our project, this is where you upload the resources, questions and answers/answer choices for each game
Database - This is where we store users and references to information in storage - also a tab in the Firebase dashboard. You shouldn't have to touch this manually, since it all gets handled in code
Authentication - This is another tab in the firebase dashboard, and another one that gets maintained in code. This is where a user's email and password gets saved when they first create an account, and this is where a user's credentials are checked against when someone attempts to login. Authentication and Database rely on each other, so don't alter one in the dashboard without knowing how to alter the other one accordingly.

#### The Firebase project can be accessed at:
https://console.firebase.google.com/u/0/project/jigsaw-25200/overview

#### Content Directory Structure
The structure of the file directory in our firebase project is similar to Finder on a Mac or file explorer in Windows - folders with sub-folder and files. At the top level, there's a folder called Topics. Topics currently contains only two sub-folders - US Immigration System I and US Immigration System II - but it should be able to hold an arbitrary number of topics. Each folder in Topics has three sub-folders - Resource, Questions, and Answers - and each of those sub-folders contain two sub-folders - Group1 and Group2. Finally, each of the group folders should have a single txt file in them

Our code will work as long as the structure of the Storage stays the same, with the only variable being the number of folders in Topics. This document serves as instructions for maintaining the structure of Storage as you upload content, so our current code can function. As the app gets updates from other developers, this document should be updated accordingly.

As mentioned, each "topic" will have 1 resource, a set of questions, and a corresponding set of answers. It's important that the number of questions matches the number of sets of answer choices, and that the 1st set of answer choices corresponds the to the first question, and so on.

### General upload instructions:
To add new content, go to storage and click the big blue button that says "upload file" while you're in the appropriate folder. For example, if you just created a "Gun Control I" folder and its corresponding resource, questions, answers and group folders, navigate to Topics/Gun Control I/resource/group1 and click the upload file button to upload the reading for group1 for this topic. As of this writing, we can only support text resource - although images shouldn't be too difficult for whoever picks this up
To add a new folder (again this should only be done to add new topics) click the gray button with a folder and "+" icon, which is next to the "upload file" button.


#### Answers:
Put all the answer choices for a given quiz in one txt file. The answer choices for a given question should be separated by only a comma, and the sets of answer choices for each question should be separated by a newline (note that typing a long sentence that wraps to the next line doesn't count as a new line, only hitting enter counts as a new line). The last bit of text in a line should indicate which answer choice is correct. An example txt would look something like this, if "Answer A" is correct for the first question, and "3" is correct for the second answer choice:

Answer A,Answer B,Answer C,Answer D,0
1,2,3,4,2

Note that it's much easier in code if the counting begins at 0, thus 0 refers to the first answer choice, and 3 would refer to the fourth element. Because this format is relatively intuitive, we sacrifice a little bit of flexibility: the answer choices themselves can't contain a comma, or else the code will interpret whatever comes after it as a new answer.


#### Questions:
In a similar but less restrictive vein, all the questions for a given topic should be in one txt file, with each question separated by a newline. The comma restriction does not apply here


#### Resource:
No character or formatting restrictions, but as mentioned previously, the resource can only be text, at the time of this writing - no images or video


## Next steps
There are a few limitations that should be addressed before it is production ready, some of which are stretch goals we couldn't achieve, and some we only realized would be good features near the tail-end of this process. There's a mix of technical and non-technical information in here, so this document is a good starting point for everyone involved in the next steps of this project:

#### Support for more games
At first we tried randomizing which game topics are picked for the users to play, but keeping this randomization consistent across four users proved to be non-trivial, so we stopped at simply retrieving the first two topics in our Storage, which are currently US Immigration System I and II. To achieve the variety that would make this game popular, the app would need to be able to 1) randomize which topics are chosen for the users in a match, and optionally 2) support matches that have a variable amount of topics i.e. not just two topics every time

#### More diverse content
The ability to have images as resources (and possibly) videos did not seem like too much of a challenge, and this would be a great way to diversify what kind of content the user sees

#### More selective matchmaking
By this I mean group users into a match by 1) What topics they haven't played yet and 2) some demographic basis, so people of different backgrounds are playing together. This feature obviously depends on our Storage being able to support more than 2 topics

#### Handle rogue players
The onDisconnect() function allows you to take action when someone gets disconnected, whether during a game or otherwise. Depending on where the disconnect occurs, the app may need to
- Store some data in firebase
- Log out the user who quit
- End the game for the other users in the middle of the game
- Delete the account of the user, if they were logged in as a guest

#### Game History
We made some big steps with this, but unfortunately some of our code got lost. As of this writing we're still working on recovering it, but having a TableView where someone can see the games they've done (a game meaning a single group of Resource-Questions-Answers), their score on the game, and possibly the people they played it with and/or the chat transcript

#### Consent to store anonymized demographic info and chat history
Simple but necessary - make sure people know what data we're storing and what exactly we intend on doing with it

#### Profile picture
There's readily available tutorials on how to add pictures from Camera Roll and then upload them to Firebase

#### Cleaner unwinds/dismissal of VCs
A concept we didn't grasp too well is what happens to a view controller (AKA a page) after we move on from it; thanks to some phantom print statements, we saw that could from previous pages was still running even after we left it. Even though it seems like this code doesn't seem to affect the app, for good measure we should look into stopping that code. Technical details: we use a navigation controller when authenticated, but not when playing as a guest. When authenticated it's as simple as unwinding back, either from results to resource, results to home, or home to welcome (I think). However, guests don't go through a navigation controller, therefore we need to figure out some nested dismiss() calls to get rid of the VCs that are no longer needed

#### More restrictive timing for each page
We want to ensure users are relatively on the same page, so we don't want someone skipping many pages ahead and then waiting

#### Security Rules
Right now, reads and writes are public, meaning there is no restriction on who can view data or change it - before this app is fully released, the proper authentication/restriction measures should be taken

#### Username authentication
Surprisingly more difficult than it seems, but being able to log in with a unique username rather than an email would be a nice touch