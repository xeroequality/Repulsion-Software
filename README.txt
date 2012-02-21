Repulsion Software
February 19, 2012
Readme, Tips, and Tricks

* * * * * * * * * * * * * * * * * * * * * * * * * * * 
	README
* * * * * * * * * * * * * * * * * * * * * * * * * * * 

***********
Scaling content to screen height
***********

Because aspect ratios increase only in width, scaling UI assets based on the width of the screen is asking
for disaster. Your UI elements will seem like they're all over the place. As such, here is a template
equation for scaling any individual element by screen height:

                 absolute image height scaled for 480x320
                __________________________________________
                                    320
scale value = |_____________________________________________|  *  screen height
			
                          original image height



Practically applied, this looks like:

element:scale( ( ( scaled height / 320 ) / original height ) * display.contentHeight , ( ( scaled height / 320 ) / original height ) * display.contentHeight )


Say we have an image with a 600 pixels height. Scaled to 480x320, the image is brought down to 200 pixels 
in height. We set up our equation as:

foo:scale( ((200/320)/600)*display.contentHeight , ((200/320)/600)*display.contentHeight )




* * * * * * * * * * * * * * * * * * * * * * * * * * * 
	Tips
* * * * * * * * * * * * * * * * * * * * * * * * * * * 

A. To Pull the Repository:





B. To Add a File:
	1.) Add the file to the repository directory "Repulsiton-Software"
	2.) In Git-Bash, type "git add <filename>.<extension>" (Replace filename appropriatly)
	3.) In Git-Bash, type "git commit -a"
	4.) Uncomment (Remove the '#') in front of the git commands
	5.) Type, ':' 'w' 'q' '<Enter>'
	6.) In Git-Bash, type "git push'
	7.) It should respond with the changes and publish, check the website to verify

C. To Remove a File:
	1.) Simply delete the file from the Windows Explorer folder
	2.) In Git-Bash, type "git commit -a"
	3.) Uncomment (Remove the '#') in front of the git commands
	4.) Type, ':' 'w' 'q' '<Enter>'
	5.) In Git-Bash, type "git push'
	6.) It should respond with the changes and publish, check the website to verify



Adding a file for MAC Users:

// Editing the Commit_EditMSG
1.) In Git-Bash, "git add <filename>.<file extension>"
2.) In Git-Bash, "nano .git/COMMIT_EDITMSG"
3.) Remove the '#' symbol in front of the changes
4.) Type, "<CTRL> + X" To Exit
5.) Type, "Y" To Save
6.) In Git-Bash, "git push"


// Without editing the commit_editmsg File:
1.) In Git-Bash, "git add <filename>.<file extension>"
2.) In Git-Bash, "git push"



