# functions/kubectl.ps1

function kns {
    param([string]$Namespace)
    if (-not $Namespace) {
        kubectl config view --minify -o jsonpath='{..namespace}'
        return
    }
    kubectl config set-context --current --namespace=$Namespace
}

function kgp {
    param(
        [string]$Namespace,
        [switch]$Watch,
        [switch]$Wide
    )
    $argsList = @("get", "pods")
    if ($Namespace) { $argsList += @("-n", $Namespace) }
    if ($Watch)      { $argsList += "-w" }
    if ($Wide)        { $argsList += "-o"; $argsList += "wide" }

    kubectl @argsList
}

function kl {
    param(
        [Parameter(Mandatory = $true)][string]$Pod,
        [string]$Container,
        [string]$Namespace,
        [switch]$Follow,
        [int]$Tail = 500,
        [switch]$Previous
    )
    $argsList = @("logs", $Pod)
    if ($Container)  { $argsList += @("-c", $Container) }
    if ($Namespace)  { $argsList += @("-n", $Namespace) }
    if ($Follow)      { $argsList += "-f" }
    if ($Previous)    { $argsList += "-p" }
    $argsList += @("--tail", $Tail)

    kubectl @argsList
}