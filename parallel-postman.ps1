$collectionURl = $args[0]
$reps = $args[1]
$delay = $args[2]
#$startTime = Get-Date

for (($i = 0); $i -lt $reps; $i++){
    Start-Job -ScriptBlock {newman run $args} -ArgumentList $collectionURl
    Start-Sleep -Milliseconds $delay
}

# wait completion
While (Get-Job -State "Running") {    
    Write-Output "Running..." -v $info
    Start-Sleep 15        
}

# get output
$count=0
foreach($job in Get-Job){
    $count++
    #Receive-Job -Job $job | Out-File c:\Test.log -Append
    $output = Receive-Job -Job $job
    # get only useful content -- FIX
        #Write-Output ("start out " + $output.IndexOf("POST") + "end out " + $output.IndexOf("END"))
        #$result=$output.Substring($output.IndexOf("POST"), $output.IndexOf("END")) # fix - indexof gives -1    
    Write-Output ("`r`nOUTPUT_" + $count + ": `r`n"+$output)
}

# remove jobs
foreach($job in Get-Job){
    Remove-Job -Job $job
}

Write-Output ("All Jobs Removed, exiting...")

# get entire process duration
#$endTime = Get-Date
#$duration = New-TimeSpan -Start $startTime -End $endTime
#Write-Output "Duration is: $duration"

# TODO 
    # fix output cleaning 
    # get total process duration