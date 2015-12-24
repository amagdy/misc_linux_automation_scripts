#!/usr/bin/python
import sys
import os
import re

source_branch = sys.argv[1]
dest_branch = sys.argv[2]
source_dir = "src/"


def readUserInput(msg):
	print("{0} : ".format(msg)),
	return sys.stdin.readline().strip()

def isYes(resp):
	if (resp == "y"):	
		return True
	elif (resp == "n"):
		return False
	else:
		print "Invalid Response: {0}".format(resp)
		sys.exit(1)

def filterArrayByIndexes(arr, indexes):
	newArray = []
	for (i, index) in enumerate(indexes):
		newArray.append(arr[int(index)])
	return newArray

def cmd(command):
	print command
	return os.popen(command).read().strip()

def getCurrentBranch():
	return cmd("git branch | grep -E \"^ *\*\" | sed 's/^ *//g; s/ *$//g; s/\* *//g'")

def getCurrentUserEmail():
	return cmd("git config user.email")

def getTempDirname(branch):
	return "~/politico/tmp/" + re.search('[a-zA-Z]+/([A-Z]{2,3}-[0-9]+)', branch).group(1)

def getBranches():
	return cmd("git branch | sed 's/^ *//g; s/\* *//g; s/ *$//g'").split("\n")

def getRelevantCommits(source_branch, branch, user_email):
	return cmd("git log --stat --no-merges {0}...{1} | grep -B 1 -E \"^Author: .*{2}\" | grep -o -E \"commit [0-9a-fA-F]+\" | awk '{{print $2;}}'".format(source_branch, branch, user_email)).split("\n")

def getFilesFromCommits(commits, source_dir):
	files = []
	for (i, commit) in enumerate(commits):
		files.extend(cmd("git show \"{0}\" --name-only --no-notes | grep -o -E {1}\"[^ ]+\" | sort | uniq".format(commit, source_dir)).split("\n"))
	return files

def printArray(arr):
	for (i, item) in enumerate(arr):
		print "[{0}] {1}".format(i, item)

def copyFilesToDir(files, dir):
	for (i, file) in enumerate(files):
		dest = dir + "/" + cmd("dirname {0}".format(file))
		cmd("mkdir -p {0} ; cp {1} {0}".format(dest, file))

def copyFileBackToProject(dir):
	cmd("cp -rf {0}/* .".format(dir))

def stageFiles(files):
	for (i, file) in enumerate(files):
		cmd("git add {0}".format(file))

branches = getBranches()
printArray(branches)

index = readUserInput("Please select a branch by typing its index")
branch = branches[int(index)]
print branch
if (not branch or branch == source_branch or branch == dest_branch):
	print "Invalid branch: [{0}]".format(branch)
	sys.exit(1)

# get the current branch and stash any changes in it to return back to them at the end
current_branch = getCurrentBranch()
stash_apply = False
if (cmd("git stash") != "No local changes to save"):
	stash_apply = True


cmd("git checkout {0}".format(branch))
cmd("git pull origin {0}".format(branch))


files = getFilesFromCommits(getRelevantCommits(source_branch, branch, getCurrentUserEmail()), source_dir)
printArray(files)

resp = readUserInput("Are these the files that you have changed: [y|n]")
if (not isYes(resp)):
	indexes = readUserInput("Please write comma separated indexes of the files you wish to add").split(",")
	printArray(indexes)
	files = filterArrayByIndexes(files, indexes)

temp_dirname = getTempDirname(branch)
copyFilesToDir(files, temp_dirname)

# git remove branch
cmd("git checkout {0}".format(dest_branch))
cmd("git branch -d {0}".format(branch))
cmd("git push origin :{0}".format(branch))
cmd("git pull origin {0}".format(dest_branch))
cmd("git checkout -b {0}".format(branch))
copyFileBackToProject(temp_dirname)

stageFiles(files)
commit_msg = readUserInput("Please write the commit message")
cmd("git commit -m \"{0}\"".format(commit_msg))
cmd("git push origin {0}".format(branch))

# return to the original branch and unstash it if needed
cmd("git checkout {0}".format(current_branch))
if (stash_apply):
	cmd("git stash apply")

print "=========Success=========="