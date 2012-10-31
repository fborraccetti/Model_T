#!/bin/bash

table="$1"
source config.sh

if [[ -z "$1" ]]
	then
	echo "Usage: `basename $0` <table_name>"
	exit 1
fi

echo "" > "$( echo $table | tr "[:upper:]" "[:lower:]" )"_m.php

# Dichiara la classe
sed -e "s/Classe1/$table/g" < templates/class_declaration > 1_"$table"

# Dichiara i metodi set
cat templates/function_set_declaration > 3_"$table"	

# Dichiara i metodi get
cat templates/function_get_declaration > 4_"$table"

# Dichiara il metodi update
cat templates/function_update_declaration > 5_"$table"	

columns=$( mysql -u "$mysql_user" -p"$mysql_password" --skip-column-names --raw -e "show columns from $table" "$mysql_db"  | cut -f1 )


for column in $columns
	do 
	#echo $column
	# Dichiara le variabili
	sed -e "s/variabile1/$column/g" < templates/var_declaration >> 2_"$table"

	# Setta gli if delle colonne per funzione get
	sed -e "s/colonna1/$column/g" < templates/if_isset >> 4_"$table" 
	# Setta gli if delle colonne per funzione update
	sed -e "s/colonna1/$column/g" < templates/if_isset >> 5_"$table" 
done

# Close method set
sed -e "s/tabella1/$table/g" templates/function_set_close >> 3_"$table"	
sed -e "s/tabella1/$table/g" templates/function_get_close >> 4_"$table"	
sed -e "s/tabella1/$table/g" templates/function_update_close >> 5_"$table"	

# Chiude la classe
sed -e "s/tabella1/$table/g" templates/class_close > 6_"$table"

# Crea il file definitivo
for ((i=1; i<7; i++))
	do
	cat "$i"_"$table" >> "$table"_m.php
	rm -f "$i"_"$table"
done
