# Script de Remoção Avançada do Anti-Cheat Delta Force
# Execute como Administrador no PowerShell

# Verifica se está rodando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Abra o PowerShell como Administrador e execute novamente." -ForegroundColor Yellow
    pause
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REMOVEDOR AVANÇADO DE ANTI-CHEAT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Lista de anti-cheats conhecidos
$antiCheats = @(
    @{Name="BattlEye"; Service="BEService"; Driver="BEDaisy.sys"},
    @{Name="EasyAntiCheat"; Service="EasyAntiCheat"; Driver="EasyAntiCheat.sys"},
    @{Name="EasyAntiCheat_EOS"; Service="EasyAntiCheat_EOS"; Driver="EasyAntiCheat_EOS.sys"},
    @{Name="Riot Vanguard"; Service="vgc"; Driver="vgc.sys"},
    @{Name="Riot Vanguard Kernel"; Service="vgk"; Driver="vgk.sys"},
    @{Name="ACE-Guard"; Service="ACE-Guard"; Driver="ACE-Guard.sys"},
    @{Name="nProtect GameGuard"; Service="npggsvc"; Driver="npggsvc.sys"}
)

# Função para parar e remover serviços
function Remove-AntiCheatService {
    param($ServiceName)
    
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($service) {
        Write-Host "Parando serviço: $ServiceName" -ForegroundColor Yellow
        Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        
        Write-Host "Removendo serviço: $ServiceName" -ForegroundColor Yellow
        sc.exe delete $ServiceName | Out-Null
    }
}

# Função para remover drivers
function Remove-AntiCheatDriver {
    param($DriverName)
    
    $driverPath = "$env:WINDIR\System32\drivers\$DriverName"
    if (Test-Path $driverPath) {
        Write-Host "Removendo driver: $DriverName" -ForegroundColor Yellow
        Remove-Item -Path $driverPath -Force -ErrorAction SilentlyContinue
    }
}

# 1. Para e remove serviços
Write-Host "[1/7] Removendo serviços..." -ForegroundColor Green
foreach ($ac in $antiCheats) {
    Remove-AntiCheatService -ServiceName $ac.Service
}

# 2. Remove drivers
Write-Host "`n[2/7] Removendo drivers..." -ForegroundColor Green
foreach ($ac in $antiCheats) {
    Remove-AntiCheatDriver -DriverName $ac.Driver
}

# 3. Lista de diretórios para remover
Write-Host "`n[3/7] Removendo diretórios do sistema..." -ForegroundColor Green
$directories = @(
    "$env:ProgramData\BattlEye",
    "$env:ProgramData\EasyAntiCheat",
    "$env:ProgramData\Riot Vanguard",
    "$env:ProgramData\ACE-Guard",
    "$env:ProgramData\GameGuard",
    "$env:ProgramFiles\BattlEye",
    "$env:ProgramFiles\EasyAntiCheat",
    "$env:ProgramFiles\Riot Vanguard",
    "$env:ProgramFiles\Common Files\EasyAntiCheat",
    "$env:ProgramFiles\Delta Force",
    "${env:ProgramFiles(x86)}\BattlEye",
    "${env:ProgramFiles(x86)}\EasyAntiCheat",
    "${env:ProgramFiles(x86)}\Common Files\EasyAntiCheat",
    "${env:ProgramFiles(x86)}\Delta Force",
    "$env:CommonProgramFiles\BattlEye",
    "$env:CommonProgramFiles\EasyAntiCheat",
    "$env:LOCALAPPDATA\BattlEye",
    "$env:LOCALAPPDATA\EasyAntiCheat",
    "$env:LOCALAPPDATA\ACE-Guard",
    "$env:APPDATA\EasyAntiCheat",
    "$env:APPDATA\ACE-Guard"
)

foreach ($dir in $directories) {
    if (Test-Path $dir) {
        Write-Host "Removendo: $dir" -ForegroundColor Yellow
        Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 4. Limpa registro
Write-Host "`n[4/7] Limpando entradas do registro..." -ForegroundColor Green
$registryKeys = @(
    "HKLM:\SYSTEM\CurrentControlSet\Services\BEService",
    "HKLM:\SYSTEM\CurrentControlSet\Services\EasyAntiCheat",
    "HKLM:\SYSTEM\CurrentControlSet\Services\vgc",
    "HKLM:\SYSTEM\CurrentControlSet\Services\vgk",
    "HKLM:\SOFTWARE\BattlEye",
    "HKLM:\SOFTWARE\EasyAntiCheat",
    "HKLM:\SOFTWARE\Wow6432Node\BattlEye",
    "HKLM:\SOFTWARE\Wow6432Node\EasyAntiCheat",
    "HKCU:\SOFTWARE\BattlEye",
    "HKCU:\SOFTWARE\EasyAntiCheat"
)

foreach ($key in $registryKeys) {
    if (Test-Path $key) {
        Write-Host "Removendo chave: $key" -ForegroundColor Yellow
        Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 5. Procura e remove processos em execução
Write-Host "`n[5/7] Verificando processos em execução..." -ForegroundColor Green
$processes = @("BEService", "EasyAntiCheat", "EasyAntiCheat_EOS", "vgtray", "vgc", "vgk", "ACE-Guard", "GameMon", "GameGuard")
foreach ($proc in $processes) {
    $runningProc = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($runningProc) {
        Write-Host "Encerrando processo: $proc" -ForegroundColor Yellow
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
    }
}

# 6. Limpa arquivos temporários
Write-Host "`n[6/7] Limpando arquivos temporários..." -ForegroundColor Green
$tempPatterns = @("*battleye*", "*easyanticheat*", "*eac*", "*vanguard*")
foreach ($pattern in $tempPatterns) {
    Get-ChildItem -Path $env:TEMP -Filter $pattern -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

# 7. Verificação final
Write-Host "`n[7/7] Realizando verificação final..." -ForegroundColor Green
$remainingServices = @()
foreach ($ac in $antiCheats) {
    if (Get-Service -Name $ac.Service -ErrorAction SilentlyContinue) {
        $remainingServices += $ac.Service
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  LIMPEZA CONCLUÍDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

if ($remainingServices.Count -gt 0) {
    Write-Host "`nAVISO: Os seguintes serviços ainda estão presentes:" -ForegroundColor Yellow
    $remainingServices | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
    Write-Host "`nPode ser necessário reiniciar em Modo de Segurança para removê-los completamente." -ForegroundColor Yellow
}

Write-Host "`nRecomendações:" -ForegroundColor Cyan
Write-Host "1. Reinicie o computador" -ForegroundColor White
Write-Host "2. Execute 'sfc /scannow' para verificar integridade do sistema" -ForegroundColor White
Write-Host "3. Use o Limpador de Disco do Windows" -ForegroundColor White
Write-Host "4. Verifique o Gerenciador de Dispositivos por drivers ocultos" -ForegroundColor White

Write-Host "`nPressione Enter para sair..." -ForegroundColor Gray
Read-Host
