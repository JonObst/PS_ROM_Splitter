# Define the input file and output files
$inputFile = "C:\Users\jonob\Desktop\Macintosh II.ROM"  # Replace with your input file
$outputFiles = "file1.bin", "file2.bin", "file3.bin", "file4.bin"

# Create output files if they do not exist
foreach ($file in $outputFiles) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file
    }
}

# Open the input file for reading
$fsInput = [System.IO.File]::Open($inputFile, 'Open', 'Read')

try {
    # Initialize byte counter
    $byteCount = 0
    $buffer = New-Object byte[] 1  # Buffer for one byte

    while ($fsInput.Read($buffer, 0, 1) -eq 1) {
        # Determine which output file to use
        $outputIndex = $byteCount % 4

        # Open the output file in append mode
        $fsOutput = New-Object System.IO.FileStream($outputFiles[$outputIndex], [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write)

        try {
            # Write the byte to the output file
            $fsOutput.Write($buffer, 0, 1)
        } finally {
            # Always close the output file stream
            $fsOutput.Close()
        }

        $byteCount++
    }
} finally {
    # Always close the input file stream
    $fsInput.Close()
}

Write-Host "File split into four files successfully."