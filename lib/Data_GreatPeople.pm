
use strict;

use Action;
use Entity;
use Event;

Action->new ('began');
Action->new({name=>'born', qualifier=>'was'});
Action->new({name=>'formed', qualifier=>'was'});

=pod
Event->new( { name=>'Abraham', action=>'born', time=>'2155 BC' });
Event->new( { name=>'Buddha', action=>'born', time=>'623 BC'});
Event->new( { name=>'Socrates', action=>'born', time=>'470 BC'}); # 06/4/470 BC
Event->new( { name=>'Plato', action=>'born', time=>'427 BC'}); # 05/21/427 BC
Event->new( { name=>'Aristotle', action=>'born', time=>'384 BC'});
Event->new( { name=>'Euclid', action=>'born', time=>'365 BC'});
Event->new( { name=>'Julius Cesar', action=>'born', time=>'100 BC'}); #time=>'07/12/100 BC' });
Event->new( { name=>'Jesus Christ', action=>'born', time=>'01/01/0000' });
Event->new( { name=>'Genghis Khan', action=>'born', time=>'1162 ad' });
Event->new( { name=>'Marco Polo', action=>'born', time=>'1254 ad' });
=cut

Event->new( { name=>'Michelangelo Buonarroti', action=>'born', time=>'03/06/1475' });
Event->new( { name=>'Nicolaus Copenicus', action=>'born', time=>'02/19/1473' });
Event->new( { name=>'William Shakeseare', action=>'born', time=>'1564 AD' });
Event->new( { name=>'Galeleo Galilei', action=>'born', time=>'02/15/1564' });
Event->new( { name=>'Johannes Kepler', action=>'born', time=>'12/27/1571' });
Event->new( { name=>'Sir Isaac Newton', action=>'born', time=>'12/25/1642' });
Event->new( { name=>'Ludwig van Beethoven', action=>'born', time=>'12/17/1770' });
Event->new( { name=>'Charles Darwin', action=>'born', time=>'1809 AD' });
Event->new( { name=>'Abraham Lincoln', action=>'born', time=>'02/12/1809' });
Event->new( { name=>'Mahatma Gandhi', action=>'born', time=>'1869 AD' });
Event->new( { name=>'Albert Einstein', action=>'born', time=>'03/14/1879' });
Event->new( { name=>'Elizabeth Link', action=>'born', time=>'02/18/2005' });

