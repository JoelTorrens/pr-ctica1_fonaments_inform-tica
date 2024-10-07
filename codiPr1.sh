#!
#!/bin/bash
cut -d',' -f1-11,13-15 supervivents.csv > superviventsModificat1.csv

awk -F',' '$14 != "True"' "superviventsModificat1.csv" > "superviventsModificat2.csv"
eliminats=$(awk -F',' '$14 == "True"' "superviventsModificat1.csv" | wc -l)               
echo "S'han eliminat $eliminats registres amb errors o vídeos esborrats."

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

