#!/usr/bin/perl

# Debian/ubuntu dependencies:
# libyaml-tiny-perl libjson-perl libxml-writer-perl libxml-writer-perl

eval 'exec /usr/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell

use strict;
use warnings;

use DateTime;
use YAML::Tiny;
use JSON;
use XML::Writer;
use IO::File;
use Data::Dumper;

my $src = 'tocalls.yaml';
my $out_dir = 'generated';

sub print_out($$)
{
	my($fn, $s) = @_;
	open(F, ">$fn") || die "Could not open $fn for writing: $!\n";
	print F $s;
	close(F) || die "Could not close $fn after writing: $!\n";
}

sub check_tocall($)
{
	my($tocall) = @_;

	die sprintf("'%s' is not a valid tocall", $tocall)
		if ($tocall !~ /^[A-Z0-9n\?\*]{3,6}$/);
}

sub check_entry($$$$$$$)
{
	my($name, $t, $optional, $mandatory, $classes, $longest, $features) = @_;
	
	foreach my $r (keys %{ $t }) {
		die sprintf("'%s' has unknown  key '%s'\n", $name, $r)
			if (!defined $optional->{$r});
		
		$longest->{$r} = 0 if (!defined $longest->{$r});
		$longest->{$r} = length($t->{$r}) if (length($t->{$r}) > $longest->{$r});
	}
	
	foreach my $r (keys %{ $mandatory }) {
		die sprintf("'%s' is missing key '%s'\n", $name, $r)
			if (!defined $t->{$r});
	}
	
	if (defined $t->{'class'} && !defined $classes->{ $t->{'class'} }) {
		die sprintf("'%s' has unknown class '%s'\n", $name, $t->{'class'});
	}
	if (defined $t->{'features'}) {
		foreach my $feature (@{ $t->{'features'} }) {
			die sprintf("'%s' has unknown feature '%s'\n", $name, $feature)
				if (!defined $features->{$feature});
		}
	}
}

# main

warn "Reading and parsing YAML from $src ...\n";
my $yaml = YAML::Tiny->new;
my $yaml_doc = YAML::Tiny->read($src);
if (!defined $yaml_doc) {
	die "Failed to read in $src: " . YAML::Tiny->errstr . "\n";
}
warn "  ... parsed successfully.\n";

# get the first document of YAML
my $c = $yaml_doc->[0];

# validate main sections
die "Class definitions not found!\n" if (!defined $c->{'classes'});
die "TOCALL definitions not found!\n" if (!defined $c->{'tocalls'});
die "Mic-E definitions not found!\n" if (!defined $c->{'mice'});
warn "  ... main sections found.\n";

# validate classes
my $count_class = 0;
my %class_keys = (
	'class' => 1,
	'shown' => 1,
	'description' => 1
);

my %classes;
foreach my $c (@{ $c->{'classes'} }) {
	$count_class++;
	foreach my $r (keys %class_keys) {
		die sprintf("Class '%s' is missing key '%s'\n", $c->{'class'}, $r)
			if (!defined $c->{$r});
	}
	foreach my $r (keys %{ $c }) {
		die sprintf("Class '%s' has unknown  key '%s'\n", $c->{'class'}, $r)
			if (!defined $class_keys{$r});
	}
	my $cid = $c->{'class'};
	delete $c->{'class'};
	$classes{$cid} = $c;
}
warn "  ... $count_class device classes found.\n";

my $count_tocall = 0;
my $count_mice = 0;
my $count_mice_legacy = 0;

# validate tocalls
my %tocall_keys = (
	'tocall' => 1,
	'vendor' => 1,
	'model' => 1,
	'class' => 1,
	'os' => 1,
	'features' => 1,
	'contact' => 1,
);
my %tocall_keys_mandatory = (
	'tocall' => 1
);
my %features = (
	'messaging' => 1,
	'item-in-msg' => 1,
);

my %tocalls;
my %longest_keys;
my $previous_tocall;
foreach my $t (@{ $c->{'tocalls'} }) {
	$count_tocall++;
	check_entry($t->{'tocall'}, $t, \%tocall_keys, \%tocall_keys_mandatory, \%classes, \%longest_keys, \%features);
	
	my $tocall = $t->{'tocall'};
	delete $t->{'tocall'};
	$tocalls{$tocall} = $t;
	check_tocall($tocall);
	if (defined $previous_tocall && $previous_tocall gt $tocall) {
		warn sprintf("Tocall '%s' is misordered after '%s'\n", $tocall, $previous_tocall);
	}
	$previous_tocall = $tocall;
}
warn "  ... $count_tocall tocalls found.\n";

# validate mic-e keys
my %mice_keys = (
	'suffix' => 1,
	'vendor' => 1,
	'model' => 1,
	'class' => 1,
	'os' => 1,
	'features' => 1,
	'contact' => 1,
);
my %mice_keys_mandatory = (
	'suffix' => 1
);

