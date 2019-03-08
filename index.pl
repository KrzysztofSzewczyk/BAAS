#!/usr/bin/perl

# Brainfuck as a service.
# Copyright (C) by Kamila Palaiologos Szewczyk.
# Licensed under terms of MIT license. All rights reserved.

use strict;
use warnings;

use CGI;

my $request = CGI->new();
print $request->header;

my $html = <<'END';
<!DOCTYPE html>
<html>
<body>

<h2>Online brainfuck interpreter.</h2>

<form method="POST" action="/bfaas/brainfuck.pl">
  <input type="text" name="code" value="+>+[#">
  <br>
  <input type="submit" value="Submit">
</form> 

<p>After clicking submit, brainfuck code will be executed on server.</p>
<p>Limits: 256 cells of memory, 99 999 brainfuck instructions total.</p>

</body>
</html>
END

print $html
