$Tags                                 = @{ `
  CustomerName                        = 'SmartIT Services AG - Azure DEV'
  CustomerShort                       = 'smdv'
  CustomerProjectNumber               = '0'
  ServiceOwner                        = 's.beckmann@smartit.ch'
}

If ($Tags -isnot [Hashtable]){ $Tags = Invoke-Expression $Tags }


$Tags.GetType()
$Tags | FT
