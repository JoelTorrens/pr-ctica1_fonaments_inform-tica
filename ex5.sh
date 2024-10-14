#!/bin/bash

echo "Introdueix com a paràmetre d'entrada l'id del vídeo o el seu títol: "
read parametre

# Buscar coincidències a superviventsModificat4.csv a les columes $1 (video_id) i $3 (title)
match=$(grep -i "$parametre" superviventsModificat4.csv | awk -F',' '$1 ~ /'"$parametre"'/ || $3 ~ /'"$parametre"'/')

if [ -n "$match" ]; then
    # Si s'ha trobat una coincidència, mostrar els camps requerits
    # Processar la línia coincident
    echo "$match" | while IFS= read -r line; do
        # Utilitzar cut per extreure les columnes necessàries
	title=$(echo "$line" | cut -d',' -f3)
        publish_time=$(echo "$line" | cut -d',' -f6)
        views=$(echo "$line" | cut -d',' -f8)
        likes=$(echo "$line" | cut -d',' -f9)
        dislikes=$(echo "$line" | cut -d',' -f10)
        Ranking_Views=$(echo "$line" | cut -d',' -f15)
        Rlikes=$(echo "$line" | cut -d',' -f16)
        Rdislikes=$(echo "$line" | cut -d',' -f17)

        # Mostrar els camps en format llegible
	echo "Title: $title"
        echo "Publish time: $publish_time"
        echo "Views: $views"
        echo "Likes: $likes"
        echo "Dislikes: $dislikes"
        echo "Ranking Views: $Ranking_Views"
        echo "Rlikes: $Rlikes"
        echo "Rdislikes: $Rdislikes"
        echo ""
    done
else
    # Si no s'han trobat coincidències
    echo "ERROR: '$parametre' NOT FOUND"
fi

