package LogCounter;
use Data::Dumper;
use strict;
use warnings;

use List::MoreUtils qw/uniq/;
sub new {
	my ($class, $list_ref) = @_;
	my %args = (list => $list_ref);
	return bless \%args, __PACKAGE__;
}

sub group_by_user {
	my $self = shift;
	
	my %user_count;
	for (@{$self->{list}}){
		$user_count{$_->{user}}++ if($_->{type} eq 'Auth');
	}
	return \%user_count;
}

sub group_by_date {
	my $self = shift;

	my %date_count;
	for (@{$self->{list}}){
		$date_count{$_->{date}}++ if($_->{type} eq 'Auth');
	}
	return \%date_count;
}

sub group_by_realm {
	my $self = shift;

	my %realm_count;
	for (@{$self->{list}}){
		$realm_count{$_->{realm}}++ if($_->{type} eq 'Auth' and $_->{result} eq 'OK');
	}
	return \%realm_count;
}

sub group_by_result {
	my $self = shift;

	my %result_count;
	for (@{$self->{list}}){
		$result_count{$_->{result}}++;
	}
	return \%result_count;
}

sub group_by_date_result {
	my $self = shift;

	my %date_count;
	for (@{$self->{list}}){
		$date_count{$_->{date}}->{success}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Login OK');
		$date_count{$_->{date}}->{incorrect}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Login incorrect');
		$date_count{$_->{date}}->{invalid}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Invalid user');
	}
	return \%date_count;
}
sub group_by_minute{
	my $self = shift;

	my %minute_count;
	for (@{$self->{list}}){
		die "error" unless($_->{time} =~ /(\d{2}:\d{2}):\d{2}/);
		my $minute = $1;
		my $dateminute = "$minute, $_->{date}";
		$minute_count{$dateminute}++ if($_->{type} eq 'auth');
	}
	return \%minute_count;
}
sub group_by_minute_result{
	my $self = shift;

	my %minute_count;
	for (@{$self->{list}}){
		die "error" unless($_->{time} =~ /(\d{2}:\d{2}):\d{2}/);
		my $minute = $1;
		my $dateminute = "$minute, $_->{date}";

		$minute_count{$dateminute}->{success}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Login OK');
		$minute_count{$dateminute}->{incorrect}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Login incorrect');
		$minute_count{$dateminute}->{invalid}++ if($_->{type} eq 'Auth' and $_->{result} eq 'Invalid user');
	}
	return \%minute_count;
}

1;

