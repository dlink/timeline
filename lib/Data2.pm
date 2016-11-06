
use strict;

use Action;
use Entity;
use Event;

Action->new ('began');
Action->new({name=>'born', qualifier=>'was'});
Action->new({name=>'formed', qualifier=>'was'});

Entity->new({name=>'Life', category=>'life form'});
Entity->new({name=>'human', category=>'mammal'});
Entity->new({name=>'mammal', category=>'vertebrae'});
Entity->new({name=>'vertebrae', category=>'animal'});
Entity->new({name=>'animal', category=>'life form'});

Entity->new({name=>'Papa', category=>'human'});
Entity->new({name=>'Mama', category=>'human'});
Entity->new({name=>'Sebastian', category=>'human'});
Entity->new({name=>'Cassandra', category=>'human'});
Entity->new({name=>'Granpa', category=>'human'});
Entity->new({name=>'Granma', category=>'human'});


Event->new( { entity => 'Papa', action => 'born', time => '03/09/1961'});
Event->new( { entity => 'Mama', action => 'born', time => '09/16/1964'});
Event->new( { entity => 'Papa and Mama Marry', action => 'born', time => '03/24/1990'});
Event->new( { entity => 'Sebastian', action => 'born', time => '05/22/1996'});
Event->new( { entity => 'Cassandrar', action => 'born', time => '07/22/1998'});
Event->new( { entity => 'Elizabeth', action => 'born', time => '02/18/2005'});
	      
