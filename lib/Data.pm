
use strict;

use Action;
use Entity;
use Event;

Action->new ('began');
Action->new({name=>'born', qualifier=>'was'});
Action->new({name=>'formed', qualifier=>'was'});

Entity->new('Big Bang');
Entity->new({name=>'Life', category=>'life form'});
Entity->new({name=>'human', category=>'mammal'});
Entity->new({name=>'mammal', category=>'vertebrae'});
Entity->new({name=>'vertebrae', category=>'animal'});
Entity->new({name=>'animal', category=>'life form'});

Entity->new({name=>'Mankind', category=>'cosmos'});
Entity->new({name=>'David Link', category=>'human'});
Entity->new({name=>'Sebastian Link', category=>'human'});
Entity->new({name=>'cat', category=>'mammal'});
Entity->new({name=>'fish', category=>'vertebrae'});
Entity->new({name=>'bat', category=>'mammal'});


Event->new( { name=>'Big Bang', action=>'began', time=>'15,000,000,000 bc'});
Event->new( { entity => 'Solar System',action => 'formed',
	      time => '4,600,000,000 BC' });
Event->new( { entity => 'Life', action => 'began', 
	      time => '3,500,000,000 BC' });
Event->new( { entity => 'Multicelled Life', action => 'began', 
	      time => '1,000,000,000 BC' });
Event->new( { entity => 'Dinosaurs', action => 'began', 
	      time => '230,000,000 BC' });
Event->new( { entity => 'Primates', action => 'began', 
	      time => '60,000,000 BC' });
#Event->new( { entity => 'David Link', action => 'born', time => '03/09/1961'});
Event->new( { entity => 'Sebastian Link', action => 'born', time => '05/22/1996'});
#Event->new( { entity => 'Cassandra Link', action => 'born', time => '07/22/1996'});
#Event->new( { entity => 'David Link', action => 'ate dinner', time => '07/03/2005 8:00pm'});

#Event->new( { entity => 'Mankind', action => 'began', time => '2000,000 bc' });
	      
