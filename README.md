UTP Online Judge
================

Is a free software project oriented to improve the programming skills 
of the students through contest like acm-icpc, codeforces, and others. 

##### *This repository _IS OUT OF DATE_, the main repository is* [https://github.com/in-silico/utpjudge](https://github.com/in-silico/utpjudge)

- The current development is not in the master branch, is in "dev".

### To Clone.

		git clone git@github.com:sebasutp/utpjudge.git
		git checkout -b dev
		git pull origin dev

### To Use.

- go to judge directory and initialize the db.

		cd judge/
		rake db:migrate
		rake db:seed

this will create a account with email "root@utp.edu.co" and password "root@utp.edu.co"
- run the server

		rails server

- enjoy

_______
Developed by insilico.
