#! /usr/bin/python
##
# Built to rename files and directories in a clean mannor
# Removes extras, .jpg, sample files, .tar, .zip
##

import os
import json

def main():

    # Get directory this script should run against
    print("\nThis script will rename files and directories to remove annoyingly placed special characters and spaces.")
    print("Once renaming is complete, it will remove any sample files and jpegs.")
    print("Specific results of work completed will output to ./fileCleanerResults.json\n")

    rundir = input("What directory should this run against?(input w/ quotes): ")

    # Clean file and directory names, removing things like spaces a nd special characters
    def clean(dir):
        # os.rename(src, dst)

        cleaned_dirs_lst = []

        def cleandirs(start_dir):
            for rootdir, subdirs, files in os.walk(start_dir):
                for sdir in subdirs:
                    if (".") in sdir:
                        cleaned_dirs_lst.append(sdir)
                    dirs = os.path.join(rootdir,sdir)
                    #print(dirs)

            return cleaned_dirs_lst

        def cleanfiles(start_dir):
            pass
            #for rootdir, subdirs, files in os.walk(dir):
            #    for file in files:
            #        if file.endswith(extensions):
            #            try:
            #                fpath = os.path.join(rootdir, file)
            #                os.remove(fpath)
            #                removedfiles.append(fpath)
            #            except OSError:
            #                print("Surplus file could not be deleted {0}".format(fpath))

        cleaned_dirs = cleandirs(dir)
        cleaned_files = cleanfiles(dir)

        return cleaned_dirs, cleaned_files

    # Removed sample files, artwork, and compressed files
    def purgefiles(dir):
        removedfiles = []
        # List of extensions to remove
        extensions = ('.jpg', '.rar', '.tar', '.tz', '.tgz', '.zip')

        # Recursively search from provided dir and remove all non media files.
        for rootdir, subdirs, files in os.walk(dir):
            for file in files:
                if file.endswith(extensions):
                    try:
                        fpath = os.path.join(rootdir, file)
                        os.remove(fpath)
                        removedfiles.append(fpath)
                    except OSError:
                        print("Surplus file could not be deleted {0}".format(fpath))

        return removedfiles # End surplusfiles()
        

    # Create a log of work completed 
    def logs(dir):
        pass

    cleaned_directories, cleaned_files = clean(rundir)

    purged_list = json.dumps(purgefiles(rundir), indent=2)

    print('"Cleaned Directories:" {0}, "Cleaned Files: {1}", "Purged Files: {2}'.format(cleaned_directories, cleaned_files, purged_list))

if __name__ == '__main__': 
    main()