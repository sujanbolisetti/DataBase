xquery version "3.0";
(: ---- Declare the namespace specified in the data file. ----- :)

declare default element namespace "http://www.cse532.com";
let $airlineFlight := doc("hw6.xml")/AirLineFlights
return

<AirportAirLineList>
{
	for $af in $airlineFlight/Airport
		let $airline := (for $al in $airlineFlight/Airline
				where $al/Flight/AirFlightTime = (
				    for $airft in $al/Flight/AirFlightTime
					    where $af/AirportCode = $airft/AirportCode and
					          ($airft/DepartTime > xs:time("12:00:00")) and
					  	      ($airft/DepartTime < xs:time("16:00:00"))
					    return ($airft)
					    )
				return ($al)
				)
	where exists($airline)
	return <Airport>{ $af/AirportCode } <Airline> {$airline/AirlineName} </Airline> </Airport>
}
</AirportAirLineList>