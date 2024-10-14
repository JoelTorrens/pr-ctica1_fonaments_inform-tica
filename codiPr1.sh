   #!
    #!/bin/bash

if [ $# -eq 0 ]; then
    #1
    cut -d',' -f1-11,13-15 supervivents.csv > superviventsModificat1.csv
    echo "ex 1 complert"

    #2
    awk -F',' '$14 != "True"' "superviventsModificat1.csv" > "superviventsModificat2.csv"
    eliminats=$(awk -F',' '$14 == "True"' "superviventsModificat1.csv" | wc -l)               
    echo "S'han eliminat $eliminats registres amb errors o vídeos esborrats."
    echo "ex 2 complert"

    #3
    awk -F',' 'NR==1 {print $0 ",Ranking_Views"; next}
    {
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
    echo "ex 3 complert"

    #4
    # Escriure la capçalera amb les noves columnes Rlikes i Rdislikes
    head -n 1 superviventsModificat3.csv | cut -d',' -f1-15 | awk -F, '{print $0",Rlikes,Rdislikes"}' > superviventsModificat4.csv
    
    #Escriure la resta de files
    tail -n +2 superviventsModificat3.csv | while IFS= read -r line; do

    # Utilitzar cut per extreure les columnes necessàries
        views=$(echo "$line" | cut -d',' -f8)
        likes=$(echo "$line" | cut -d',' -f9)
        dislikes=$(echo "$line" | cut -d',' -f10)

        if [ "$views" -lt 1 ]; then
            Rlikes=0
            Rdislikes=0
        else
            # Calcular Rlikes i Rdislikes
            Rlikes=$(( (likes * 100) / views ))
            Rdislikes=$(( (dislikes * 100) / views ))
        fi

        # Escriure la línia original amb les noves columnes calculades al fitxer de sortida
        echo "$line,$Rlikes,$Rdislikes" >> superviventsModificat4.csv

    done
    echo "ex 4 complert"
    

else

    #5
    #si el fitxer superviventsModificat4 no existeix
    if [ ! -f "superviventsModificat4.csv" ]; then
        echo "ERROR: L'arxiu superviventsModificat4.csv no existeix."
        exit 1
    else

        parametre=$1

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
    fi

fi



