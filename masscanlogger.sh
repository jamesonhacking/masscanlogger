#!/bin/bash

print_usage() {
    echo "masscan v1.0"
    echo
    echo "Authors:"
    echo "James Gallagher"
    echo "ChatGPT :D"
    echo
    echo "A wrapper for masscan to handle logging and ensure output even if no open ports are found. Requires masscan."
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -m, --masscan-command-file  <file>  Masscan command file"
    echo "       Example masscan command file contents: ./masscan 127.0.0.1 -p 80"
    echo "       The file should contain the masscan command you wish to run, including the target IP(s)/CIDR(s) and ports."
    echo "  -o, --output-file           <file>  Output file to store results"
    echo "  --help                      Show this help message"
    echo
    echo "Note: masscanlogger does not support masscan output files (e.g., -oX, -oG, -oL, -oJ, --output-filename). Please use masscanlogger's own output file feature."
    exit 1
}

# Check for --help
if [[ "$1" == "--help" || "$#" -lt 2 ]]; then
    print_usage
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --masscan-command-file|-m)
            MASSCAN_COMMAND_FILE="$2"
            shift 2
            ;;
        --output-file|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            print_usage
            ;;
    esac
done

# Validate arguments
if [[ -z "$MASSCAN_COMMAND_FILE" || -z "$OUTPUT_FILE" ]]; then
    print_usage
fi

# Read Masscan command
if [[ ! -f "$MASSCAN_COMMAND_FILE" ]]; then
    echo "Error: Masscan command file '$MASSCAN_COMMAND_FILE' not found."
    exit 1
fi

MASSCAN_COMMAND=$(cat "$MASSCAN_COMMAND_FILE")

# Check for masscan output file switches (like -oX, -oG, -oL, -oJ, --output-filename)
if [[ "$MASSCAN_COMMAND" =~ -o[XGJL] || "$MASSCAN_COMMAND" =~ --output-filename ]]; then
    echo "Error: masscanlogger does not support masscan output files (e.g., -oX, -oG, -oL, -oJ, --output-filename). Please use masscanlogger's own output file feature."
    exit 1
fi

# Prepare output
{
    echo "masscanlogger output log"
    echo
    echo "Script started: $(date -u)"
    echo
    echo "Network interface information:"
    ifconfig
    echo "Routing information:"
    route -n
    echo

    echo "Masscan command: $MASSCAN_COMMAND"
    echo

    # Run masscan and capture output
    echo "Scan results:"
    OUTPUT=$(eval "$MASSCAN_COMMAND")

    if [[ -z "$OUTPUT" ]]; then
        echo "NO OPEN PORTS FOUND."
    else
        echo "$OUTPUT"
    fi

    echo
    echo "Script ended: $(date -u)"
} | tee "$OUTPUT_FILE"
