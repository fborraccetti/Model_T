#!/bin/bash

table="$1"

source config.sh

if [[ -z "$1" ]]
	then
	echo "Usage: `basename $0` <table_name>"
	exit 1
fi

echo "" > "$table"_m.php

# Dichiara la classe
sed -e "s/Classe1/$table/g" < templates/class_declaration_template > 1_"$table"

# Dichiara i metodi get e set
cat templates/function_declaration_template > 3_"$table"	

# Dichiara il metodi update
cat templates/update_declaration_template > 5_"$table"	


# Chiude la classe
sed -e "s/tabella1/$table/g" templates/class_close_template > 6_"$table"

columns=$( mysql -u "$mysql_user" -p"$mysql_password" --skip-column-names --raw -e "show columns from $table" "$mysql_db"  | cut -f1 )


for column in $columns
	do 
	echo $column
	# Dichiara le variabili
	sed -e "s/variabile1/$column/g" < templates/var_declaration_template >> 2_"$table"

	# Setta gli if delle colonne
	sed -e "s/colonna1/$column/g" < templates/if_isset_template >> 4_"$table" 
	sed -e "s/colonna1/$column/g" < templates/if_isset_template >> 5_"$table" 
done

cat templates/close_update_declaration >> 5_"$table"

# Crea il file definitivo
for ((i=1; i<7; i++))
	do
	cat "$i"_"$table" >> "$table"_m.php
	rm -f "$i"_"$table"
done
