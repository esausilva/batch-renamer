# batch-renamer

> Simple cli script that renames files in bulk. 

"I have more than 500 files that need to be renamed, but I am too lazy to do it manually, so I wrote this script to do it for me. :muscle:"

All of the files follow specific patterns in the name, let's say we have the following pattern `Name of Show – Episode Title` or `Name of Show – 1x01 – Episode Title`

Looking at the pattern above, I wanted to get rid of the first part of the filename up to the dash (-) since I have the files in different directories according to show name, so the name of the show in the filename is not needed. Ultimately I want to end up with `S1E01 - Epsiode Title`.

## Usage

``` bash
$ ./rename-1.0.sh "/Users/esilva/Show"
```
**Note**: You must provide the script with an absolute path as input and omit the last forward-slash (/).

Configuration variables in lines 16 and 17 are required and configuration variable in line 18 is optional.

``` bash
16 strToSearch="The Beverly Hillbillies"
17 strToMatch="Hillbillies-"
18 replaceChar="1x"
```

 * `strToSearch` this variable will be used to match the files in the given directory.

 * `strToMatch` this variable can serve for different purposes. By default (see line 58) the script will delete all the characters in the filename up to this (`strToMatch`) point.
 
**Example 1:** 

Configuration variables as below

``` bash
strToSearch="The Beverly Hillbillies"
strToMatch="Hillbillies-"
replaceChar=""
```

Will match `The Beverly Hillbillies-1x01 - The Clampetts Strike Oil.avi`, and the resulting renamed filename after script executes `1x01 - The Clampetts Strike Oil.avi`

**Example 2**

There is another use for `strToMatch` configuration variable, instead of replacing everything up to this variable (as in *Example 1*), by commenting out line 58 and uncommenting out line 61 we can just replace `strToMatch` to whatever new name we want.

Below I have line 61 which will replace `strToMatch` to `TBH`

``` bash
61 newFName=$(echo "$oldFName" | sed 's:'$strToMatch':TBH:') 
```

giving us from original filename `The Beverly Hillbillies-1x01 - The Clampetts Strike Oil.avi` to new filename `TBH-1x01 - The Clampetts Strike Oil.avi`.

*Note*: Make sure to change this part `TBH` in line 61 to whatever is it you are wanting to change.

**Example 3**

We want to replace `1x01` in the original filename (`The Beverly Hillbillies-1x01 - The Clampetts Strike Oil.avi`) to `S1E01`, then we can use the optional configuration variable in line 18. So we have the configuration as follows

``` bash
strToSearch="The Beverly Hillbillies"
strToMatch="Hillbillies-"
replaceChar="1x"
```

Now, `replaceChar` works in unison with lines 63 to 65 (below)

``` bash
63 if [[ "$replaceChar" != "" ]]; then
64     newFName=$(echo "$newFName" | sed 's:'$replaceChar':S01E:' )
65 fi
```

If you notice, I make use of the stream editor `sed` to replace whatever is in `replaceChar` to `S01E`.

So after the script runs we will get from original filename `The Beverly Hillbillies-1x01 - The Clampetts Strike Oil.avi` to new filename `S01E01 - The Clampetts Strike Oil.avi`.

*Note*: Make sure to change this part `S01E` in line 64 to whatever is it you are wanting to change.
 
## Important

Line 74 (below) does the actual renaming. In the script I have it commented out just in case it is run by accident, just uncomment it whenever you are ready to actually run the script.

``` bash
74 mv "$oldFName" "$newFName"
```

## The Log File

Below is an example of what will be logged. Basically is the `mv` command, first part is the original filename and second part is the new filename.

``` text
*** Tue Mar 14 20:21:14 CDT 2017 ***
/Users/esilva/Show
mv The Beverly Hillbillies-1x01 - The Clampetts Strike Oil.avi S01E01 - The Clampetts Strike Oil.avi
mv The Beverly Hillbillies-1x02 - Getting Settled.avi S01E02 - Getting Settled.avi
mv The Beverly Hillbillies-1x03 - Meanwhile, Back At The Cabin.avi S01E03 - Meanwhile, Back At The Cabin.avi
mv The Beverly Hillbillies-1x04 - The Clampetts Meet Mrs. Drysdale.avi S01E04 - The Clampetts Meet Mrs. Drysdale.avi
mv The Beverly Hillbillies-1x05 - Jed Buys Stock.avi S01E05 - Jed Buys Stock.avi
```

## More Notes

You can make as many replacements as you want in a single line. 

I have done the following many times to make multiple character renaming in a single pass. :smile:

``` bash
newFName=$(echo "$newFName" | sed 's:\.DVDrip\.XviD-Sporc::' | sed 's:'$replaceChar':-:' | sed 's:'$replaceChar': :g' | sed 's: avi$:\.avi:')
```

## Disclaimer

I have to issue a warning. Before running this script, make sure you know what you are doing as this can give you undesired results. Please run the script first with line 74 commented and look at the log file (which will be created in the same directory as the script), this will tell you exactly what it did, and if you are satisfied, then go ahead and uncomment line 74 to do the actual renaming.

-Esau
