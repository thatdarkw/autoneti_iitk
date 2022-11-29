
$username=""
$password=""

$keepalive="https://gateway.iitk.ac.in:1003/keepalive?080902080a3d09c7"
$logout="https://gateway.iitk.ac.in:1003/logout?0a060c0e0b310bc5"

if ($args[0] -eq "c" -or $args[0] -eq "C") {
    $url = Invoke-WebRequest "http://google.com" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    if ($url.StatusCode -eq 303) {
        $url = Invoke-WebRequest "http://google.com" -UseBasicParsing
        $url_resp_string = $url.ToString() -split "[`r`n]" -imatch "magic"
        $magic_num = $url_resp_string -split '"' | select -Index 5
        $con_req = Invoke-WebRequest -Method Post -Body "magic=$magic_num&username=$username&password=$password" https://gateway.iitk.ac.in:1003/ -UseBasicParsing
        $logout = $con_req.Links | Select-Object -ExpandProperty href | select -Index 1

        $keepalive_find = $con_req.ToString() -split "[`r`n]" -imatch "location.href="
        $keepalive = $keepalive_find -split '"' | select -Index 1
        echo "Connected..."
        echo $keepalive
    }
    else {
       echo "Already connected..."
       echo $keepalive
    }

    while($true){
    curl $keepalive -UseBasicParsing | Out-Null
    Start-Sleep -Seconds 500
    }

}

elseif ($args[0] -eq "d" -or $args[0] -eq "D") {
    $logout_req = curl $logout -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    if ($logout_req.StatusCode -eq 200) {
        echo "Disconnected..."
    }
    else {
        echo "Probably not connected... Connect first..."
    }
}
else {
    echo "Pass either c to connect or d to disconnect."
}

