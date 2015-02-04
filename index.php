
 <?php
 
$company = $_GET["symbol"];
			
//echo "<root><Name>$company</Name></root>";

Header("Content-type:text/xml;charset=utf-8"); 

$xmlurl = urlencode("http://query.yahooapis.com/v1/public/yql?q=Select%20Name%2C%20Symbol%2C%20LastTradePriceOnly%2C%20Change%2C%20ChangeinPercent%2C%20PreviousClose%2C%20DaysLow%2C%20DaysHigh%2C%20Open%2C%20YearLow%2C%20YearHigh%2C%20Bid%2C%20Ask%2C%20AverageDailyVolume%2C%20OneyrTargetPrice%2C%20MarketCapitalization%2C%20Volume%2C%20Open%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%3D%22".$company."%22&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys");
			
			//echo "<a href = $xmlurl>"."xmlurl"."</a>";
			
$newsurl = urlencode("http://feeds.finance.yahoo.com/rss/2.0/headline?s=".$company."&region=US&lang=en-US");

$imageurl = urlencode("http://chart.finance.yahoo.com/t?s=".$company."&amp;lang=en-US&amp;amp;width=300&amp;height=180");


$xml = simplexml_load_file($xmlurl);
				 
                $xmlvalue = $xml->results->quote;
				
				$name = $xmlvalue->Name;
				
				$symbol = $xmlvalue->Symbol;
				
				function changeformat($input)
				{
					
					if($input == "" || $input == null)
					{
						return "";
					}
					
					$input = (double) $input;
					
					if($input<0)
					{
						$input = -$input;
					}
					
					
						$output = number_format($input,2);
					return $output;
				}
				
				function changeformat2($input)
				{
					if($input == "" || $input == null)
					{
						return "";
					}
					$input = (double) $input;
						$output = number_format($input,0);
					return $output;
				}
				function changeformat3($input)
				{
					if($input == "" || $input == null)
					{
						return "";
					}
					$input = (double) $input;
						$output = number_format($input,1);
					return $output;
				}
				
				function judgechange($input)
				{
					$input = (double) $input;
					if($input > 0)
					{
						return "+";
					}
					if($input < 0)
					{
						return "-";
					}
					if($input == 0)
					{
						return "";
					}
				}
				
				
				$bid = changeformat($xmlvalue->Bid);
				$prec = changeformat($xmlvalue->PreviousClose);
				$dl = changeformat($xmlvalue->DaysLow);
				$dh = changeformat($xmlvalue->DaysHigh);
				$open = changeformat($xmlvalue->Open);
				$change = $xmlvalue->Change;
				$yl = changeformat($xmlvalue->YearLow);
				$yh = changeformat($xmlvalue->YearHigh);
				$vl = changeformat2($xmlvalue->Volume);
				$ask = changeformat($xmlvalue->Ask);
				$avl =changeformat2($xmlvalue->AverageDailyVolume);
				$mc = $xmlvalue->MarketCapitalization;
				$mc1 = changeformat3(substr($mc, 0, -1));
				$mc2 = substr($mc, -1);
				$oyt = changeformat($xmlvalue->OneyrTargetPrice);
				$lasttradeonly = changeformat($xmlvalue->LastTradePriceOnly);
				$updown = judgechange($xmlvalue->Change);
				$change_c = changeformat($xmlvalue->Change);
				$per = changeformat($xmlvalue->ChangeinPercent);
				
				$xmlString = "";
				
					$xmlString .= '<result><Name>'.$name.'</Name>'.'<Symbol>'.$symbol.'</Symbol>';
					$xmlString .= '<Quote>';
					$xmlString .='<ChangeType>'.$updown. '</ChangeType>';

					$xmlString .='<Change>'.$change_c.'</Change>';

$xmlString .='<ChangeInPercent>'.$per.'</ChangeInPercent>';

$xmlString .='<LastTradePriceOnly>'.$lasttradeonly.'</LastTradePriceOnly>';

$xmlString .='<PreviousClose>'.$prec.'</PreviousClose>';

$xmlString .='<DaysLow>'.$dl.'</DaysLow>';

$xmlString .='<DaysHigh>'.$dh.'</DaysHigh>';

$xmlString .='<Open>'.$open.'</Open>';

$xmlString .='<YearLow>'.$yl.'</YearLow>';

$xmlString .='<YearHigh>'.$yh.'</YearHigh>';

$xmlString .='<Bid>'.$bid.'</Bid>';

$xmlString .='<Volume>'.$vl.'</Volume>';

$xmlString .='<Ask>'.$ask.'</Ask>';
$xmlString .='<AverageDailyVolume>'.$avl.'</AverageDailyVolume>';
$xmlString .='<OneYearTargetPrice>'.$oyt.'</OneYearTargetPrice>';
$xmlString .='<MarketCapitalization>'.$mc.'</MarketCapitalization>';
$xmlString .= '</Quote></result>';
				
?>