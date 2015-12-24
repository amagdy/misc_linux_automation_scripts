#!/usr/bin/python
import sys
import re
import subprocess
from xml.sax.saxutils import escape

usage = """Place this script on the root of a got repo and make it executable.
Put each code review comment preceded by %%%% in a separate line before or after the reviewed line of code.
Run the script:
    ./code_review_report.py [--html]

N.B.
    remember not to commit or push the code with the comments that you added.
"""

class bcolors:
    HEADER = ['\033[95m', 'color: #909; ']
    OKBLUE = ['\033[94m', 'color: #009; ']
    OKGREEN = ['\033[92m', 'color: #090; ']
    WARNING = ['\033[93m', 'color: #990; ']
    FAIL = ['\033[91m', 'color: #900; ']

def addStyles(line, color, bold=False, underline=False, isHTML=False):
    index = 1 if isHTML else 0
    color_text = ""
    bold_text = ""
    underline_text = ""
    if not (color is None): color_text = color[index]
    bold_arr = ['\033[1m', 'font-weight: bold; ']
    underline_arr = ['\033[4m', 'text-decoration:underline; ']
    if bold: bold_text = bold_arr[index]
    if underline: underline_text = underline_arr[index]
    if isHTML:
        return "</pre><span style=\"{0}{1}{2}\">{3}</span><pre>".format(color_text, bold_text, underline_text, line)
    else:
        return "{0}{1}{2}{3}\\033[0m".format(color_text, bold_text, underline_text, line)

def strReplace(line, pattern, replacement):
    return re.sub(pattern, replacement, line)


if __name__ == "__main__":
    isHTML = False
    if len(sys.argv) > 1:
        if sys.argv[1] == "--html":
            isHTML = True
    p = subprocess.Popen(['git', 'diff', '-U20'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    success = False
    if isHTML: print "<html><body><pre>"
    for line in p.stdout:
        success = True
        if isHTML: line = escape(line)
        line = strReplace(line, r'\+[\s]*%{4,}[\s]*(.*)', addStyles(r"\1", bcolors.OKGREEN, True, False, isHTML))
        line = strReplace(line, r'diff \-\-git a/.*', r"")
        line = strReplace(line, r"\\ No newline at end of file", r"")
        line = strReplace(line, r"\+\+\+ b\/(.*)", addStyles(r"- \1", bcolors.OKBLUE, False, True, isHTML))
        line = strReplace(line, r"index +[a-f0-9]+\.+[a-f0-9]+ +[a-f0-9]+", r"")
        line = strReplace(line, r"\-{3} *.*", r"")
        line = strReplace(line, r"@@ +[^@]+ +@@", r"")
        sys.stdout.write(line)
    if isHTML: print "</pre></body></html>"
    if not success:
        print addStyle(p.stderr.readline(), bcolors.FAIL)
        print usage


