# Copyright © 2010 Kuznetcov R. Igor
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE
package EGE::Gen::EGE::Z13;
use base 'EGE::GenBase::DirectInput';

use strict;
use warnings;
use utf8;

use EGE::NumText;
use EGE::Random;

sub tumblers {
    my ($self) = @_;
    my $tumblers_count = rnd->in_range(2, 5);
    my $tumbler_state = rnd->in_range(4, 8);
    my $off_state_messege = 'При этом устрой­ство имеет спе­ци­аль­ную кноп­ку вклю­че­ния/вы­клю­че­ния';
    my $ans = $tumbler_state ** $tumblers_count;
    if (rnd->coin) {
        $off_state_messege = 'При этом край­нее ниж­нее од­но­вре­мен­ное по­ло­же­ние всех ручек со­от­вет­ству­ет от­клю­че­нию устрой­ства.';
        $ans -= 1;
    }
    $self->{text} =
        "Выбор ре­жи­ма ра­бо­ты в не­ко­то­ром устрой­стве осу­ществ­ля­ет­ся ус­та­нов­кой ручек $tumblers_count тум­бле­ров, ".
        "каж­дая из ко­то­рых может нахо­дить­ся в одном из $tumbler_state по­ло­же­ний. $off_state_messege ".
        'Сколь­ко раз­лич­ных ре­жи­мов ра­бо­ты может иметь уст­рой­ство? Вы­клю­чен­ное со­сто­я­ние ре­жи­мом ра­бо­ты не счи­тать.';
    $self->{correct} = $ans;
}

sub tumblers_min {
    my ($self) = @_;
    my $tumbler_state = rnd->pick(2, 3, 4, 5, 8);
    my $tumbler_count = rnd->in_range(3, 5);
    my $n = rnd->in_range($tumbler_state ** ($tumbler_count - 1) + 1, $tumbler_state ** $tumbler_count);
    $self->{text} =
        "Выбор ре­жи­ма ра­бо­ты в не­ко­то­ром устрой­стве осу­ществ­ля­ет­ся уста­нов­кой ручек тум­бле­ров, ".
        "каж­дая из ко­то­рых может на­хо­дить­ся в од­ном из $tumbler_state по­ло­же­ний. ".
        "Ка­ко­во ми­ни­маль­ное ко­ли­че­ство не­об­хо­ди­мых тум­бле­ров для обес­пе­че­ния ра­бо­ты устрой­ства на $n ре­жи­мах."; 
    $self->{correct} = $tumbler_count;
}

sub young_spy {
    my ($self) = @_;
    my $n = rnd->in_range(2, 8);
    my $time = rnd->in_range(2, 9);
    my $n_flags = rnd->in_range(2, 5);
    my ($time_text, $all_time_text) = map num_text($_, [ qw(минуту минуты минут) ]), $time, $n * $time;
    my $changes_text = num_text($n - 1, [ qw(перемену перемены перемен) ]);
    $self->{text} =
         "В детскую игрушку «Набор юного шпиона» входят два одинаковых комплекта из $n_flags флажков различных цветов. " .
         'Сколько различных тайных сообщений можно передать этими флажками, ' .
         "условившись менять выставленный флажок каждые $time_text и наблюдая за процессом $all_time_text? " .
         "Наблюдатель видит вынос первого флажка и $changes_text флажка. " .
         'При этом возможна смена флажка на флажок того же цвета.';
    $self->{correct} = $n_flags ** $n;
}

1;
