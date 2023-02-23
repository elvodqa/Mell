module mell.dialog;

class Dialog {
    Dialog* next;
    Dialog* prev;
    string speaker;
    string text;
    string[] choices;
}