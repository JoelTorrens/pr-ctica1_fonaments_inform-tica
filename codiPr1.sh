#!
#!/bin/bash
cut -d',' -f1-11,13-15 supervivents.csv > superviventsModificat1.csv
awk -F',' '$14 != "True"' "superviventsModificat1.csv" > "superviventsModificat2.csv"
eliminats=$(awk -F',' '$14 == "True"' "superviventsModificat1.csv" | wc -l)               
echo "S'han eliminat $eliminats registres amb errors o vídeos esborrats."

