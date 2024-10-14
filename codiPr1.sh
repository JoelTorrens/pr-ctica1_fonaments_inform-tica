#!
#!/bin/bash
#1
cut -d',' -f1-11,13-15 supervivents.csv > superviventsModificat1.csv
tit=$(head -n 1 superviventsModificat1.csv)

#2
awk -F',' '$14 != "True"' "superviventsModificat1.csv" > "superviventsModificat2.csv"
eliminats=$(awk -F',' '$14 == "True"' "superviventsModificat1.csv" | wc -l)               
echo "S'han eliminat $eliminats registres amb errors o vídeos esborrats."

#3
awk -F',' '{
    # Classificar en funció de la columna 8 (visualitzacions)
    if ($8 <= 1000000)
        ranking="bo";
    else if ($8 > 10000000)
        ranking="excel·lent";
    else
        ranking="estrella";

    # Imprimir totes les columnes originals i la nova columna 'Ranking_Views'
    print $0 "," ranking;
}' OFS=',' "superviventsModificat2.csv" > "superviventsModificat3.csv"

#4
# Escriure la capçalera amb les noves columnes Rlikes i Rdislikes
head -n 1 superviventsModificat31.csv | cut -d',' -f1-15git | awk -F, '{print $0",Rlikes,Rdislikes"}' > superviventsModificat4.csv

nano relacions.sh

#!/bin/bash
tail -n +2 superviventsModificat31.csv | while IFS= read -r line; do

    # Utilitzar cut per extreure les columnes necessàries
    video_id=$(echo "$line" | cut -d',' -f1)
    trending_date=$(echo "$line" | cut -d',' -f2)
    title=$(echo "$line" | cut -d',' -f3)
    channel_title=$(echo "$line" | cut -d',' -f4)
    category_id=$(echo "$line" | cut -d',' -f5)
    publish_time=$(echo "$line" | cut -d',' -f6)
    tags=$(echo "$line" | cut -d',' -f7)
    views=$(echo "$line" | cut -d',' -f8)
    likes=$(echo "$line" | cut -d',' -f9)
    dislikes=$(echo "$line" | cut -d',' -f10)
    comment_count=$(echo "$line" | cut -d',' -f11)
    comments_disabled=$(echo "$line" | cut -d',' -f12)
    ratings_disabled=$(echo "$line" | cut -d',' -f13)
    video_error_or_removed=$(echo "$line" | cut -d',' -f14)
    ranking=$(echo "$line" | cut -d',' -f15)

    if [ "$views" -lt 1 ]; then
        Rlikes=0
        Rdislikes=0
    else
        # Calcular Rlikes i Rdislikes
       Rlikes=$(( (likes * 100) / views ))
       Rdislikes=$(( (dislikes * 100) / views ))
    fi

    # Escriure la línia original amb les noves columnes calculades al fitxer de sortida
    echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$comments_disabled,$ratings_disabled,$video_error_or_removed,$ranking,$Rlikes,$Rdislikes" >> superviventsModificat4.csv

done

chmod +x relacions.sh
./relacions.sh


#5
nano ex5.sh

#!/bin/bash

echo "Introdueix com a paràmetre d'entrada l'id del vídeo o el seu títol: "
read parametre

# Buscar coincidències del paràmetre a l'arxiu superviventsModificat4.csv
match=$(grep -i "$parametre" superviventsModificat4.csv)

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


chmod +x ex5.sh
./ex5.sh