Update-TypeData -MemberName Availability -TypeName "Microsoft.Management.Infrastructure.CimInstance#root/cimv2/win32_battery" -MemberType ScriptProperty  -Value {
  Enum EnumAvailability
  {
    Other                       = 1
    KeineAhnung                     = 2
    RunningFull_Power           = 3
    Warning                     = 4
    In_Test                     = 5
    Not_Applicable              = 6
    Power_Off                   = 7
    Off_Line                    = 8
    Off_Duty                    = 9
    Degraded                    = 10
    Not_Installed               = 11
    Install_Error               = 12
    Power_Save_Unknown          = 13
    Power_Save_Low_Power_Mode   = 14
    Power_Save_Standby          = 15
    Power_Cycle                 = 16
    Power_Save_Warning          = 17
    Paused                      = 18
    Not_Ready                   = 19
    Not_Configured              = 20
    Quiesced                    = 21
  }

  [EnumAvailability]($this.PSBase.CimInstanceProperties['Availability'].Value)
} -Force

Get-CimInstance -ClassName Win32_Battery | Select-Object -Property DeviceID, Availability