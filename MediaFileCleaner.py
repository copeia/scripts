#! /usr/bin/python
##
# Built to rename files and directories in a clean mannor
# Removes extras, .jpg, sample files, .tar, .zip
##

import os

def main():

    # Get directory this script should run against
    print("\nThis script will rename files and directories to remove annoyingly placed special characters and spaces.")
    print("Once renaming is complete, it will remove any sample files and jpegs.")
    print("Specific results of work completed will output to ./fileCleanerResults.json\n")

    rundir = str(input("What directory should this run against?: "))

    # Clean file and directory names, removing things like spaces a nd special characters
    def clean(rundir):
        # os.rename(src, dst)
        def cleandirs(rundir):
            pass
        def cleanfiles(rundir):
            pass

    # Removed sample files, artwork, and compressed files
    def samplefiles(rundir):
        pass

    # Create a log of work completed 
    def logs(rundir):
        pass




if __name__ == '__main__': 
    main()