#!/usr/bin/perl

package TestOP;

use strict;
use warnings;

sub init {
    my ($class, $members) = @_;

    my $self = bless { x => $members->{x},
                       y => $members->{y},
                       z => $members->{z}
                     }, $class;                  
}

sub getX {
    my ($self) = @_;
    return $self->{x};
}

sub getY {
    my ($self) = @_;
    return $self->{y};
}

sub getZ {
    my ($self) = @_;
    return $self->{z};
}

sub setX {
    my ($self, $x) = @_;
    $self->{x} = $x;
}

sub setY {
    my ($self, $y) = @_;
    $self->{y} = $y;
}

sub setZ {
    my ($self, $z) = @_;
    $self->{z} = $z;
}

sub mult {
    my ($self, $object) = @_;
    my $newObject = $self;
    $newObject->{x} = $self->{x} * $object->{x};
    $newObject->{y} = $self->{y} * $object->{y};
    $newObject->{z} = $self->{z} * $object->{z};

    return $newObject;
}

1;