package RadiusParser;
use strict;
use warnings;


sub new {
	my ($class, %args) = @_;
	return bless \%args, __PACKAGE__;
}

sub parse {
	my ($self, $filename) = @_;
	
	unless($filename){
		$filename = $self->{filename};
	}
	my @out;
	open my $fh, '<', $filename or die $!;
	my @lines = <$fh>;
	for my $line (@lines) {
		push @out, $self->parse_line($line) if keys %{$self->parse_line($line)};
	}
	close $fh;
	return \@out;
}

sub parse_line {
	my ($self, $line) =@_;
	my %months = ("Jan"=>'01', "Feb"=>'02', "Mar"=>'03', "Apr"=>'04', "May"=>'05', "Jun"=>'06', 
		"Jul"=>'07', "Aug"=>'08', "Sep"=>'09', "Oct"=>'10', "Nov"=>'11', "Dec"=>'12');

	chomp $line;

	my $pattern_re = qr/
	^
	([A-Z][a-z]{2})
	\s+
	([A-Z][a-z]{2})
	\s+
	(\d{1,2})
	\s+
	(\d{2}:\d{2}:\d{2})
	\s+
	(\d{4})
	\s+
	:
	\s+
	(Auth):
	\s+.*
	Login\s(OK|incorrect.*):
	\s+
	\[([\d\w\-_]+\@[\d\w\-_]+[\.\d\w\-_]+).+\]
	/x;

	my $pattern_error = qr/
	^
	([A-Z][a-z]{2})
	\s+
	([A-Z][a-z]{2})
	\s+
	(\d{1,2})
	\s+
	(\d{2}:\d{2}:\d{2})
	\s+
	(\d{4})
	\s+
	:
	\s+
	(Error|Info):
	\s+
	(.+)
	/x;



	my %kv;
	if($line =~ /$pattern_re/){
		$kv{day} = $1;
		#	$kv{month} = $2;
		if(length($3) == 1){
			$kv{date} = "$5/$months{$2}/0$3,$1";
		} else {
			$kv{date} = "$5/$months{$2}/$3,$1";
		}
		$kv{time} = $4;
		$kv{type} = $6;
		$kv{result} = $7;
		$kv{user} = $8;
		($kv{user_norealm}, $kv{realm}) = split (/\@/,$kv{user});

	} elsif ($line =~ /$pattern_error/){
		$kv{day} = $1;
		#	$kv{month} = $2;
		if(length($3) == 1){
			$kv{date} = "$5/$months{$2}/0$3,$1";
		} else {
			$kv{date} = "$5/$months{$2}/$3,$1";
		}
		$kv{time} = $4;
		$kv{type} = $6;
		$kv{msg} = $7;

	}
	return \%kv;
}

1;

