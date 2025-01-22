masscanlogger

A wrapper for masscan to ensure output even if no open ports are found. Requires masscan.

Authors:  
James Gallagher  
ChatGPT :D

Usage: masscanlogger [options]

Options:  
-m, --masscan-command-file <file>    Masscan command file  
                                     Example masscan command file contents: ./masscan 127.0.0.1 -p 80  
                                     The file should contain the masscan command you wish to run, including the target(s) and port(s), etc.  
                                       
-o, --output-file <file>             Output file to store results  
  
--help                               Show this help message
    
Note: masscanlogger does not support masscan output files (e.g., -oX, -oG, -oL, -oJ, --output-filename). Use masscanlogger's own output file feature instead.
