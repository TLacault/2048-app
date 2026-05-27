# invite-users.ps1
# Invites a list of users to an Azure tenant, creates a dedicated resource group
# for each, and assigns them the Contributor role on that resource group.

# ---------------------------------------------------------------------------
# Configuration – update these values before running
# ---------------------------------------------------------------------------
$tenantId       = ""
$subscriptionId = ""
$location       = "France Central"
$redirectUrl    = "https://portal.azure.com"

# List of email addresses to invite
$users = @(
)
# ---------------------------------------------------------------------------

# Disable the interactive upgrade prompt so az commands don't hang
$env:AZURE_CORE_DISABLE_CONFIRM_PROMPT = "true"
az config set auto-upgrade.enable=no --only-show-errors 2>$null

# If not already logged in, run: az login --tenant $tenantId
az account set --subscription $subscriptionId

foreach ($email in $users) {
    Write-Host "`n=== Processing $email ===" -ForegroundColor Cyan

    # --- 1. Invite the user (skip if guest already exists) ---------------
    $encodedEmail = [Uri]::EscapeDataString($email)
    $existingUser = az rest `
        --method GET `
        --uri "https://graph.microsoft.com/v1.0/users?`$filter=mail eq '$email' or userPrincipalName eq '$email'" `
        --query "value[0].id" -o tsv 2>$null

    if ($existingUser) {
        $userId = $existingUser.Trim()
        Write-Host "  Guest already exists. Object ID: $userId"
    } else {
        Write-Host "  Sending invitation..."

        # Write JSON body to a temp file to avoid PowerShell quoting issues with az rest
        $bodyFile = [System.IO.Path]::GetTempFileName()
        @{
            invitedUserEmailAddress = $email
            inviteRedirectUrl       = $redirectUrl
            sendInvitationMessage   = $true
        } | ConvertTo-Json | Set-Content -Path $bodyFile -Encoding utf8

        $invitationJson = az rest `
            --method POST `
            --uri "https://graph.microsoft.com/v1.0/invitations" `
            --headers "Content-Type=application/json" `
            --body "@$bodyFile" 2>&1

        Remove-Item $bodyFile -ErrorAction SilentlyContinue

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "  Failed to invite $email – skipping. Error: $invitationJson"
            continue
        }

        $invitation = $invitationJson | ConvertFrom-Json
        $userId = $invitation.invitedUser.id

        if (-not $userId) {
            Write-Warning "  Could not retrieve object ID for $email – skipping."
            continue
        }

        Write-Host "  Invited. Guest object ID: $userId"
    }

    # --- 2. Create a resource group ----------------------------------------
    # Build a safe RG name from the email address (no @ or dots in names)
    $safeName = ($email -replace "@", "-at-" -replace "\.", "-").ToLower()
    $rgName   = "rg-$safeName"

    $rgExists = az group exists --name $rgName
    if ($rgExists -eq "true") {
        Write-Host "  Resource group '$rgName' already exists, skipping creation."
    } else {
        Write-Host "  Creating resource group '$rgName'..."
        az group create `
            --name $rgName `
            --location $location `
            --tags Class=EI8IT213 | Out-Null

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "  Failed to create resource group for $email – skipping role assignment."
            continue
        }
    }

    # --- 3. Assign Contributor on the resource group -----------------------
    $scope = "/subscriptions/$subscriptionId/resourceGroups/$rgName"

    $existingAssignment = az role assignment list `
        --assignee $userId `
        --role "Contributor" `
        --scope $scope `
        --query "[0].id" -o tsv 2>$null

    if ($existingAssignment) {
        Write-Host "  Contributor role already assigned, skipping."
    } else {
        Write-Host "  Assigning Contributor role..."
        az role assignment create `
            --assignee $userId `
            --role "Contributor" `
            --scope $scope | Out-Null

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "  Role assignment failed for $email."
            continue
        }
    }

    Write-Host "  Done: $email -> $rgName (Contributor)" -ForegroundColor Green
}

Write-Host "`nAll users processed." -ForegroundColor Cyan
