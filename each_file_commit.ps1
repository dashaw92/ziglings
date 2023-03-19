Function IsGitRepo {
    $test = $(git status 2>&1 $null).ToString()
    return -Not $test.StartsWith("fatal: not a git repository")
}

Function CollectDirty {
    return $(git status -s) -Split "\n" | ForEach-Object { $_.Substring(3) }
}

Function CommitFile([String] $file) {
    git add $file
    git commit -m "Auto: $file"
}

If (-Not (IsGitRepo)) {
    Write-Host -Foreground DarkRed "Fatal: Not a git repository."
    return
}

CollectDirty | % { CommitFile $_ }