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
