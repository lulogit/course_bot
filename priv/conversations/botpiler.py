import uuid

class Botpiler:

    def __init__(self):
        self._convo = {}
        self._conversations = {}
        self._curr_conv = None
        self._curr_arc = self.arc("ice")

    def conversation(self, name):
        self._conversations[name] = [self._curr_arc]
        self._curr_conv = name

    def reset_to(self, conv, interaction):
        self._conversations[self._curr_conv] = [self._conversations[conv][interaction]]
        self._curr_arc = self._conversations[conv][interaction]

    def arc(self, name=None):
        uid = name or str(uuid.uuid4())
        self._convo[uid] = {
                "says":[],
                "reply":[]
                }
        if self._curr_conv:
            self._conversations[self._curr_conv].append(uid)
        return uid

    def say(self, html):
        self._convo[self._curr_arc]["says"].append(html)

    def question(self, label):
        new_arc = self.arc()
        self._convo[self._curr_arc]["reply"].append({"question":label, "answer":new_arc})
        self._curr_arc = new_arc

    def convo(self):
        return self._convo
