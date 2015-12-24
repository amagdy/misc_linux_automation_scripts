#!/usr/bin/python
import sys
import re
import subprocess

usage = """Place this script on the root of a got repo and make it executable.
Put each code review comment preceded by %%%% in a separate line before or after the reviewed line of code.
Run the script:
    ./code_review_report.py

N.B.
    remember not to commit or push the code with the comments that you added.
"""

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def strReplace(line, pattern, replacement):
    return re.sub(pattern, replacement, line)


if __name__ == "__main__":
    p = subprocess.Popen(['git', 'diff', '-U20', '--color=always'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    success = False
    for line in p.stdout:
        success = True
        line = strReplace(line, r'%%%%', r" ")
        line = strReplace(line, r'diff \-\-git a/.*', r"")
        line = strReplace(line, r"\\ No newline at end of file", r"")
        line = strReplace(line, r"\+\+\+ b\/(.*)", r"- \1\n=============================================================")
        line = strReplace(line, r"index +[a-f0-9]+\.+[a-f0-9]+ +[a-f0-9]+", r"")
        line = strReplace(line, r"\-{3} *.*", r"")
        line = strReplace(line, r"@@ +[^@]+ +@@", r"")
        sys.stdout.write(line)

    if not success:
        print bcolors.FAIL + p.stderr.readline() + bcolors.ENDC
        print usage

