#!/usr/bin/python3
import re
import json
import markdown as md
from botpiler import Botpiler

CONV_DEF = re.compile(r'^\[([a-zA-Z0-9 ]+)\]$')
CONV_REF = re.compile(r'^#([a-zA-Z0-9 ]+)\/(\d+)$')
CONV_LINE = re.compile(r'^(b|u): (.+)$')

USERS = {'b' : "course-bot", 'u': "user"}

def main(CONVS: "a text file containing the conversations"):
    with open(CONVS,"r") as f:
        bp = Botpiler()
        for l in (ln[:-1] for ln in f.readlines() if ln!="\n"):
            if CONV_DEF.match(l):
                name = CONV_DEF.match(l).group(1)
                bp.conversation(name)
                #print("Conv segment: ",name)
            elif CONV_REF.match(l):
                m = CONV_REF.match(l)
                conv_name, interaction = m.group(1), int(m.group(2))
                bp.reset_to(conv_name, interaction)
                #print("Branching from %s at user interaction #%d" % (conv_name, interaction))
            elif CONV_LINE.match(l):
                m = CONV_LINE.match(l)
                by, text = m.group(1), m.group(2)
                if by is "b":
                    bp.say(md.markdown(text))
                elif by is "u":
                    bp.question(text)
                #print("%s> %s" % (USERS[by], html))
            else:
                print("error")
                break
        print(json.dumps(bp.convo()))

if __name__=="__main__":
    import plac; plac.call(main)
