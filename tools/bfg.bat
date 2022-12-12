@ECHO OFF
IF "%~1"=="" GOTO :EOF
java -jar "%~dp0bfg.jar" %*
GOTO :EOF


https://rtyley.github.io/bfg-repo-cleaner/

BFG Repo-Cleaner
Removes large or troublesome blobs like git-filter-branch does, but faster. And written in Scala

an alternative to git-filter-branch
The BFG is a simpler, faster alternative to git-filter-branch for cleansing bad data out of your Git repository history:

Removing Crazy Big Files
Removing Passwords, Credentials & other Private data

In all these examples bfg is an alias for java -jar bfg.jar.


$ git clone --mirror git://example.com/some-big-repo.git
$ java -jar bfg.jar --strip-blobs-bigger-than 100M some-big-repo.git
$ cd some-big-repo.git
$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
$ git push


$ bfg --delete-files id_{dsa,rsa}  my-repo.git
$ bfg --strip-blobs-bigger-than 50M  my-repo.git
$ bfg --replace-text passwords.txt  my-repo.git
$ bfg --delete-folders .git --delete-files .git  --no-blob-protection  my-repo.git
$ bfg --strip-biggest-blobs 100 --no-blob-protection repo.git

