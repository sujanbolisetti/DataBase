xquery version "3.0";

(: ---- Declare the namespace specified in the data file. ----- :)

declare default element namespace "http://www.cse532.com";

let $airline := doc("hw6.xml")/AirLineFlights



let $intermediate_result := 

(
    for $al in $airline/Airline

       return

        <Airport>

            {$al/AirlineName}

            {

                for $from in $al/Flight/AirFlightTime

                let $to := $from/following-sibling::AirFlightTime[1]

                    where exists($to)  (: ---- To check for the empty last sibling in the tree ----- :)

                return

                    <Connection>

                        <From>{data($from/AirportCode)}</From>

                        <To>{data($to/AirportCode)}</To>

                    </Connection>  

            }

         </Airport>
    )

 let $Airports := 

  (

        for $r1 in $intermediate_result/Connection

            for $r2 in $intermediate_result/Connection

                where ($r1/../AirlineName) < ($r2/../AirlineName) and ($r1/From = $r2/From) and ($r1/To = $r2/To)

            return $r1

        )
return <NonStopPairs>{$Airports}</NonStopPairs>
