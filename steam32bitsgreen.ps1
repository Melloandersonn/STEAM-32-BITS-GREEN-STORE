#Requires -Version 5.1

# =========================
# CLEAN MODE (remove barras azuis internas)
# =========================
$global:ProgressPreference = 'SilentlyContinue'   # mata "Gravando solicitação na Web", progress de comandos, etc.
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host

# =========================
# UI (barra + %)
# =========================
$script:Steps = @(
    "Etapa 1/5 - Preparando",
    "Etapa 2/5 - Executando ação A",
    "Etapa 3/5 - Executando ação B",
    "Etapa 4/5 - Aplicando configurações",
    "Etapa 5/5 - Finalizando"
)
$script:StepIndex = 0
$script:TotalSteps = $script:Steps.Count

function Set-Step {
    param([string]$Message)

    $script:StepIndex++
    if ($script:StepIndex -gt $script:TotalSteps) { $script:StepIndex = $script:TotalSteps }

    $percent = [int](($script:StepIndex / $script:TotalSteps) * 100)

    # Somente sua barra (sem azul automático)
    Write-Progress -Activity "GREEN STORE – Progresso" -Status "$Message ($percent%)" -PercentComplete $percent
}

function Stop-OnError {
    param([string]$Message)

    Write-Progress -Activity "GREEN STORE – Progresso" -Completed
    Write-Host ""
    Write-Host "ERRO: $Message" -ForegroundColor Red
    exit 1
}

function Done {
    Write-Progress -Activity "GREEN STORE – Progresso" -Completed
    Write-Host ""
    Write-Host "✔ Processo concluído com sucesso!" -ForegroundColor Green
}

# Helper: executa um bloco sem qualquer progress interno
function Invoke-Clean {
    param([scriptblock]$Block)

    $old = $global:ProgressPreference
    try {
        $global:ProgressPreference = 'SilentlyContinue'
        & $Block
    } finally {
        $global:ProgressPreference = $old
    }
}

# =========================
# EXECUÇÃO (coloque suas ações aqui)
# =========================
try {
    Set-Step $script:Steps[0]
    Invoke-Clean {
        Start-Sleep -Milliseconds 700
        # >>> COLOQUE AQUI sua lógica da Etapa 1
    }

    Set-Step $script:Steps[1]
    Invoke-Clean {
        Start-Sleep -Milliseconds 900
        # >>> COLOQUE AQUI sua lógica da Etapa 2
    }

    Set-Step $script:Steps[2]
    Invoke-Clean {
        Start-Sleep -Milliseconds 900
        # >>> COLOQUE AQUI sua lógica da Etapa 3
    }

    Set-Step $script:Steps[3]
    Invoke-Clean {
        Start-Sleep -Milliseconds 700
        # >>> COLOQUE AQUI sua lógica da Etapa 4
    }

    Set-Step $script:Steps[4]
    Invoke-Clean {
        Start-Sleep -Milliseconds 500
        # >>> COLOQUE AQUI sua lógica da Etapa 5
    }

    Done
}
catch {
    Stop-OnError $_.Exception.Message
}
