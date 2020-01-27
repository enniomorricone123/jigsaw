Last modified: 12/6/2019

#### A few Firebase terms to know:
Storage - In the context of Firebase, "Storage" is where you upload files. This is a tab you can see in the Firebase dashboard, and for our project, this is where you upload the resources, questions and answers/answer choices for each game
Database - This is where we store users and references to information in storage - also a tab in the Firebase dashboard. You shouldn't have to touch this manually, since it all gets handled in code
Authentication - This is another tab in the firebase dashboard, and another one that gets maintained in code. This is where a user's email and password gets saved when they first create an account, and this is where a user's credentials are checked against when someone attempts to login. Authentication and Database rely on each other, so don't alter one in the dashboard without knowing how to alter the other one accordingly.

#### The Firebase project can be accessed at:
https://console.firebase.google.com/u/0/project/jigsaw-25200/overview

#### Content Directory Structure
The structure of the file directory in our firebase project is similar to Finder on a Mac or file explorer in Windows - folders with sub-folder and files. At the top level, there's a folder called Topics. Topics currently contains only two sub-folders - US Immigration System I and US Immigration System II - but it should be able to hold an arbitrary number of topics. Each folder in Topics has three sub-folders - Resource, Questions, and Answers - and each of those sub-folders contain two sub-folders - Group1 and Group2. Finally, each of the group folders should have a single txt file in them, so the structure of the database should look something like this:
					              Topics
				                 /      \
		    US Immigration System I    US Immigration System II
		    /        |        \          /         |          \
	     Resource Questions Answers   Resource Questions   Answers
		/    \						                       /     \
	 Group1 Group2 		           ...			       Group1   Group2

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