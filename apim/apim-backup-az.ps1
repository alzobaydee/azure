#following up from part one of the blog post: 

#Connect to azure account
Connect-AzAccount
#login and choose subscription (if you have many)

#Set variables replace everything inside the ""
$resourceGroupName = "<your-resouce-group-name-where-you-have-your-apim>"
$location = "<the-region-closest-to-you>"

#now for the new variables
#between 3 - 24 chars, numbers and lower-case letters only
$storageAccountName = "<new-or-existing-storage-accoutn-name>"
$storageSkuName = "<your-choice-of-your-storage-'availability'>"

#"dynamic" variables like $storageKey and $storageContext will
# not be listed here as they will be created by script

#variables to be used later on, but declared here for easier swaps
$targetContainerName = "<new-container-name>"
$apimName = "<your-APIM-service-name>"

#target blob name is your container name and a new name joined with a dot (.)
$targetBlobName = $($targetContainerName + "." + "<new-blob-name>")


#show time
#storage account creationg
New-AzStorageAccount -StorageAccountName $storageAccountName -Location $location -ResourceGroupName $resourceGroupName -Type $storageSkuName
# storage key to create context
$storageKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName)[0].Value
#context to connect to the storage
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey
#now we create a container with public access off
New-AzStorageContainer -Name targetContainerName -Context $storageContext -Permission Off
#time to create our backup
Backup-AzApiManagement -ResourceGroupName $resourceGroupName -Name $apimName -StorageContext $StorageContext -TargetContainerName $targetContainerName -TargetBlobName $targetBlobName
