module editor.node;

import mell.geometry.rectangle;

enum NodeType {
    BEGIN,
    GOTO,
    END,
    VAR,
    SPEAKER,
    DIALOG,
    CHOICE,
}

class Node {
    int id;
}

class BeginNode : Node {

}

class GotoNode : Node {
    int target;
}

class EndNode : Node {

}

class VarNode : Node {
    string name;
    string value;
}

class SpeakerNode : Node {
    string name;
}

class DialogNode : Node {
    string text;
}

class ChoiceNode : Node {
    string text;
    string[] options;
    int[] targets;
}

