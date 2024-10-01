# Caminhos
$source = "E:\Google Drive\01 - Projects\World-of-Warcraft-Goldmaking\Automations\Addons Development\Auction-House-Pro-Tools-addon"
$destination = "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\Auction-House-Pro-Tools"

# Obter a branch ativa
$gitBranch = git rev-parse --abbrev-ref HEAD

# Verifica se a pasta de destino existe
Write-Host "Verificando se a pasta de destino existe: $destination"
if (!(Test-Path -Path $destination)) {
    Write-Host "Pasta de destino não encontrada. Criando a pasta."
    New-Item -ItemType Directory -Path $destination
} else {
    Write-Host "Pasta de destino já existe."
}

# Copiar apenas os arquivos essenciais (excluindo scripts, .git, etc.)
$exclude = @('deploy.ps1', '.git', '*.md')  # Arquivos a excluir

Write-Host "Copiando arquivos essenciais do $source para $destination"
Get-ChildItem -Path $source -Recurse -Exclude $exclude | 
    Copy-Item -Destination $destination -Recurse -Force

Write-Host "Arquivos essenciais copiados com sucesso."

# Cria o arquivo branch.txt com o nome da branch ativa
$branchFile = "$destination\branch.txt"
Write-Host "Criando o arquivo branch.txt com a branch: $gitBranch"
Set-Content -Path $branchFile -Value $gitBranch

# Mensagem final de sucesso
Write-Host "Branch '$gitBranch' copiada para a pasta de addons do WoW: $destination"