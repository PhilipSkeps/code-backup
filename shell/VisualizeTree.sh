#!/bin/bash

tree=$(dir)
TreeBuilder()
#Builds the directory using tabs as seperators
#for the limbs of the tree

{
if [ $file == "toppar_all36_na_modifications.str" ]; then
	echo $PWD
fi
if [ -d "$file" ]; then
	tab=$tab"   "
	cd $file
	tree=$(dir)
	DirectoryEngine
	tab=${tab%"   "}
	cd ..
fi 
}

DirectoryEngine() 
#Continuos for loop allowing for all the limbs
#of the tree to be printed 

{
for file in $tree; do
	echo -e "$tab$file"
	TreeBuilder
done
}

if [ -z "$tree" ]; then
   	echo Cannot Visualize an empty Directory
else
	DirectoryEngine
fi

