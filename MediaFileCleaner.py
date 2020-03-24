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

    rundir= input("What directory should this run against?(input w/ quotes): ")

    # Clean file and directory names, removing things like spaces a nd special characters
    def clean(dir):
        # os.rename(src, dst)
        def cleandirs(dir):
            pass
        def cleanfiles(dir):
            removedfiles = []

            # Recursively search from provided dir and remove all jpg's
            for rootdir, subdirs, filenames in os.walk(dir):
                for file in filenames:
                    if file.endswith('.jpg'):
                        try:
                            fpath = os.path.join(rootdir, file)
                            os.remove(fpath)
                            removedfiles.append(fpath)
                        except OSError:
                            print("File could not be deleted {0}".format(fpath))

            return removedfiles

        deleted = cleanfiles(rundir)
        print(deleted)

    # Removed sample files, artwork, and compressed files
    def samplefiles(dir):
        pass

    # Create a log of work completed 
    def logs(dir):
        pass

    clean(rundir)      


if __name__ == '__main__': 
    main()