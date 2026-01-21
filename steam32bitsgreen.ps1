#Requires -Version 5.1

# Desativa qualquer progresso interno do PowerShell (remove barras azuis)
$global:ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear-Host

# ===============================
# CONFIGURAÇÃO DA BARRA
# ===============================

$Steps = @(
    "Detectando sistema",
    "Preparando ambiente",
    "Processando arquivos",
    "Aplicando configurações",
    "Finalizando"
)

$Current = 0
$Total = $Steps.Count

function Draw-UI {
    param([int]$Index)

    Clear-Host
    Write-Host ""
    Write-Host "┌────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "│         INSTALADOR - PROGRESS       │" -ForegroundColor Green
    Write-Host "├────────────────────────────────────┤" -ForegroundColor DarkGreen

    for ($i = 0; $i -lt $Steps.Count; $i++) {
        if ($i -lt $Index) {
            Write-Host ("│ [OK]  {0}" -f $Steps[$i]).PadRight(36) "│" -ForegroundColor Green
        }
        elseif ($i -eq $Index) {
            Write-Host ("│ [>>]  {0}" -f $Steps[$i]).PadRight(36) "│" -ForegroundColor Yellow
        }
        else {
            Write-Host ("│ [..]  {0}" -f $Steps[$i]).PadRight(36) "│" -ForegroundColor DarkGray
        }
    }

    Write-Host "├────────────────────────────────────┤" -ForegroundColor DarkGreen

    $percent = [int](($Index / $Total) * 100)
    $barSize = 30
    $filled = [int](($percent / 100) * $barSize)
    $bar = ("█" * $filled).PadRight($barSize, '░')

    Write-Host ("│ {0} {1}%".PadRight(36) -f $bar, $percent) "│" -ForegroundColor Cyan
    Write-Host "└────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
}

function Next-Step {
    $script:Current++
    Draw-UI $script:Current
}

# ===============================
# EXECUÇÃO EXEMPLO
# ===============================

Draw-UI 0
Start-Sleep 1

foreach ($step in $Steps) {
    # Simula trabalho real
    Start-Sleep 1.2
    Next-Step
}

Write-Host ""
Write-Host "✔ Processo finalizado com sucesso!" -ForegroundColor Green