my %mice_keys_legacy = %mice_keys;
$mice_keys_legacy{'prefix'} = 1;
my %mice_keys_mandatory_legacy = (
	'prefix' => 1
);

my %mice;
foreach my $t (@{ $c->{'mice'} }) {
	$count_mice++;
	check_entry($t->{'suffix'}, $t, \%mice_keys, \%mice_keys_mandatory, \%classes, \%longest_keys, \%features);
	
	my $suffix = $t->{'suffix'};
	delete $t->{'suffix'};
	$mice{$suffix} = $t;
}
warn "  ... $count_mice Mic-E codes found.\n";

my %mice_leg;
foreach my $t (@{ $c->{'micelegacy'} }) {
	$count_mice_legacy++;
	my $key = $t->{'prefix'};
	$key .= $t->{'suffix'} if (defined $t->{'suffix'});
	check_entry($key, $t, \%mice_keys_legacy, \%mice_keys_mandatory_legacy, \%classes, \%longest_keys, \%features);
	
	$mice_leg{$key} = $t;
}
warn "  ... $count_mice_legacy legacy Mic-E codes found.\n";

#print Dumper($c);


warn "Converting ...\n";

my $dt_now = DateTime->now;
my $iso_timestamp = $dt_now->iso8601() . 'Z';

my $meta = {
	'generation_time' => $iso_timestamp,
};

$c->{'meta'} = $meta;
$yaml_doc->write("$out_dir/tocalls.dense.yaml");

my $json_tree = {
	'meta' => $meta,
	'classes' => \%classes,
	'tocalls' => \%tocalls,
	'mice' => \%mice,
	'micelegacy' => \%mice_leg
};

print_out("$out_dir/tocalls.dense.json", encode_json($json_tree));
print_out("$out_dir/tocalls.pretty.json", to_json($json_tree, { pretty => 1 } ));
warn "   ... JSON done.\n";

# XML
my $output = new IO::File(">$out_dir/tocalls.xml");
my $xw = new XML::Writer(OUTPUT => $output, ENCODING => "utf-8");
$xw->xmlDecl();
$xw->startTag("aprsdevices");

$xw->startTag("meta");
foreach my $c (sort keys %{ $meta }) {
	$xw->startTag($c);
	$xw->characters($meta->{$c});
	$xw->endTag($c);
}
$xw->endTag("meta");

$xw->startTag("classes");
foreach my $c (sort keys %classes) {
	$xw->startTag("class", "id" => $c);
	foreach my $k (sort keys %{ $classes{$c} }) {
		$xw->startTag($k);
		$xw->characters($classes{$c}{$k});
		$xw->endTag($k);
	}
	$xw->endTag("class");
}
$xw->endTag("classes");

$xw->startTag("tocalls");
foreach my $t (sort keys %tocalls) {
	$xw->startTag("tocall", "id" => $t);
	foreach my $k (sort keys %{ $tocalls{$t} }) {
		$xw->startTag($k);
		if ($k eq 'features') {
			foreach my $featid (sort @{ $tocalls{$t}{$k} }) {
				$xw->emptyTag("feature", "id" => $featid);
			}
		} else {
			$xw->characters($tocalls{$t}{$k});
		}
		$xw->endTag($k);
	}
	$xw->endTag("tocall");
}
$xw->endTag("tocalls");

$xw->startTag("mice");
foreach my $t (sort keys %mice) {
	$xw->startTag("suffix", "id" => $t);
	foreach my $k (sort keys %{ $mice{$t} }) {
		$xw->startTag($k);
		if ($k eq 'features') {
			foreach my $featid (sort @{ $mice{$t}{$k} }) {
				$xw->emptyTag("feature", "id" => $featid);
			}
		} else {
			$xw->characters($mice{$t}{$k});
		}
		$xw->endTag($k);
	}
	$xw->endTag("suffix");
}
$xw->endTag("mice");

$xw->startTag("micelegacy");
foreach my $t (sort keys %mice_leg) {
	$xw->startTag("key", "id" => $t);
	foreach my $k (sort keys %{ $mice_leg{$t} }) {
		$xw->startTag($k);
		if ($k eq 'features') {
			foreach my $featid (sort @{ $mice_leg{$t}{$k} }) {
				$xw->emptyTag("feature", "id" => $featid);
			}
		} else {
			$xw->characters($mice_leg{$t}{$k});
		}
		$xw->endTag($k);
	}
	$xw->endTag("key");
}
$xw->endTag("micelegacy");

$xw->endTag("aprsdevices");

$xw->end();

warn "   ... XML done.\n";

warn "Longest values:\n";
foreach my $k (sort keys %longest_keys) {
	warn sprintf("%15s %s\n", $k, $longest_keys{$k});
}

