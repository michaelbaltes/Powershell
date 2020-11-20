

class CFilterBuilder {
    
    CFilterBuilder () {}


    [string] GetFilter ( [String]$Name, [String]$Value ) {

        if ( $Value.startswith('*') -and $Value.endswith('*') ) {
            
            # wildcard at both ends
            # e.g. -Name '*Dell*' --> contains(Name,'Dell')
            $strFilter = "contains({0},'{1}')" -f $Name, $Value.TrimStart('*').TrimEnd('*')
        }
        elseif ( $Value.startswith('*') ) {
            
            # wildcard at beginning
            # e.g. -Name '*Lenovo' --> endswith(Name,'Lenovo')
            $strFilter = "endswith({0},'{1}')" -f $Name, $Value.TrimStart('*')
        }
        elseif ( $Value.endswith('*') ) {
            
            # wildcard at end
            # e.g. -Name 'Driver - Dell*' --> startswith(Name,'Driver - Dell')
            $strFilter = "startswith({0},'{1}')" -f $Name, $Value.TrimEnd('*')
        }
        else {
            
            # no wildcards
            # e.g. -Name 'Lenovo' --> Name eq 'Lenovo'
            $strFilter = "{0} eq '{1}'" -f $Name, $Value
        }
    
        return $strFilter
    }

    [string] GetFilter ( [string] $Name, [Int] $Value ) {

        # no wildcards
        # e.g. -ResourceId 1234567 --> ResourceId eq 1234567
        $strFilter = "{0} eq {1}" -f $Name, $Value

        return $strFilter
    }

}