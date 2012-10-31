#!/bin/bash

table="$1"
source config.sh

if [[ -z "$1" ]]
	then
	echo "Usage: `basename $0` <table_name>"
	exit 1
fi

filename=$( echo $table | tr "[:upper:]" "[:lower:]" );

echo "" > "$filename"_m.php

# Dichiara la classe
sed -e "s/Classe1/$table/g" < templates/class_declaration > 1_"$filename"

# Dichiara i metodi set
cat templates/function_set_declaration > 3_"$filename"	

# Dichiara i metodi get
cat templates/function_get_declaration > 4_"$filename"

# Dichiara il metodi update
cat templates/function_update_declaration > 5_"$filename"	

columns=$( mysql -u "$mysql_user" -p"$mysql_password" --skip-column-names --raw -e "show columns from $table" "$mysql_db"  | cut -f1 )


for column in $columns
	do 
	#echo $column
	# Dichiara le variabili
	sed -e "s/variabile1/$column/g" < templates/var_declaration >> 2_"$filename"

	# Setta gli if delle colonne per funzione get
	sed -e "s/colonna1/$column/g" < templates/if_isset >> 4_"$filename" 
	# Setta gli if delle colonne per funzione update
	sed -e "s/colonna1/$column/g" < templates/if_isset >> 5_"$filename" 
done

# Close method set
sed -e "s/tabella1/$table/g" templates/function_set_close >> 3_"$filename"	
sed -e "s/tabella1/$table/g" templates/function_get_close >> 4_"$filename"	
sed -e "s/tabella1/$table/g" templates/function_update_close >> 5_"$filename"	

# Chiude la classe
sed -e "s/tabella1/$table/g" templates/class_close > 6_"$filename"

# Crea il file definitivo
for ((i=1; i<7; i++))
	do
	cat "$i"_"$filename" >> "$filename"_m.php
	rm -f "$i"_"$filename"
done
