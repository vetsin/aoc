#use Grammar::Tracer;

class H {
    my %edges;

    method TOP($/) {
        say %edges;
    }

    method thing($/) {
        %edges{$/<from>}.push: $/<to>;
    }
}

grammar G {
    token TOP { <thing>+ }
    rule thing { <from> to <to> '=' <dist> }
    token dist { \d+ }
    token from { \w+ }
    token to { \w+ }
}.parse('.9'.IO.slurp, actions => H);