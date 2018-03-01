<#
 .Synopsis
 Hochladen einer Datei in ein Azure-Speicherkonto
#>

Login-AzureRmAccount

$AzureSub = Get-AzureRmSubscription
if (Test-AzureName -Storage -Name $StorageAccountName)
{
    Write-Verbose "$StorageAccountName existiert bereits."
}
else
{
    $Result = New-AzureStorageAccount -StorageAccountName $StorageAccountName -Location $Location -Type $StorageType
    if ($Result.OperationStatus -eq "Succeeded") {
        Set-AzureSubscription –SubscriptionName $AzureSub.SubscriptionName[0] -CurrentStorageAccount $StorageAccountName 
        New-AzureStorageContainer -Name $Container -Permission Off 
    }
    else 
    {
        Write-Warning "Fehler beim Anlegen von $StorageAccountName - Skript wird beendet."
        exit -1
    }
}

$UploadPath = "C:\Windows\Win.ini"
$Blobname = "IniBlob"

Set-AzureStorageBlobContent -Container $Container -File $UploadPath -Blob $Blobname

Get-AzureStorageBlob -Blob $BlobName -Container $Container | Select *
