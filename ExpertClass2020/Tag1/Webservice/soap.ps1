#https://blog.victorsilva.com.uy/query-webservices-powershell/
$URI = "http://www.dneonline.com/calculator.asmx"
$proxy = New-WebServiceProxy -Uri $URI -Class calculator -Namespace webservice
$proxy.Add(1,2)
$proxy.Divide(100,4)


