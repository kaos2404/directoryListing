rm -f permSet.sh
rm -f dirStruc.txt
permCheck(){
        ls -L $1 > permSetTemp.$2
        local count=0
        local appender=""
        while [ $2 -gt $count ]
        do
                appender="|--- "$appender
                count=`expr $count + 1`
        done
        while read line
        do
                local file=$1$line
                local perms=`stat -c "%a %n" $file | awk '{print \$1}'`
                if [[ $line != "permSet"* ]]
                then
						echo $appender$line" { $perms } " >> dirStruc.txt
                        if [ -d $file ]
                        then
                                permCheck $file"/" `expr $2 + 1`
                        fi
                        echo "chmod "$perms" "$file"" >> permSet.sh
                fi
        done < permSetTemp.$2
        rm -f permSetTemp.$2
}

permCheck $1 0	