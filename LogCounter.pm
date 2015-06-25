package LogCounter;
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
		$user_count{$_->{user}}++;
	}
	return \%user_count;
}

sub group_by_date {
	my $self = shift;

	my %date_count;
	for (@{$self->{list}}){
		$date_count{$_->{date}}++;
	}
	return \%date_count;
}

sub group_by_realm {
	my $self = shift;

	my %realm_count;
	for (@{$self->{list}}){
		$realm_count{$_->{realm}}++ if($_->{result} eq 'OK');
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


1;

