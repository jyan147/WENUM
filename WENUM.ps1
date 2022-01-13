#Enumeration Windows Tool

<#
Enumeration Windows Tool
V 1.0
jyan147
Yoldas Guzelyildiz
#>

function Show-Menu {

    param([string]$Title = 'Enumeration Tool') #parametre du titre de menu

    Clear-Host #supprimer terminal a chaque selection

    Write-Host = "============================$Title============================"
    Write-Host = "1) Press '1' List local Users"
    Write-Host = "2) Press '2' List local Groups"
    Write-Host = "3) Press '3' List OS Version and Name"
    Write-Host = "4) Press '4' List FQDN Local"
    Write-Host = "5) Press '5' List FQDN Remote"
    Write-Host = "6) Press '6' List Domain Name"
    Write-Host = "7) Press '7' List Domain Name Using DC"
    Write-Host = "8) Press '8' List Domain DistinGuished Name"
    Write-Host = "9) Press '9' List DNS Client Server"
    Write-Host = "10) Press '10' List SMB Shares"
    Write-Host = "11) Press '11' List PING"
    Write-Host = "12) Press '12' List Users password required values set to False"
    Write-Host = "13) Press '13' List IP Address Info"
    Write-Host = "14) Press '14' List Listening ports"
    Write-Host = "15) Press '15' List Patches"
    Write-Host = "16) Press '16' List Search file by type"
    Write-Host = "17) Press '17' List Search string in file(s)"
    Write-Host = "18) Press '18' List Process"
    Write-Host = "19) Press '19' List Scheduled Tasks"
    Write-Host = "20) Press '20' Get Schedule Task By Name"
    Write-Host = "21) Press '21' Get owner of directories"
    Write-Host = "q) Press 'q' to Quit"




}

<#

Functions to enumerate
#>

function Show-LocalUsers{
        Get-LocalUser
}

function Show-LocalGroup{
        Get-LocalGroup
}

function Show-OsVersionAndName{

    $os_version = (Get-WMIObject win32_operatingsystem).name
    $os_name = (Get-WmiObject Win32_OperatingSystem).CSName

    Write-Output "OS Version: $($os_version)" "Os Name: $($os_name)"

}

function Get-FQDN_Local{
    
    [System.Net.Dns]::GetHostByName($env:computerName)

}

function Get-FQDN_Remote{ # recupere URI LOCAL

    $remote_ip = Read-Host "Enter remote IP address"
    [System.Net.Dns]::GetHostByName($remote_ip).HostName

}

function Get-DomainName{

    $namespace = Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name
    Get-WmiObject -Namespace $namespace -Class Win32_ComputerSystem | Select Name, Domain
}

function Get-DomainNameByDC{ #recupere le nom de domaine avec DOMAIN CONTROLLER
    $namespace = Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name
    Get-ADDomainController -Identity $namespace | Select-Object Name, Domain

}

function Get-DomainDistinGuishedName{

    Get-ADDomain -Current LoggedOnUser

}

function Get-DNSClientServer{

    Get-DnsClientServerAddress

}

function Get-SMBShare1{

    Get-SmbShare
    Get-SmbClientConfiguration
    Get-SmbMapping
    
}

function FunctionPing{
    
    $remote_ip = Read-Host = "Enter IP Address"
    Test-Connection $remote_ip
}

function Get-UsersPasswordFalse{ #users who have their password required values set to False

    Get-LocalUser | Where-Object -Property PasswordRequired -Match false

}

function Get-IPAddressInfo{

    Get-NetIPAddress
    

}

function Get-ListeningPorts{

    GEt-NetTCPConnection | Where-Object -Property State -Match Listen

}

function Get-Patches{

    Get-HotFix

}

function SearchFileByType{

    $path = Read-Host "Enter path to search(C:/ , D:/ ...) "
    $Type = Read-Host "Enter type of file(txt,png,pdf...): "
    Get-ChildItem -Path $path -Include *$($Type)* -File -Recurse -ErrorAction SilentlyContinue
            
}

function SearchByString{ #permet de rechercher les chaines de caracteres dans un fichier référencé
    $path = Read-Host "Enter Paht to search: "
    $string = Read-Host "Enter string to search in file(s): "
    Get-ChildItem -Path $path -Recurse | Select-String -Pattern $string

}

function Get-Process1{
    
    Get-Process
}

function Get-ScheduleTask1{

    Get-ScheduleTask

}

function Get-ScheduleTaskByName{
    $taskname = Read-Host "Enter taskname: "
    Get-ScheduleTask -TaskName $taskname
}

function Get-Owner{#get owner of directories
    $directory = Read-Host "Enter directory: "
    Get-Acl $directory
}


function ScanPorts{

}



do{

    Show-Menu -Title 'Windows Enumeration Tool'

    $input = Read-Host "Select"

    switch -Wildcard ($input){
        
        '1' { 
                Show-LocalUsers
            }


        '2' {
                Show-LocalGroup
            }

        '3' {

            Show-OsVersionAndName
            }
        '4' {

            Get-FQDN_Local
            }
        '5' {

            Get-FQDN_Remote
            }
        '6' {

            Get-DomainName
            }
        '7' {

            Get-DomainNameByDC
            }
        '8' {

            Get-DomainDistinGuishedName
            }
        '9' {

            Get-DNSClientServer
            }
        '10' {

            Get-SMBShare1
            }

        '11' {

            FunctionPing
            }

        '12' {

            Get-UsersPasswordFalse
            }

        '13' {

            Get-IPAddressInfo
            }

        '14' {

            Get-ListeningPorts
            }

        '15' {

            Get-Patches
            }

        '16' {

            SearchFileByType
            }
        '17' {

            SearchByString
            }
        '18' {

            Get-Process1
            }
        '19' {

            Get-ScheduleTask1
            }

        '20' {

            Get-ScheduleTaskByName
            }

        '21' {

            Get-Owner
            }



        'q' {
                return 
            }
            
            default {

                Write-Warning 'Please enter a valid number'
            }
    }

    pause

}

until ($input -eq 'q')
