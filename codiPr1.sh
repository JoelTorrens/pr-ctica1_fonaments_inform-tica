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
#!/bin/bash
# Escriure la capçalera amb les noves columnes Rlikes i Rdislikes
head -n 1 superviventsModificat31.csv | cut -d',' -f1-14 | awk -F, '{print $0",Rlikes,Rdislikes"}' > superviventsModificat4.csv

echo $tit",Ranking_views,Rlikes,Rdilikes" > superviventsModificat4.csv
 

# Processar cada línia del fitxer (a partir de la segona línia)
tail -n +2 "$superviventsModificat31.csv" | while read -r linia; do
    # Extreure les columnes necessàries
    views=$(echo "$linia" | cut -d',' -f8)
    likes=$(echo "$linia" | cut -d',' -f9)
    dislikes=$(echo "$linia" | cut -d',' -f10)

    
    Rlikes=($likes * 100) / $views
    Rdislikes=($dislikes * 100) / $views
   

    # Escriure la línia original més les noves columnes al fitxer de sortida
    echo "$linia,$Rlikes,$Rdislikes" > "$superviventsModificat4.csv"
done

