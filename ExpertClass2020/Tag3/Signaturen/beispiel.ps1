﻿$muster = '^(\d{3})|(\d{1,2}:\d{2})$'

do
{
  $zeit = Read-Host  'Enter Time:'
} until ($zeit -match $muster)

# SIG # Begin signature block
# MIIVPgYJKoZIhvcNAQcCoIIVLzCCFSsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnLHwPWOcLFJR/q+PePyJn4iS
# 19SgghAGMIICBzCCAXCgAwIBAgIQdtSQIR3GxLtKJ3fngpE3fjANBgkqhkiG9w0B
# AQUFADAeMRwwGgYDVQQDDBNTaWNoZXJoZWl0IEhhbm5vdmVyMB4XDTIwMDkxMTEy
# NTE1NloXDTI0MDkxMTAwMDAwMFowHjEcMBoGA1UEAwwTU2ljaGVyaGVpdCBIYW5u
# b3ZlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA4GhmS9mUi92lbXuvzo8z
# TP/ibjyn6lyg/fJkK67kGEwluSdU0TbL8wQ0/aW0O9OURJuLWm0vkHNlF2tPY3YH
# RMS3lQmg4z4aHmryQ2zERtxdq/CSD7zYl6YurP7TqUVe4vZ4TQRkaV51ZZC6lWT1
# SPjJMF3TToPfELmXJJ/+xJUCAwEAAaNGMEQwEwYDVR0lBAwwCgYIKwYBBQUHAwMw
# HQYDVR0OBBYEFOejbJc+sggt5/BycQUoDTE3MG1MMA4GA1UdDwEB/wQEAwIHgDAN
# BgkqhkiG9w0BAQUFAAOBgQAbewRDkVHeVq0JgxIc/bW7fQvaeHe97xjiqx5llqWg
# UHeNV+1PaG5c80ck/BkWuR1c0n2NugAFL5XBYlzCaQUZJozFKfNEHUedYWG1zRzQ
# Ek0P4ukuDrNJgbjJ22FuD5WUFyj2hREy9pVjae2AtW6SHYjlj8uKhcVbQSL2RCRq
# +DCCBuwwggTUoAMCAQICEDAPb6zdZph0fKlGNqd4LbkwDQYJKoZIhvcNAQEMBQAw
# gYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtK
# ZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYD
# VQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE5
# MDUwMjAwMDAwMFoXDTM4MDExODIzNTk1OVowfTELMAkGA1UEBhMCR0IxGzAZBgNV
# BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBUaW1lIFN0
# YW1waW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyBsBr9ks
# foiZfQGYPyCQvZyAIVSTuc+gPlPvs1rAdtYaBKXOR4O168TMSTTL80VlufmnZBYm
# CfvVMlJ5LsljwhObtoY/AQWSZm8hq9VxEHmH9EYqzcRaydvXXUlNclYP3MnjU5g6
# Kh78zlhJ07/zObu5pCNCrNAVw3+eolzXOPEWsnDTo8Tfs8VyrC4Kd/wNlFK3/B+V
# cyQ9ASi8Dw1Ps5EBjm6dJ3VV0Rc7NCF7lwGUr3+Az9ERCleEyX9W4L1GnIK+lJ2/
# tCCwYH64TfUNP9vQ6oWMilZx0S2UTMiMPNMUopy9Jv/TUyDHYGmbWApU9AXn/TGs
# +ciFF8e4KRmkKS9G493bkV+fPzY+DjBnK0a3Na+WvtpMYMyou58NFNQYxDCYdIIh
# z2JWtSFzEh79qsoIWId3pBXrGVX/0DlULSbuRRo6b83XhPDX8CjFT2SDAtT74t7x
# vAIo9G3aJ4oG0paH3uhrDvBbfel2aZMgHEqXLHcZK5OVmJyXnuuOwXhWxkQl3wYS
# mgYtnwNe/YOiU2fKsfqNoWTJiJJZy6hGwMnypv99V9sSdvqKQSTUG/xypRSi1K1D
# HKRJi0E5FAMeKfobpSKupcNNgtCN2mu32/cYQFdz8HGj+0p9RTbB942C+rnJDVOA
# ffq2OVgy728YUInXT50zvRq1naHelUF6p4MCAwEAAaOCAVowggFWMB8GA1UdIwQY
# MBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQaofhhGSAPw0F3RSiO
# 0TVfBhIEVTAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNV
# HSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBF
# oEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRp
# ZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUFBwEBBGowaDA/BggrBgEFBQcw
# AoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUFkZFRydXN0
# Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
# CSqGSIb3DQEBDAUAA4ICAQBtVIGlM10W4bVTgZF13wN6MgstJYQRsrDbKn0qBfW8
# Oyf0WqC5SVmQKWxhy7VQ2+J9+Z8A70DDrdPi5Fb5WEHP8ULlEH3/sHQfj8ZcCfkz
# XuqgHCZYXPO0EQ/V1cPivNVYeL9IduFEZ22PsEMQD43k+ThivxMBxYWjTMXMslMw
# laTW9JZWCLjNXH8Blr5yUmo7Qjd8Fng5k5OUm7Hcsm1BbWfNyW+QPX9FcsEbI9bC
# VYRm5LPFZgb289ZLXq2jK0KKIZL+qG9aJXBigXNjXqC72NzXStM9r4MGOBIdJIct
# 5PwC1j53BLwENrXnd8ucLo0jGLmjwkcd8F3WoXNXBWiap8k3ZR2+6rzYQoNDBaWL
# pgn/0aGUpk6qPQn1BWy30mRa2Coiwkud8TleTN5IPZs0lpoJX47997FSkc4/ifYc
# obWpdR9xv1tDXWU9UIFuq/DQ0/yysx+2mZYm9Dx5i1xkzM3uJ5rloMAMcofBbk1a
# 0x7q8ETmMm8c6xdOlMN4ZSA7D0GqH+mhQZ3+sbigZSo04N6o+TzmwTC7wKBjLPxc
# FgCo0MR/6hGdHgbGpm0yXbQ4CStJB6r97DDa8acvz7f9+tCjhNknnvsBZne5VhDh
# IG7GrrH5trrINV0zdo7xfCAMKneutaIChrop7rRaALGMq+P5CslUXdS5anSevUiu
# mDCCBwcwggTvoAMCAQICEQCMd6AAj/TRsMY9nzpIg41rMA0GCSqGSIb3DQEBDAUA
# MH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
# BgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UE
# AxMcU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTAeFw0yMDEwMjMwMDAwMDBa
# Fw0zMjAxMjIyMzU5NTlaMIGEMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRl
# ciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
# IExpbWl0ZWQxLDAqBgNVBAMMI1NlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgU2ln
# bmVyICMyMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAkYdLLIvB8R6g
# ntMHxgHKUrC+eXldCWYGLS81fbvA+yfaQmpZGyVM6u9A1pp+MshqgX20XD5WEIE1
# OiI2jPv4ICmHrHTQG2K8P2SHAl/vxYDvBhzcXk6Th7ia3kwHToXMcMUNe+zD2eOX
# 6csZ21ZFbO5LIGzJPmz98JvxKPiRmar8WsGagiA6t+/n1rglScI5G4eBOcvDtzrN
# n1AEHxqZpIACTR0FqFXTbVKAg+ZuSKVfwYlYYIrv8azNh2MYjnTLhIdBaWOBvPYf
# qnzXwUHOrat2iyCA1C2VB43H9QsXHprl1plpUcdOpp0pb+d5kw0yY1OuzMYpiiDB
# YMbyAizE+cgi3/kngqGDUcK8yYIaIYSyl7zUr0QcloIilSqFVK7x/T5JdHT8jq4/
# pXL0w1oBqlCli3aVG2br79rflC7ZGutMJ31MBff4I13EV8gmBXr8gSNfVAk4KmLV
# qsrf7c9Tqx/2RJzVmVnFVmRb945SD2b8mD9EBhNkbunhFWBQpbHsz7joyQu+xYT3
# 3Qqd2rwpbD1W7b94Z7ZbyF4UHLmvhC13ovc5lTdvTn8cxjwE1jHFfu896FF+ca0k
# dBss3Pl8qu/CdkloYtWL9QPfvn2ODzZ1RluTdsSD7oK+LK43EvG8VsPkrUPDt2aW
# XpQy+qD2q4lQ+s6g8wiBGtFEp8z3uDECAwEAAaOCAXgwggF0MB8GA1UdIwQYMBaA
# FBqh+GEZIA/DQXdFKI7RNV8GEgRVMB0GA1UdDgQWBBRpdTd7u501Qk6/V9Oa258B
# 0a7e0DAOBgNVHQ8BAf8EBAMCBsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAK
# BggrBgEFBQcDCDBABgNVHSAEOTA3MDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUF
# BwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQUzBEBgNVHR8EPTA7MDmgN6A1hjNo
# dHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnNlY3Rp
# Z28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5jcnQwIwYIKwYBBQUHMAGG
# F2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBDAUAA4ICAQBKA3iQ
# QjPsexqDCTYzmFW7nUAGMGtFavGUDhlQ/1slXjvhOcRbuumVkDc3vd/7ZOzlgreV
# zFdVcEtO9KiH3SKFple7uCEn1KAqMZSKByGeir2nGvUCFctEUJmM7D66A3emggKQ
# wi6Tqb4hNHVjueAtD88BN8uNovq4WpquoXqeE5MZVY8JkC7f6ogXFutp1uElvUUI
# l4DXVCAoT8p7s7Ol0gCwYDRlxOPFw6XkuoWqemnbdaQ+eWiaNotDrjbUYXI8DoVi
# DaBecNtkLwHHwaHHJJSjsjxusl6i0Pqo0bglHBbmwNV/aBrEZSk1Ki2IvOqudNaC
# 58CIuOFPePBcysBAXMKf1TIcLNo8rDb3BlKao0AwF7ApFpnJqreISffoCyUztT9t
# r59fClbfErHD7s6Rd+ggE+lcJMfqRAtK5hOEHE3rDbW4hqAwp4uhn7QszMAWI8mR
# 5UIDS4DO5E3mKgE+wF6FoCShF0DV29vnmBCk8eoZG4BU+keJ6JiBqXXADt/QaJR5
# oaCejra3QmbL2dlrL03Y3j4yHiDk7JxNQo2dxzOZgjdE1CYpJkCOeC+57vov8fGP
# /lC4eN0Ult4cDnCwKoVqsWxo6SrkECtuIf3TfJ035CoG1sPx12jjTwd5gQgT/rJk
# XumxPObQeCOyCSziJmK/O6mXUczHRDKBsq/P3zGCBKIwggSeAgEBMDIwHjEcMBoG
# A1UEAwwTU2ljaGVyaGVpdCBIYW5ub3ZlcgIQdtSQIR3GxLtKJ3fngpE3fjAJBgUr
# DgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkq
# hkiG9w0BCQQxFgQU5ot1vjU+hFqYli9VNva2fgtqRgEwDQYJKoZIhvcNAQEBBQAE
# gYBMmIpBG1uIaaNXdzawHESh3n+fBxgjMbN18uLBYAgaqazspfYOunLjtWcyDteN
# 6PgZ5K156csHrzFmb++QWwnVYIEcqCw0f2cOovGHl0C0m0sYXp6XKLwz36256jZV
# 6F15IMwwl4s2Cb+3vwzdDeRyYt+wEfZQ95hDcQSDChWzbKGCA0wwggNIBgkqhkiG
# 9w0BCQYxggM5MIIDNQIBATCBkjB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
# YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0
# aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcg
# Q0ECEQCMd6AAj/TRsMY9nzpIg41rMA0GCWCGSAFlAwQCAgUAoHkwGAYJKoZIhvcN
# AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTE5MTQ1MTU3WjA/
# BgkqhkiG9w0BCQQxMgQwomjiT0VfLSmerScz4uWLtfdR6FlLfezsi8ckmk/KcIVW
# umVInXUKefaIbzjS6SP9MA0GCSqGSIb3DQEBAQUABIICABR17m74SqdNXbcBiGT4
# NhTIc8fZVJtkasyf2gwmode7LutvM7IKYJWmZN7q5kk6iCnZzY+eijyrM37xWOgT
# Z7Z1ocVDknV6YJ6Ryu5HUqHIjQ2b3od1jaqeAgiAbdqhKUxz/8cUnJPkeHIn1uM+
# 1XJ71miIfyiUmzL6yZOiMvwF6Yqx8wLwzW8DGTUdMcT16YQhgenGV0162N3cOqT7
# n7V/3bAxizP/iO+RZyFj5zp9TZ0ZpOOR8Y2juDSXGTlINhhotkXxWE45uKeNWsBs
# a92cDKJAEW/rPPrvCR6+Mk/CRbHOsy5BYt1zM9v6i1YWr0y4ZVAjW1+FbExUQ6ln
# tffKA39RGQ4e4Q7MBDE+iBwEhguZup94e7Hw9NW36B9J9S8NPR7XbYSsgF09xHT8
# 123ufMampgtzXJ5Xl8DPfMgtuNzI5SluY3qFZsIBLoEN0K8yjKNVPN6A9S/VhY2e
# 5IrYtgIs9m8ROJnXVa/hAJjWYV8DqyJMZTLvqvMFstlg7hTOO3xzTrMo+22qv8kx
# H7SuUOAP2buFKpcpF4Q0F89+uC1BtvtEtNHnbRD9VldW/qPEi2GTEDPQOVlZnaK3
# n7u5hGKswNdyaKODrmq8+q36f0h5gxwHF6R+KkqerDcXd4roRSq6YYXO5tqFGfxb
# Z4IrydwXHVDDn5M+7aVkOdiX
# SIG # End signature block
