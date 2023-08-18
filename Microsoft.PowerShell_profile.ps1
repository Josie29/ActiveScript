$continue = $true

function ListCryptoRate { param([string]$symbolsString,[string]$worldCurrenciesString)
    $rates=(Invoke-WebRequest -uri "https://min-api.cryptocompare.com/data/pricemulti?fsyms=$symbolsString&tsyms=$worldCurrenciesString" -userAgent "curl" -useBasicParsing).Content | ConvertFrom-Json
    $symbols = $symbolsString.Split(',');
    foreach($symbol in $symbols){
        $obj = New-Object PSObject -property @{ "Cryptocurrency" = "1 $symbol ="} 
        $worldCurrencies = $worldCurrenciesString.split(',')                             
        foreach($worldCurrency in $worldCurrencies){
            $obj | Add-Member -NotePropertyName $worldCurrency -NotePropertyValue $rates.$symbol.$worldCurrency
        }
        $obj
    }
}
function ListCryptoRates {
    #format strings CSV style
    ListCryptoRate "BTC,ETH,LTC,DOGE" "USD"
}

function reprompt {
    sleep -seconds 1
    Write-Host "`nGreat work Josie! Please type in the number of the next activity you would like to pursue:" -foregroundcolor cyan -backgroundcolor DarkGray
    Write-Host ("1: plural sight practice","3: crypto rates", "4: joke", "5: Edit script in VS", "6: Quit", "7: System Subsystem VS","9: open Jupyter Notebooks", "A: active") -Separator "`n" -foregroundcolor magenta
}

Write-Host "Welcome Josie! Please type in the number of the activity you would like to pursue:" -foregroundcolor cyan -backgroundcolor DarkGray
Write-Host ("1: plural sight practice", "2: dev setup utility", "3: crypto rates", "4: joke", "5: Edit script in VS", "6: Quit", "7: System Subsystem VS", "9: open Jupyter Notebooks", "A: active", "B: jmeter", "C: adb logcat") -Separator "`n" -foregroundcolor magenta
$option = Read-Host
while($continue -eq $true){
    if ($option -eq 1){
        cd "c:\Users\machaj9\OneDrive - Medtronic PLC\pluralSIghtPrac\FTE"
        dir
        $continue = $false
    }
    elseif ($option -eq 2){
        cd "c:\Users\machaj9\source\repos\cln-developer-setup-utility"
        .\DeveloperSetupMain.ps1
        $option = Read-Host
    }
    elseif ($option -eq 3){
        Write-Host "Excellent choice"
        # call the function ListCryptoRates, format results into a table with columns aligning with properties listed
        ListCryptoRates | Format-Table -property 'Cryptocurrency', USD
        reprompt $option
        $option = Read-Host
    }
    elseif ($option -eq 4){
        Write-Host "Prepare to laugh"
        #sleep -seconds (1) #wait 1 second as I have a flare for drama
        $headers=@{}
        $headers.Add("accept", "application/json")
        $headers.Add("X-RapidAPI-Key", "dd250e5e05mshe08b73f6b50d187p17be2cjsn054f62d0f31a")
        $headers.Add("X-RapidAPI-Host", "matchilling-chuck-norris-jokes-v1.p.rapidapi.com")
        $response = (Invoke-WebRequest -Uri 'https://matchilling-chuck-norris-jokes-v1.p.rapidapi.com/jokes/random' -Method GET -Headers $headers).Content | ConvertFrom-Json
        $response.value
        reprompt
        $option = Read-Host
    }
    elseif ($option -eq 5){
        cd "C:\Users\machaj9\OneDrive - Medtronic PLC\WindowsPowerShell"
        start Microsoft.PowerShell_profile.ps1
        #ise $profile #note works in ps but wont work in ise
        $continue = $false
    }
    elseif ($option -eq 6){
        $continue = $false
    }
    elseif ($option -eq 7){
        cd C:\Users\machaj9\source\repos\carelink-system-subsystem
        start CareLink.System.sln
        $continue = $false
    }
    elseif ($option -eq 9){
        cd C:/jupNBs
        python -m notebook
        $continue = $false
    }
    elseif ($options -eq 11){
        start-process "https://dev.azure.com/MDTProductDevelopment/carelink/_sprints/taskboard/chargers/carelink/ART/PI%2032/PI%2032.2"
        $continue = $false
    }
    elseif ($options -eq 12){
       cd C:/users/machaj9/projects/
       python UUID_byte_reversal.py
       continue = $false
    }
    elseif ($option -eq 'A'){
        cd "C:\Users\machaj9\PycharmProjects\activeDetailed" 
        python main.py
        $continue = $false
    }
    elseif($option -eq 'B'){
        cd "C:\Java\apache-jmeter-5.6.2\bin"
        .\jmeter.bat
        $continue = $false
    }
    elseif($option -eq 'C'){
        cd "C:\adb\adb"
        .\adb logcat
        $continue = $false
    }
    else {
        Write-Host "This was not an option silly goose, please enter a valid char"
        reprompt
        $option = Read-Host
    }
}

