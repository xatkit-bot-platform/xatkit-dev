#!/bin/bash


runthis() {
	echo "$@"
	eval $@
}

jars=$(find .. -follow \( -name '*.jar' \))
echo 'Xatkit classpath:'
java_classpath=''
for jar in $jars
	do
		echo $jar
		java_classpath="$java_classpath:$jar"
	done

# Remove the leading ';'
java_classpath="${java_classpath:1}"

runthis "java -cp '$java_classpath' com.xatkit.Xatkit '$1'"


