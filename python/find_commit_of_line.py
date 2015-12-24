#!/usr/bin/python
import sys
import os
usage = """
This script finds the commit(s) where one or more lines were added in a certain file.

./find_commit_of_line.py "file path relative to the root of the repo" "line(s) of code"

sample output:
829a1163ecc37ed8a2b7fb3d8fdb4488224c6b34
"""

def cmd(command):
	#print command
	return os.popen(command).read().strip()

def isStringInText(string, text):
	return (text.find(string) > -1)



if __name__ == "__main__":
	if len(sys.argv) < 3:
		print usage
		sys.exit(1)
	file = sys.argv[1]
	line = sys.argv[2]
	commits = cmd("git log {0} | grep -E \"^commit [a-f0-9]+$\" | sed 's/commit //g'".format(file)).split("\n")
	for (i, commit) in enumerate(commits):
		text = cmd("git show {0} {1} | grep -E \"^\+[^\+]\" | sed 's/^\+//g'".format(commit, file))
		if isStringInText(line, text):
			print commit
