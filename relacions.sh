#!/bin/bash
#!/bin/bash

# Definir els noms dels fitxers d'entrada i sortida
fitxer_entrada="superviventsModificat31.csv"
fitxer_sortida="superviventsModificat4.csv"

# Escriure la capçalera amb les noves columnes Rlikes i Rdislikes al fitxer de sortida
head -n 1 "$fitxer_entrada" | awk -F',' '{print $0",Rlikes,Rdislikes"}' > "$fitxer_sortida"

# Processar cada línia del fitxer d'entrada (a partir de la segona línia)
tail -n +2 "$fitxer_entrada" | while read -r linia; do
    # Extreure les columnes de views (columna 8), likes (columna 9), i dislikes (columna 10)
    views=$(echo "$linia" | cut -d',' -f8)
    likes=$(echo "$linia" | cut -d',' -f9)
    dislikes=$(echo "$linia" | cut -d',' -f10)

  
    # Calcular Rlikes i Rdislikes amb 2 decimals
    Rlikes=$(echo "scale=2; ($likes * 100) / $views)" | bc)
    Rdislikes= $(echo "scale=2; ($dislikes * 100) / $views)" | bc)


    # Escriure la línia original amb les noves columnes calculades al fitxer de sortida
    echo "$linia,$Rlikes,$Rdislikes" >> "$fitxer_sortida"
done

