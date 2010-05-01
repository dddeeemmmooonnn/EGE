use strict;
use warnings;
use utf8;

package EGE::Prog::Lang;

my %lang_cache;

sub lang {
    my ($name) = @_;
    $lang_cache{$name} ||= "EGE::Prog::Lang::$name"->new;
}

sub new {
    my ($class, %init) = @_;
    my $self = { %init };
    bless $self, $class;
    $self->make_priorities;
    $self;
}

sub op_fmt {
    my ($self, $op) = @_;
    my $fmt = $self->translate_op->{$op} || $op;
    $fmt = '%%' if $fmt eq '%';
    $fmt =~ /%\w/ ? $fmt : "%s $fmt %s";
}

sub name {
    ref($_[0]) =~ /::(\w+)$/;
    $1;
}

sub var_fmt { '%s' }

sub make_priorities {
    my ($self) = @_;
    my @raw = $self->prio_list;
    for my $prio (1 .. @raw) {
        $self->{prio}->{$_} = $prio for @{$raw[$prio - 1]};
    }
}

sub prio_list {
    [ '*', '/', '%', '//' ],
    [ '+', '-' ],
    [ '>', '<', '==', '!=', '>=', '<=' ]
}

package EGE::Prog::Lang::Basic;
use base 'EGE::Prog::Lang';

sub assign_fmt { '%s = %s' }
sub index_fmt { '%s(%s)' }
sub translate_op {{
    '%' => 'MOD', '//' => '\\', '==' => '=', '!=' => '<>'
}}

sub for_start_fmt { 'FOR %s = %s TO %s' }
sub for_end_fmt { "\nNEXT %1\$s" }

sub if_start_fmt { 'IF %s THEN' . ($_[1] ? "\n" : ' ') }
sub if_end_fmt { $_[1] ? "\nEND IF" : '' }

package EGE::Prog::Lang::C;
use base 'EGE::Prog::Lang';

sub assign_fmt { '%s = %s;' }
sub index_fmt { '%s[%s]' }
sub translate_op { { '//' => 'int(%s / %s)', } }

sub for_start_fmt { 'for (%s = %2$s; %1$s <= %3$s; ++%1$s)' . ($_[1] ? '{' : '') }
sub for_end_fmt { $_[1] ? "\n}" : '' }

sub if_start_fmt { 'if (%s)' . ($_[1] ? " {\n" : "\n") }
sub if_end_fmt { $_[1] ? "\n}" : '' }

package EGE::Prog::Lang::Pascal;
use base 'EGE::Prog::Lang';

sub assign_fmt { '%s := %s;' }
sub index_fmt { '%s[%s]' }
sub translate_op {{
    '%' => 'mod', '//' => 'div', '==' => '=', '!=' => '<>',
}}

sub for_start_fmt { 'for %s := %s to %s do' . ($_[1] ? ' begin' : '') }
sub for_end_fmt { $_[1] ? "\nend;" : '' }

sub if_start_fmt { 'if %s then' . ($_[1] ? " begin\n" : "\n") }
sub if_end_fmt { $_[1] ? "\nend;" : '' }

package EGE::Prog::Lang::Alg;
use base 'EGE::Prog::Lang';

sub assign_fmt { '%s := %s' }
sub index_fmt { '%s[%s]' }
sub translate_op { { '%' => 'mod(%s, %s)', '//' => 'div(%s, %s)', } }

sub for_start_fmt { 'нц для %s от %s до %s' }
sub for_end_fmt { "\nкц" }

sub if_start_fmt { "если %s то\n" }
sub if_end_fmt { "\nвсе" }

package EGE::Prog::Lang::Perl;
use base 'EGE::Prog::Lang';

sub var_fmt { '$%s' }
sub assign_fmt { '%s = %s;' }
sub index_fmt { '$%s[%s]' }
sub translate_op { { '//' => 'int(%s / %s)', } }

sub for_start_fmt { 'for (%s = %2$s; %1$s <= %3$s; ++%1$s) {' }
sub for_end_fmt { "\n}" }

sub if_start_fmt { "if (%s) {\n" }
sub if_end_fmt { "\n}" }

1;