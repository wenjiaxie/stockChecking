<?php 



$company = $_GET["symbol"];
			

Header("Content-type:text/Json;charset=utf-8"); 
header("Access-Control-Allow-Origin: * ");
$xmlurl = urlencode("http://default-environment-ppeignfiyv.elasticbeanstalk.com/?symbol=".$company);
			


$xml = simplexml_load_file($xmlurl);



/*
<ChangeType>+</ChangeType>
<Change>6.81</Change>
<ChangeInPercent>1.16</ChangeInPercent>
<LastTradePriceOnly>596.08</LastTradePriceOnly>
<PreviousClose>589.27</PreviousClose>
<DaysLow>589.50</DaysLow>
<DaysHigh>596.48</DaysHigh>
<Open>591.63</Open>
<YearLow>502.80</YearLow>
<YearHigh>604.83</YearHigh>
<Bid>593.85</Bid>
<Volume>3,727,045</Volume>
<Ask>595.50</Ask>
<AverageDailyVolume>1,560,380</AverageDailyVolume>
<OneYearTargetPrice/>
<MarketCapitalization>403.2B</MarketCapitalization>

*/

	
$jsonString = json_encode($xml);

echo '{"result":'.$jsonString.'}';
?>


